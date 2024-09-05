#!/bin/sh


script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ${script_dir}/env.sh

var="0_3_0.pres-sfc-an-gauss"
dir_var="ps"

data_dir=${archive_dir}/${dir_var}


if [ ! -d ${data_dir} ]; then
    echo "Creating ${data_dir}"
    mkdir -p ${data_dir}
fi

cd $data_dir


for yyyy in `seq -w 1960 1960`; do
    for mm in `seq -w 01 12`; do

        echo "$yyyy-$mm"

        d2=$(date -d "$yyyy/$mm/1 + 1 month - 1 day" "+%d")

        wget -N https://data.rda.ucar.edu/d640000/anl_surf/${yyyy}${mm}/jra3q.anl_surf.${var}.${yyyy}${mm}${dd1}00_${yyyy}${mm}${dd2}18.nc
    
    done
done
