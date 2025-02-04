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

foreach yyyy ( `seq -w 2025 2025` )
set months = jan #year or jan

if ( $months == "year" ) then
    set mms = ( 01 02 03 04 05 06 07 08 09 10 11 12)
else if  ($months == "jan" ) then
    set mms = ( 01 )
else
    exit -1
endif
echo $mms

#untar file(s) if necessary
#cd ${infilesDir}
#tar -xf $infile
  
cd ${work_dir}

# check the input files existence
foreach mm ( $mms )
    ls -lh ${infilesDir}/ps/jra3q.anl_surf.0_3_0.pres-sfc-an-gauss.$yyyy$mm*.nc
    if ( $status != 0 ) then
        echo "Errors in the following files"
        echo "ls -lh ${infilesDir}/ps/anl_surf.001_pres.reg_tl319.$yyyy$mm*.nc"
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

    set infiles = $infilesDir/ps/jra3q.anl_surf.0_3_0.pres-sfc-an-gauss.$yyyy$mm*.nc
    echo $infiles
    cp $infiles infile.nc

    #extract ps variable to remove unnecessary dimensions and metadata
    ncks -v pres-sfc-an-gauss infile.nc infile_ps.nc
        
    #change from nc4 to nc3 for ncrename bug
    ncks -3 infile_ps.nc infile3.nc    

    ncrename -v pres-sfc-an-gauss,PS infile3.nc

    @ lmax = `ncdump -h infile3.nc | grep "= UNLIMITED ; // (" | awk '{print $6}' | sed s/\(//`
    echo $lmax
    @ ll = 1
    while ($ll <= $lmax )
        ncks -F -O -d time,$ll infile3.nc PS.$yyyy$mm.$ll.nc
        @ ll ++
    end
    mv PS.$yyyy$mm.*.nc $outdir/.
    @ mm ++

    #clean up infiles
    rm -f infile_ps.nc
    rm -f infile3.nc
end

ls -l ${base_dir}/$yyyy??/PS.$yyyy??.*.nc
ls -l ${base_dir}/$yyyy??/PS.$yyyy??.*.nc | wc
# should have 1460 (365*4 ) for non-leap years

end #foreach yyyy
