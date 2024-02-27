Feb. 2024 - Documentation from Fanrong Zeng

# Step-by-step guide to running SPEAR decadal prediction experiments

Real-time decadal predictions are conducted annually at GFDL SD division. Each year by the end of February, the predictions are made and sent to WMO Lead Centre for Interannual to Decadal Prediction, an operational service that provides annually-updated multi-model decadal predictions. This article lists the commands to run the GFDL decadal predictions initialized from January 2024 with the SPEAR_LO model.
Download JRA-55 6hr Jan 2023 to Jan 2024 data

## Edit jra55/env.csh
Edit the `jra55/env.csh` file to specify the raw data `$infilesDir` and work directory `$work_dir`for the JRA55 data.

## download jra55 6hr surface pressure and atmospheric T, U, V, Q data
Go to https://rda.ucar.edu/datasets/ds628.0/dataaccess/ and move downloaded data to `$infilesDir`.

## download surface pressure data
click on data access and scroll down to find the JRA-55 6-Hourly Model Resolution Surface Analysis Fields
downloaded surface pressure files,  e.g.  anl_surf.001_pres.reg_tl319.2022050100_2022053118-319.2022120100_2022123118.zeng613294.nc.tar

make sure to select converted files to download the netcdf format files.

## download atmospheric data
Using the same steps to download the atmospheric U, V, T, and Q data by clicking on JRA-55 6-Hourly Model Resolution Model Level Analysis Fields

Only GRB format data were available for the January 2024 atmospheric U, V, T, and Q data at the time of writing this guide.. Downloaded the GRB files and used the ncl command to convert to netcdf format,

    ncl_convert2nc theGRBfiles -e grb -l -nc4

You may need to run the ncks command to set time as the record dimension,

    ncks -O --mk_rec_dmn initial_time0_hours  in.nc out.nc

## Pre-processing the downloaded JRA-55 6hr data

### break the ps files into multiple 1-month files.

### check the downloaded files for jan-dec 2023
    ls -l $infilesDir/anl_surf.0001_pres.reg*2023*_2023*.nc

### Process the files

Set the variable `$yyyy` in the script before running.

    jra55/ecda.grain.JRA55.ps.1yr.csh
 
### check the downloaded files for jan 2024
    ls -l $infilesDir/anl_surf.0001_pres.reg*2024*_2024*.nc # list of input files
 
### process the files

Set the variable `$yyyy` in the script before running.

    jra55/ecda.grain.JRA55.ps.jan.csh
 
### check the output files,
    ls  $base_dir/202[34]??/PS.202[34]??.*.nc
 
 should have 1460 (365*4 ) files  for non-leap years and 1464 files for leap years.

### Process the  atmos files into 1-month files.
Each of the atmos files contains 10-day data.  Run the following script to create monthly files,

Set the `$yyyy` and `$months` variables in the script before running.

    jra55/ecda.grain.JRA55.csh

### check the output files,
    ls  $base_dir/202[34]??/{011_tmp,033_ugrd,034_vgrd,051_spfh}*202[34]??.*.nc

### combine the surface and atmospheric files

Set the `$yyyy` variable in the script before running.

    jra55/run_combine_JRA55.csh

Run the combine script for January 2024.

    jra55/ecda.combine.JRA55.all_vars.csh 2024 01

### check the output files,
    ls  $base_dir/2023/*
    ls  $base_dir/2024/*

###  regrid the combined files onto SPEAR_LO atmos grid
    jra55/ecda.regrid.JRA55.csh 2023
    jra55/ecda.regrid.JRA55.csh 2024

### check the output files,
    ls -l  $base_dir/{2023,2024}/*

### transfer to gaea
gcp the files in $base_dir/{2023,2024} to gaea, /gpfs/f5/gfdl_sd/world-shared/Xiaosong.Yang/archive/ada_data/JRA55/2023

## Extend ERSST monthly mean SST  to Jan 2024

### download monthly mean ERSST SST up to January 2024

Set the `$base_dir` and `$archive_dir` variables in `ersst/env.csh` to specify where the data will be downloaded and transferred to.

Run `ersst/download_ersst.csh` to download `sst.mnmean.nc` from https://psl.noaa.gov/data/gridded/data.noaa.ersst.v5.html.

### ersst file is on lat/lon grid, run the script to regrid it unto SPEAR_LO ocean grid
    ersst/data_sst.mnmean.v5.spear_lo.csh

### transfer to gaea
    gcp SPEAR_lo_tripolar.sst.nc gaea:/gpfs/f5/gfdl_sd/world-shared/Fanrong.Zeng/module_data/SPEAR/ersst.sst.mnmean.v5.nc

## Extend reanalysis to dec. 2023

The 10-members are run in two 5-member ensembles, `SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst` and `SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10`.
The runs  have completed jan1958-dec2022, and need to extend to dec.2023.

### expt: SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst

take the jan.2023 initial conditions and transfer to gaea:

    gcp  /archive/fjz/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst/restart/20230101.tar gaea:/gpfs/f5/gfdl_sd/world-shared/Fanrong.Zeng/module_data/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_restart_20230101.tar

### re-generate runscript
Login to gaea5X
    module load fre/bronx-21
    frerun --platform=ncrc5.intel-classic --target=repro,openmp -x xml/SPEAR_experiments_Q50L33_c96_o1_HIST_jra55_B01_1958.C5.xml  SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst

### submit the runscript
    sbatch /gpfs/f5/gfdl_sd/scratch/Fanrong.Zeng/SPEAR_experiments_Q/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst/ncrc5.intel-classic-repro-openmp/scripts/run/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst
 
### setup and run members 06-10
Same as for the members 01-05 but setup the runscript based on  `SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10`
The initial conditions are transferred to gaea via this command
    gcp  /archive/fjz/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10/restart/20230101.tar gaea:/gpfs/f5/gfdl_sd/world-shared/Fanrong.Zeng/module_data/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10_restart_20230101.tar

## Run 2024 decadal predictions from the Jan. 2024 initial conditions

The 10-member prediction runs are conducted in two 5-member ensembles with the same experiment name i20240101 but under different directories.

### run prediction experiment: i20240101 for members 01-05

### combine initial conditions for members 01-05 and ens06-10.
Set `restart_file` to the restart from the reanalysis run. 
    
    combine.restart.5ees

### xml/runscript  for prediction:  i20240101 members 01-05
 start from `xml/SPEAR_experiments_K_DecPred_icJRA_ERSST.bronx-21_C5.xml`
 set initCond to restart-file-2024 created above
generate runscript using frerun.

these are the commands used for 2023 predictions

    module load fre/bronx-21
    frerun  -x /autofs/ncrc-svm1_home1/Colleen.McHugh/SPEAR_xml/xml/SPEAR_experiments_K_DecPred_icJRA_ERSST.bronx-21_C5.Colleen.xml --platform=ncrc5.intel-classic --qos=urgent --target=repro,openmp i20240101
    sbatch the runscript

### run prediction experiment: i20240101 for members 06-10
Following the same steps as for members 01-05 using the xml `xml/SPEAR_experiments_K_DecPred_icJRA_ERSST_ens_06-10.bronx-21_C5.xml`. Make sure to start from the 20240101 restart file from expt: `SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10`
