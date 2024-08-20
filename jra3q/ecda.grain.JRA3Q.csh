#!/bin/csh -f

set echo

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

#remove work_dir and recreate it
#if ( -e ${work_dir} ) then
#    rm -rf ${work_dir}
#endif

#mkdir ${work_dir}

#run for all months in 2023 and january 2024

set yyyy =  $1
set months =  year # year or jan

if ($months == "year" ) then
  set mms = ( 01 02 03 04 05 06 07 08 09 10 11 12)
else if  ($months == "jan" ) then
  set mms = ( 01 )
else
  exit -1
endif
echo $mms

#cd ${work_dir}

# check the input files existence 
foreach mm ( $mms )
foreach dirvar(temp uwnd vwnd spfh)
  @ ll_fname = 1 #reset for each new variable
  if ($dirvar == temp) then
    set invar = tmp-hyb-an-gauss
    set str = 0_0_0
  else if ($dirvar == uwnd) then 
    set invar = ugrd-hyb-an-gauss
    set str = 0_2_2
  else if ($dirvar == vwnd) then 
    set invar = vgrd-hyb-an-gauss
    set str = 0_2_3
  else if ($dirvar == spfh) then 
    set invar = spfh-hyb-an-gauss
    set str = 0_1_0
  endif
  echo $yyyy $mm $invar
  ls -lh $infilesDir/$dirvar/jra3q.anl_mdl.$str.$invar.$yyyy$mm*.nc | wc | grep " 6 "
  if ( $status != 0 ) then
    echo "Errors in the following files"
    echo "ls -lh $infilesDir/$dirvar/jra3q.anl_mdl.$str.$invar.$yyyy$mm*.nc "
    exit 1
  endif

  echo $invar $yyyy $mm
  set outdir = ${base_dir}/$yyyy$mm

  # check if outfiles exist
  set checkingfiles = `ls $outdir/$invar.*.nc | wc | awk '{print $1}'`
  if ( $checkingfiles >= 112 ) then
       echo "found $checkingfiles files, exit 0"
       ls  $outdir/$invar.*.nc
       continue
  endif

  if ( ! -e ${outdir} ) then
    echo "Creating ${outdir}"
    mkdir -p ${outdir}
  endif

  cd ${outdir}

  set infiles = $infilesDir/$dirvar/jra3q.anl_mdl.$str.$invar.$yyyy$mm*
  foreach infile ( $infiles)
    set fileext = `echo $infile:t:e`
    if ( $fileext == gz ) then
      gzip -d $infile:t
      ls $infile:t:r
    #else
      #cp $infile .
    endif
  #end foreach infile

  set ff = $infile 
  ls -l $ff
  @ lmax = `ncdump -h $ff | grep "= UNLIMITED ; // (" | awk '{print $6}' | sed s/\(//`
  @ ll = 1
  echo $lmax
  while ($ll <= $lmax )
    ncks -F -O -d time,$ll -v $invar $ff $invar.$yyyy$mm.$ll_fname.tmp.nc
    ncks -3 $invar.$yyyy$mm.$ll_fname.tmp.nc $invar.$yyyy$mm.$ll_fname.nc
    if ( $? == 0 ) then
        rm -f $invar.$yyyy$mm.$ll_fname.tmp.nc
    endif
    ls -l $invar.$yyyy$mm.$ll_fname.nc
    @ ll ++
    @ ll_fname ++
  end 

  # rename
    foreach f ($invar.$yyyy$mm.*.nc)
       ncrename -v ${invar},${dirvar} -d hybrid_level,lev -v hybrid_level,lev $f
    end 
  #mkdir -p $outdir
  #mv -f $invar.$yyyy$mm.*.nc $outdir/.

end #foreach infile
end #foreach dirvar
end #foreach mm


