# Download JRA-3Q data

- Edit years, and months in `download_data/` scripts and download directory location in `download_data/env.sh`. Currently the scripts should be run on PP/AN to download the data directly to `/archive`. The scripts can be run in parallel for each variable.

- Data can be also be found at https://rda.ucar.edu/datasets/ds640.0/dataaccess/

# Extract data for each timestep

- `ecda.grain.JRA3Q_month.csh ${year} ${mm} ${var}` should be run for each 3D variable (`temp uwnd vwnd spfh`) to extract the data for each timestep.

- `ecda.grain.JRA3Q.ps.csh` should be run for each year to extract each timestep for the PS variable.

- To run the 3D variables in parallel, first edit the start and end years/months in `submit_jobs/submit_jra3q_extract_month.csh` and run from PP/AN to submit batch jobs in parallel.


# Combine all variables for each timestep

- After data is extracted for each variable above, all variables should be combined at each timestep.

- `ecda.combine.JRA3Q.month.csh ${year} ${mm}` should be run for each month. To submit the jobs in parallel, edit the start and end years / months and run `submit_jobs/submit_jra3q_combine_month.csh`.

# Regrid files

- After the files have been combined, regrid each file to the SPEAR_LO c96 grid.

- `ecda.regrid.JRA3Q.month.csh ${year} ${mm}` should be run for each month on PP/AN. To submit the jobs in parallel, edit the start and end years / months and run `submit_jobs/submit_jra3q_regrid_month.csh` to submit jobs to the batch system.

- Final output is moved to the `$archive_dir` set in `env.csh`.
