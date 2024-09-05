#!/bin/csh

#wrapper to submit regrid jra3q jobs

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

cd ${script_dir}

#years to process
set yr1=1960
set yr2=1963

#months to process
set mm1=01
set mm2=12

foreach year (`seq -w ${yr1} ${yr2}`)
    foreach month (`seq -w ${mm1} ${mm2}`)

            sed -e "s/yyyy/${year}/g" -e "s/mm/${month}/g" jra3q_regrid_stub.csh > submit_jra3q_regrid_mm.csh

            sbatch submit_jra3q_regrid_mm.csh
        end
    end
end

