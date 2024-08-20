#! /bin/sh
#
# Experienced Wget Users: add additional command-line flags here
#   Use the -r (--recursive) option with care
set opts = "-N"
#
# If you get a certificate verification error (version 1.10 or higher),
# uncomment the following line:
#set cert_opt = "--no-check-certificate"
#


var="0_0_0.tmp-hyb-an-gauss"
dir_var="temp"

data_dir=/archive/cem/jra3q/${dir_var}

if [ ! -d ${data_dir} ]; then
    echo "Creating ${data_dir}"
    mkdir -p ${data_dir}
fi

cd $data_dir

for yyyy in `seq -w 1960 1960`; do
    for mm in `seq -w 01 12`; do

        echo "$yyyy-$mm"

        num_days=$(date -d "$yyyy/$mm/1 + 1 month - 1 day" "+%d")

        for dd1 in `seq -w 01 5 $num_days`; do
            dd2=$( printf "%.02d\\n" $(($dd1+4)) )
            if [[ $(($dd2+1)) -ge $num_days ]]; then
                dd2=$num_days

                wget -N https://data.rda.ucar.edu/ds640.0/anl_mdl/${yyyy}${mm}/jra3q.anl_mdl.${var}.${yyyy}${mm}${dd1}00_${yyyy}${mm}${dd2}18.nc
                break 
            else
               wget -N https://data.rda.ucar.edu/ds640.0/anl_mdl/${yyyy}${mm}/jra3q.anl_mdl.${var}.${yyyy}${mm}${dd1}00_${yyyy}${mm}${dd2}18.nc
            fi
        done
    done
done

