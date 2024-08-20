#!/bin/csh -f

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

#these files are used to convert the JRA vertical levels to GFDL vertical levels

### put ak, bk, surface geopotential, and all invars into the final outfile
#set outdir =  ${base_dir}/$yyyy
set outdir = /work/cem/jra3q/testing 
if ( ! -e $outdir) mkdir $outdir
cd $outdir

ncks -3 akbk.nc akbk3.nc

ncap2 -O -v -s 'hyai=HYAI.reverse($hlevi)'  akbk3.nc foo.nc  
ncap2 -A -v -s 'hybi=HYBI.reverse($hlevi)' akbk3.nc foo.nc 
ncap2 -A -v -s 'hyam=HYAM.reverse($levi)' akbk3.nc foo.nc 
ncap2 -A -v -s 'hybm=HYBM.reverse($levi)' akbk3.nc foo.nc 
mv foo.nc akbk_out.nc

ncrename -v hyai,HYAI -v hybi,HYBI -v hyam,HYAM -v hybm,HYBM akbk_out.nc

ncks -4 akbk_out.nc akbk_out2.nc

rm -f foo.nc akbk3.nc

