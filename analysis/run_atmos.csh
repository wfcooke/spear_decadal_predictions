#!/bin/csh

echo "Creating atmos component files from decadal prediction"

# Location of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

set year = 2024

if ( ! -e ${work_dir} ) then
    mkdir -p ${work_dir}
    if ( $? != 0 ) then
        echo "Error. Could not create directory ${work_dir}"
        exit 1
    endif
endif

if ( ! -e ${out_dir} ) then
    mkdir -p ${out_dir}
    if ( $? != 0 ) then
        echo "Error. Could not create directory ${out_dir}"
        exit 1
    endif
endif

#run precipitation processing scripts
set atmos_vars=(t_ref t_surf slp precip)

foreach var (${atmos_vars})

    echo "Processing ${var}"

    matlab910 -nodesktop -nosplash -r "cd('${script_dir}/'); try create_var_full_field('${var}', ${year}, '${work_dir}', '${out_dir}'), catch, exit(1), end, exit(0)"

    if ( $? != 0 ) then
        echo "Error in create_var_full_field. Exiting"
        exit 1
    endif

    matlab910 -nodesktop -nosplash -r "cd('${script_dir}/'); try create_var_anom('${var}', ${year}, '${work_dir}', '${out_dir}'), catch, exit(1), end, exit(0)"


end
