#!/bin/csh -f

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

mkdir ${base_dir}/old
set yyyy = $1

  cd ${base_dir}
  # mv $yyyy/* files to old/$yyyy/.
  mkdir old/$yyyy
  mv $yyyy/* old/$yyyy/.
  # Delete "string " from the nc files if present
  cd old/$yyyy
  foreach f (*.nc)
    ncdump -h $f | grep "string "
    if ($status == 0 ) then
       mv $f old.nc
       ncdump old.nc | sed s/"string "// > tt.cdl
       ncgen -o $f -k 4 tt.cdl
       ls -l $f
       rm -f old.nc tt.cdl
    endif
  end
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

# final checking the file size
    echo $yyyy
    ls -lh ${indir}/*.nc | grep "190M" # the original files
    ls -lh ${outdir}/*.nc | grep "96M"  # outfiles created
