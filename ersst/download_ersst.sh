#!/bin/sh

# Location of thie script
BIN_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

# Source the env.sh file for the current environment
. ${BIN_DIR}/env.sh

raw_dir=${BASE_DIR}/raw

if [ ! -e ${raw_dir} ]
then
    echo "Creating directory ${raw_dir}"
    mkdir -p ${raw_dir}
    if [ $? -ne 0 ] then
        echo "Unable to create raw output directory $raw_dir"
        exit 1
    fi
fi   

cd ${raw_dir}

echo "Downloading ERSST data"
wget https://psl.noaa.gov/thredds/fileServer/Datasets/noaa.ersst.v5/sst.mnmean.nc

#TODO
#the raw data should include Jan 1 of the current year
