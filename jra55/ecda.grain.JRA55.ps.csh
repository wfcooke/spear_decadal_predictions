#!/bin/csh -f

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

#remove work_dir and recreate it
if ( -e ${work_dir} ) then
    rm -rf ${work_dir}
endif

mkdir -p ${work_dir}

# grain surface pressure, 1-yr file, into 12  monthly files

set yyyy = 2023
set months = jan #year or jan

if ( $months == "year" ) then
    set mms = ( 01 02 03 04 05 06 07 08 09 10 11 12)
else if  ($months == "jan" ) then
    set mms = ( 01 )
else
    exit -1
endif
echo $mms

#TODO: file should already be untarred in ${infilesDir}
#Naming convention of downloaded tar files?
set infile = ${infilesDir}/anl_surf.001_pres.reg_tl319.2023010100_2023013118-319.2023120100_2023123118.zeng723562.nc.tar # $2

cd ${infilesDir}

tar -xf $infile
  
cd ${work_dir}

# check the input files existence
foreach mm ( $mms )
    ls -lh ${infilesDir}/anl_surf.001_pres.reg_tl319.$yyyy$mm*.nc
    if ( $status != 0 ) then
        echo "Errors in the following files"
        echo "ls -lh ${infilesDir}/anl_surf.001_pres.reg_tl319.$yyyy$mm*.nc"
    endif
#end

    set outdir = ${base_dir}/$yyyy$mm
    if ( ! -e $outdir ) mkdir -p $outdir
    # check if outfiles exist
    echo "checking to see if outfiles exist in $outdir/PS.*.nc"
    set checkingfiles = `ls $outdir/PS.*.nc | wc | awk '{print $1}'`
    if ( $checkingfiles >= 112 ) then
        echo "found $checkingfiles files, exit 0"
        ls  $outdir/PS.*.nc
        continue
    else
        echo "No outfiles found, continuing."
    endif


    set infiles = $infilesDir/anl_surf.001_pres.reg_tl319.$yyyy$mm*.nc
    echo $infiles
    cp $infiles infile.nc
    ncrename -v PRES_GDS4_SFC,PS infile.nc

    @ lmax = `ncdump -h infile.nc | grep "= UNLIMITED ; // (" | awk '{print $6}' | sed s/\(//`
    echo $lmax
    @ ll = 1
    while ($ll <= $lmax )
        ncks -F -O -d initial_time0_hours,$ll infile.nc PS.$yyyy$mm.$ll.nc
        @ ll ++
    end

    # rename
    foreach f (PS.$yyyy$mm.*.nc)
       ncrename -v initial_time0_hours,time -v g4_lat_1,lat -v g4_lon_2,lon -d initial_time0_hours,time -d g4_lat_1,lat -d g4_lon_2,lon $f
    end
    mv PS.$yyyy$mm.*.nc $outdir/.
    @ mm ++
end

ls -l ${base_dir}/$yyyy??/PS.$yyyy??.*.nc
ls -l ${base_dir}/$yyyy??/PS.$yyyy??.*.nc | wc
# should have 1460 (365*4 ) for non-leap years

