#!/bin/csh

# Location of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

if ( ! -e ${raw_dir} ) then
    echo "Creating directory ${raw_dir}"
    mkdir -p ${raw_dir}
    if ( $? != 0 ) then
        echo "Unable to create raw output directory $raw_dir"
        exit 1
    endif
endif

cd ${raw_dir}

echo "Downloading ERSST data"
wget https://psl.noaa.gov/thredds/fileServer/Datasets/noaa.ersst.v5/sst.mnmean.nc

#TODO
#the raw data should include Jan 1 of the current year
