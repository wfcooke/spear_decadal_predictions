#!/bin/csh -f

# 2/5/2024 downloaded sst.mnmean.nc from https://psl.noaa.gov/data/gridded/data.noaa.ersst.v5.html
# sst.mnmean.nc contains monthly values from 1854/01 to 2024/01
#
# Regrid obs files on latlon grid to SPEAR_LO tripolar grid

# Location of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

set tmp_dir = ${base_dir}/tmp

#remove the old tmp dir and recreate
if ( -e ${tmp_dir} ) then
    rm -rf ${tmp_dir}
endif

mkdir -p ${tmp_dir}
if ( $? != 0 ) then
    echo "Unable to create directory $tmp_dir"
    exit 1
endif

cd ${tmp_dir}

set infile = ${raw_dir}/sst.mnmean.nc

# fix time axis
cdo settaxis,1854-01-16,12:00:00,1mon $infile infile.nc

# fill the land
cat << EOF > fill.jnl
use infile.nc
let new = sst[i=@FNR]
let new1 = new[j=@FNR]
set win 1;shade/lev=(-2 35 1) sst[l=1];go land
set win 2;shade/lev=(-2 35 1) new1[l=1];go land
set win 3;shade sst[l=1] - new[l=1];go land
set mem/siz=20000
save/file=new.nc/clo new
sp ncrename -v NEW,sst new.nc
quit

EOF

pyferret -script fill.jnl

### regrid SST file
set invar = sst

#ncpdq -O -h -a -lat $infile infilelatlon.nc

cp ${script_dir}/data/ocean_hgrid.nc ocean_hgrid.nc
cp ${script_dir}/data/ocean_mosaic.LOAR2.nc ocean_mosaic.nc

# create the mosiac file for the input file
make_hgrid --grid_type regular_lonlat_grid --nxbnd 2 --nybnd 2 --xbnd 0.0,360.0 \
   --ybnd -90.0,90.0 --nlon 360 --nlat 178 --grid_name lat_lon_grid
make_solo_mosaic --num_tiles 1 --dir ./ --mosaic_name lat_lon_mosaic \
    --tile_file lat_lon_grid.nc --periodx 360

# Create
fregrid --input_mosaic lat_lon_mosaic.nc \
        --output_mosaic ocean_mosaic.nc \
        --input_dir ./ --input_file new.nc --scalar_field $invar \
        --output_file SPEAR_lo_tripolar.$invar.nc 

# rename
ncrename -v LAT,YH -v LON,XH -v TIME,time -d LAT,YH -d LON,XH -d TIME,time -v sst,temp  SPEAR_lo_tripolar.$invar.nc
# gregorian calendar?
ncatted -O -a calendar,time,m,c,gregorian SPEAR_lo_tripolar.$invar.nc

ls -l SPEAR_lo_tripolar.$invar.nc

gcp -v -cd SPEAR_lo_tripolar.$invar.nc ${archive_dir}
