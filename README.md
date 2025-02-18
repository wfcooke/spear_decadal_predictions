Last updated Feb. 2025

# Step-by-step guide to running SPEAR decadal prediction experiments

Real-time decadal predictions are conducted annually at GFDL SD division. Each year by the end of February, the predictions are made and sent to [WMO Lead Centre for Interannual to Decadal Prediction](https://hadleyserver.metoffice.gov.uk/wmolc/), an operational service that provides annually-updated multi-model decadal predictions.

## Download JRA-3Q data

- Edit years, and months in `download_data/` scripts and download directory location in `download_data/env.sh`. Currently the scripts should be run on PP/AN to download the data directly to `/archive`. The scripts can be run in parallel for each variable.

- Data can be also be found at https://rda.ucar.edu/datasets/ds640.0/dataaccess/

If necessary, grib files can be converted to netcdf files using the following command

    ncl_convert2nc theGRBfiles -e grb -l -nc4

You may need to run the ncks command to set time as the record dimension,

    ncks -O --mk_rec_dmn initial_time0_hours  in.nc out.nc

## Extract data for each timestep

- `ecda.grain.JRA3Q_month.csh ${year} ${mm} ${var}` should be run for each 3D variable (`temp uwnd vwnd spfh`) to extract the data for each timestep.

- `ecda.grain.JRA3Q.ps.csh` should be run for each year to extract each timestep for the PS variable.

- To run the 3D variables in parallel, first edit the start and end years/months in `submit_jobs/submit_jra3q_extract_month.csh` and run from PP/AN to submit batch jobs in parallel.


## Combine all variables for each timestep

- After data is extracted for each variable above, all variables should be combined at each timestep.

- `ecda.combine.JRA3Q.month.csh ${year} ${mm}` should be run for each month. To submit the jobs in parallel, edit the start and end years / months and run `submit_jobs/submit_jra3q_combine_month.csh`.

## Regrid files

- After the files have been combined, regrid each file to the SPEAR_LO c96 grid.

- `ecda.regrid.JRA3Q.month.csh ${year} ${mm}` should be run for each month on PP/AN. To submit the jobs in parallel, edit the start and end years / months and run `submit_jobs/submit_jra3q_regrid_month.csh` to submit jobs to the batch system.

- Final output is moved to the `$archive_dir` set in `env.csh`.

## Transfer to gaea
gcp the files in `$archive_dir` to gaea. Files are in `/gpfs/f5/gfdl_sd/world-shared/Colleen.McHugh/jra3q/`.

## Create jra3q_filelist

    ls -d /gpfs/f5/gfdl_sd/world-shared/Colleen.McHugh/jra3q/{2024,2025}/*.nc > /gpfs/f5/gfdl_sd/world-shared/Colleen.McHugh/jra3q/jra3q_filelist/jra3q_file_names_2024

## Extend ERSST monthly mean SST to Jan 2025

#### Download monthly mean ERSST SST up to January 2025

Set the `$base_dir` and `$archive_dir` variables in `ersst/env.csh` to specify where the data will be downloaded and transferred to.

Run `ersst/download_ersst.csh` to download `sst.mnmean.nc` from https://psl.noaa.gov/data/gridded/data.noaa.ersst.v5.html.

#### Ersst file is on lat/lon grid, run the script to regrid it unto SPEAR_LO ocean grid
    ersst/data_sst.mnmean.v5.spear_lo.csh

#### Transfer to gaea
    gcp SPEAR_lo_tripolar.sst.nc gaea:/gpfs/f5/gfdl_sd/world-shared/Colleen.McHugh/ersst/SPEAR_lo_tripolar.sst.nc

## Extend reanalysis to Dec. 2024

The 10-members are run in two 5-member ensembles, `SPEAR_Q50L33_c96_o1_Hist_AllForc_jra3q_B01_1960_ersst` and `SPEAR_Q50L33_c96_o1_Hist_AllForc_jra3q_B01_1960_ersst_ens_06-10`.

#### expt: SPEAR_Q50L33_c96_o1_Hist_AllForc_jra3q_B01_1960_ersst

#### xml: SPEAR_experiments_Q50L33_c96_o1_HIST_jra3q_B01_1958.C5.xml

if necessary, take the Jan 2024 initial conditions and transfer to gaea:

    /archive/cem/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra3q_B01_1960_ersst/restart/

    /archive/cem/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra3q_B01_1960_ersst_ens_06-10/restart/

#### Re-generate and submit the runscript
Login to gaea5X
    
    module load fre/bronx-22
    
    frerun --platform=ncrc5.intel23_2_0 --qos=normal --target=repro,opemp --transfer --walltime=240 --xmlfile=/ncrc/home1/Colleen.McHugh/git/spear_decadal_predictions/xml/SPEAR_experiments_Q50L33_c96_o1_HIST_jra3q_B01_1958.C5.xml SPEAR_Q50L33_c96_o1_Hist_AllForc_jra3q_B01_1960_ersst
 
#### Setup and run members 06-10
Same as for the members 01-05 but setup the runscript based on  `SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10`

## Run 2024 decadal predictions from the Jan. 2024 initial conditions

The 10-member prediction runs are conducted in two 5-member ensembles with the same experiment name i20240101 but under different directories.

#### Combine initial conditions for members 01-05 and ens06-10.
Set `restart_file` to the restart from the reanalysis run. Run twice for `restart_file= SPEAR_Q50L33_c96_o1_Hist_AllForc_jra3q_B01_1960_ersst` and `restart_file =  SPEAR_Q50L33_c96_o1_Hist_AllForc_jra3q_B01_1960_ersst_ens_06-10`
    
    combine.restart.5ees

#### Run prediction experiment: i20240101 for members 01-05

start from `SPEAR_experiments_K_DecPred_icJRA3Q_ERSST.xml` and set initCond to restart-file-2025 created above. The generate runscript using frerun.

These are the commands used for 2025 predictions

    module load fre/bronx-22
    
    frerun --platform=ncrc5.intel23_2_0 --qos=normal --target=repro,openmp --xmlfile=/ncrc/home1/Colleen.McHugh/git/spear_decadal_predictions/xml/SPEAR_experiments_K_DecPred_icJRA3Q_ERSST.xml i20250101_jra3q

### Run prediction experiment: i20240101 for members 06-10
Following the same steps as for members 01-05 using the xml `xml/SPEAR_experiments_K_DecPred_icJRA3Q_ERSST_ens_06-10.xml`. Make sure to start from the 20250101 restart file crated above.

## Prepare and submit the output

From Liping Zhang.

The Met Office asks for 6 variables: surface temperature, air temperature, precipitation, sea level pressure, sea ice extent, and AMOC. For each variable two sets of files are created and submitted, the full forecast field and anomaly field.

The GFDL pp components and variables used are:
- atmos t_surf
- atmos t_ref
- atmos precip
- atmos slp
- ice EXT
- ocean_z vh

The January 2024 prediction pp directories are: `/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst/i20240101/` and `/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst_ens_06-10/i20240101/`.

Edit `analysis/env.csh` to specify where the intermediate files (`$work_dir`) and the NetCDF files will be saved (`$out_dir`).

Run the following scripts to create the output files from the GFDL pp files:

- For atmospheric variables t_surf, t_ref, precip, and slp:
    
    `analysis/run_atmos.csh`

- For sea ice:
    
    `analysis/run_ext.csh`

- For AMOC:
    
    `analysis/run_amoc.csh`

The data is then uploaded to a google drive and sent to the Met Office.
