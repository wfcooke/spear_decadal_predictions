#!/bin/csh -f

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

set yyyy = $1
set mm = $2

cd ${base_dir}

if ( ! -e old/$yyyy ) then
    mkdir -p old/$yyyy
    echo "moving files to ${base_dir}/old/${yyyy}"
    mv $yyyy/* old/$yyyy/
endif

cd old/$yyyy
  
# specify outdir
set outdir = ${base_dir}/$yyyy
# specify indir
set indir = ${base_dir}/old/$yyyy
echo $indir
set tmpdir = ${base_dir}/tmpdir/${yyyy}${mm}

mkdir -p $outdir

if ( ! -e ${tmpdir} ) then
    mkdir -p ${tmpdir}
endif

cd ${tmpdir} || exit -1

#cd $outdir || exit -1
ls $indir/$yyyy$mm*.nc
foreach infile ($indir/$yyyy$mm*.nc)
    if ( ! -e ${outdir}/$infile:t ) then
        ls -l $infile
        ferret -script "${script_dir}/Regrid_SPEAR_lo.atmos.jnl" "$infile"
        mv new.nc ${outdir}/$infile:t || exit -1

        echo "Checking to see if there's any missing data..."
        #check to see if any data is missing
        python ${script_dir}/check_missing_data.py --infile ${outdir}/$infile:t
   endif
end

if ( ! -e $archive_dir/${yyyy} ) then
    mkdir -p $archive_dir/${yyyy}
endif

exit 0

echo "copying files from $outdir to $archive_dir/${yyyy}/"

cp -r $outdir/${yyyy}${mm}*.nc $archive_dir/${yyyy}/

if ( $? == 0 ) then
    echo "removing files from $outdir/${yyyy}${mm}*.nc"
    rm -f $outdir/${yyyy}${mm}*.nc

endif
