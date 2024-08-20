#Download JRA-3Q data

- Edit years, months, directory location in `download_data/` scripts. Currently the scripts should be run on PP/AN to download the data directly to `/archive`. The scripts can be run in parallel for each variable.

- Data can be also be found at https://rda.ucar.edu/datasets/ds640.0/dataaccess/

#Extract data for each timestep

- `ecda.grain.JRA3Q_month.csh ${year} ${mm} ${var}` should be run for each 3D variable (`temp uwnd vwnd spfh`) to extract the data for each timestep.

- `ecda.grain.JRA3Q.ps.csh` should be run for each year to extract each timestep for the PS variable.

- To run the 3D variables in parallel, submit batch jobs from PP/AN using the following commands:

    foreach year (`seq -w year1 year2`)
    foreach month (`seq -w month1 month2`)
    foreach var(temp uwnd vwnd spfh)
    sed -e "s/yyyy/${year}/g" -e "s/mm/${month}/g" -e "s/dirvar/${var}/g" submit_jobs/submit_jra3q_extract_month.csh > submit_jobs/submit_jra3q_extract_mm.csh
    sbatch submit_jobs/submit_jra3q_extract_mm.csh
    end
    end
    end

#Combine all variables for each timestep

- After data is extracted for each variable above, all variables should be combined at each timestep.

- `ecda.combine.JRA3Q.month.csh ${year} ${mm}` should be run for each month.

#Regrid files

- After the files have been combined, regrid each file to the SPEAR_LO c96 grid. 

- `ecda.regrid.JRA3Q.month.csh ${year} ${mm}` should be run for each month on PP/AN.

- Final output is moved to the `$archive_dir` set in `env.csh`.
