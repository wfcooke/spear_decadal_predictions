#!/bin/csh -f

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

set yyyy = $1

  cd ${base_dir}
  # mv $yyyy/* files to old/$yyyy/.
  if ( ! -e old/$yyyy ) then
    mkdir -p old/$yyyy
    echo "moving files to ${base_dir}/old/${yyyy}"
    mv $yyyy/* old/$yyyy/
  endif
  # Delete "string " from the nc files if present
  cd old/$yyyy
  # specify outdir
  set outdir = ${base_dir}/$yyyy
  # specify indir
  set indir = /${base_dir}/old/$yyyy
  mkdir -p $outdir
  cd $outdir || exit -1
  foreach infile ($indir/$yyyy*.nc)
   if ( ! -e $infile:t ) then
    ls -l $infile
    ferret -script "${script_dir}/Regrid_SPEAR_lo.atmos.jnl" "$infile"
    mv new.nc $infile:t || exit -1
   endif
  end

ls -l $outdir/$yyyy*.nc

cp -r $outdir/ $archive_dir/

# final checking the file size
#echo $yyyy
#ls -lh ${indir}/*.nc | grep "190M" # the original files
#ls -lh ${outdir}/*.nc | grep "96M"  # outfiles created
