#!/bin/csh -f

set echo

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

#remove work_dir and recreate it
if ( -e ${work_dir} ) then
    rm -rf ${work_dir}
endif

mkdir ${work_dir}

#run for all months in 2023 and january 2024

#set yyyy = 2023
#set months = year

set yyyy =  2024
set months =  jan # year or jan

if ($months == "year" ) then
  set mms = ( 01 02 03 04 05 06 07 08 09 10 11 12)
else if  ($months == "jan" ) then
  set mms = ( 01 )
else
  exit -1
endif
echo $mms

# check the input files existence 
foreach mm ( $mms )
foreach invar (011_tmp 033_ugrd 034_vgrd 051_spfh)
  echo $yyyy $mm $invar
  ls -lh $infilesDir/anl_mdl.$invar.reg_tl319.$yyyy$mm*.nc | wc | grep " 3 "
  if ( $status != 0 ) then
    echo "Errors in the following files"
    echo "ls -lh $infilesDir/anl_mdl.$invar.reg_tl319.$yyyy$mm* "
  endif
end
end

#  grain T, U, V, Q to yyyymm files saved in ${base_dir}/$yyyy$mm

cd ${work_dir}

echo $invar $yyyy $mm
foreach invar (011_tmp 033_ugrd 034_vgrd 051_spfh)
foreach mm ($mms)
  if ($invar == 011_tmp)  set varnamein = TMP_GDS4_HYBL
  if ($invar == 033_ugrd) set varnamein = UGRD_GDS4_HYBL 
  if ($invar == 034_vgrd) set varnamein = VGRD_GDS4_HYBL
  if ($invar == 051_spfh) set varnamein = SPFH_GDS4_HYBL

  set outdir = ${base_dir}/$yyyy$mm
  # check if outfiles exist
  set checkingfiles = `ls $outdir/$invar.*.nc | wc | awk '{print $1}'`
  if ( $checkingfiles >= 112 ) then
       echo "found $checkingfiles files, exit 0" 
       ls  $outdir/$invar.*.nc 
       exit 0
  endif

#
  set infiles = $infilesDir/anl_mdl.$invar.reg_tl319.$yyyy$mm*
  foreach infile ( $infiles)
    set fileext = `echo $infile:t:e`
    if ( $fileext == gz ) then
      gzip -d $infile:t
      ls $infile:t:r
    else
      cp $infile .
    endif
  end
  echo ncrcat -O $infiles:gt infile.nc
  ncrcat -O $infiles:gt infile.nc

  set ff = infile.nc
  ls -l $ff
  @ lmax = `ncdump -h $ff | grep "= UNLIMITED ; // (" | awk '{print $6}' | sed s/\(//`
  echo $lmax
  @ ll = 1
  while ($ll <= $lmax )
   #echo ncks -F -O -d initial_time0_hours,$ll -v $varnamein $ff $invar.$ll.nc 
    ncks -F -O -d initial_time0_hours,$ll -v $varnamein $ff $invar.$yyyy$mm.$ll.nc
    ls -l $invar.$yyyy$mm.$ll.nc
    @ ll ++
  end 

  # rename
    foreach f ($invar.$yyyy$mm.*.nc)
       ncrename -d initial_time0_hours,time -d lv_HYBL1,lev -d g4_lat_2,lat -d g4_lon_3,lon -v initial_time0_hours,time -v lv_HYBL1,lev -v g4_lat_2,lat -v g4_lon_3,lon $f
    end 
  mkdir -p $outdir
  mv -f $invar.$yyyy$mm.*.nc $outdir/.
  ls -l $outdir/$invar.$yyyy$mm.*.nc

end
end

exit 0

# checking the existence of output files
foreach mm ( $mms )
  echo $yyyy $mm 
foreach invar (011_tmp 033_ugrd 034_vgrd 051_spfh)
  echo  $invar
  ls -lh ${base_dir}/$yyyy$mm/$invar.$yyyy$mm.*.nc | wc
end
end

