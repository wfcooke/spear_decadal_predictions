Feb. 2024 - Documentation from Fanrong Zeng

# Step-by-step guide to running SPEAR decadal prediction experiments

Real-time decadal predictions are conducted annually at GFDL SD division. Each year by the end of February, the predictions are made and sent to WMO Lead Centre for Interannual to Decadal Prediction, an operational service that provides annually-updated multi-model decadal predictions. This article lists the commands to run the GFDL decadal predictions initialized from January 2024 with the SPEAR_LO model.
Download JRA-55 6hr Jan 2023 to Jan 2024 data

## download jra55 6hr surface pressure and atmospheric T, U, V, Q data
Go to https://rda.ucar.edu/datasets/ds628.0/dataaccess/

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

Pre-processing the downloaded JRA-55 6hr data

break the ps files into multiple 1-month files and save in /work/$user/jra55/yyyymm/.
 ## check the downloaded files for jan-dec 2023
    ls -l anl_surf.0001_pres.reg*2023*_2023*.nc
 ## process the files
    /nbhome/fjz/sdDecPre/ecda.grain.JRA55.ps.1yr.csh 2023
 ## check the downloaded files for jan 2024
    ls -l anl_surf.0001_pres.reg*2024*_2024*.nc # list of input files
 ## process the files
    /nbhome/fjz/sdDecPre/ecda.grain.JRA55.ps.jan.csh 2024
 ## check the output files,
    ls  /work/$user/jra55/202[34]??/PS.202[34]??.*.nc
 
 should have 1460 (365*4 ) files  for non-leap years and 1464 files for leap years.

## Process the  atmos files into 1-month files and save in /work/$user/jra55/yyyymm/.
Each of the atmos files contains 10-day data.  Run these following command to create monthly files,

    /nbhome/fjz/sdDecPre/ecda.grain.JRA55.1yr.csh

    /nbhome/fjz/sdDecPre/ecda.grain.JRA55.jan.csh
## check the output files,
    ls  /work/$user/jra55/202[34]??/{011_tmp,033_ugrd,034_vgrd,051_spfh}*202[34]??.*.nc

## combine the surface and atmospheric files
    foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)
        /nbhome/fjz/sdDecPre/ecda.combine.JRA55.all_vars.csh 2023 $mm
    end
## check the output files,
ls  /work/$user/jra55/2023/*

    /nbhome/fjz/sdDecPre/ecda.combine.JRA55.all_vars.csh 2024 01
## check the output files,
    ls  /work/$user/jra55/2024/*

##  regrid the combined files onto SPEAR_LO atmos grid
    /nbhome/fjz/sdDecPre/ecda.regrid.JRA55.csh 2023
    /nbhome/fjz/sdDecPre/ecda.regrid.JRA55.jan2024.csh
## check the output files,
    ls -l  /work/$user/jra55/{2023,2024} /*

## transfer to gaea
gcp the files in /work/$user/jra55/{2023,2024} to gaea, /gpfs/f5/gfdl_sd/world-shared/Xiaosong.Yang/archive/ada_data/JRA55/2023

The previous years data are located under
/lustre/f2/dev/gfdl/Xiaosong.Yang/archive/ada_data/JRA55/.
Now may be a good time to transfer all the files to the F5 system.
Extend ERSST monthly mean SST  to Jan 2024

## download monthly mean ERSST SST up to January 2024
Go to https://psl.noaa.gov/data/gridded/data.noaa.ersst.v5.html to download sst.mnmean.nc

## ersst file is on lat/lon grid,  run the script to regrid it unto SPEAR_LO ocean grid
    /nbhome/fjz/sdDecPre/data_sst.mnmean.v5.spear_lo.csh

## transfer to gaea
    gcp SPEAR_lo_tripolar.sst.nc gaea:/gpfs/f5/gfdl_sd/world-shared/Fanrong.Zeng/module_data/SPEAR/ersst.sst.mnmean.v5.nc

Extend reanalysis to dec. 2023

The 10-members are run in two 5-member ensembles, SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst and SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10.
The runs  have completed jan1958-dec2022, and need to extend to dec.2023.

## expt: SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst

take the jan.2023 initial conditions and transfer to gaea:

    gcp  /archive/fjz/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst/restart/20230101.tar gaea:/gpfs/f5/gfdl_sd/world-shared/Fanrong.Zeng/module_data/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_restart_20230101.tar

## re-generate runscript
Login to gaea5X
    module load fre/bronx-21
    frerun --platform=ncrc5.intel-classic --target=repro,openmp -x /autofs/ncrc-svm1_home2/Fanrong.Zeng/ecda_xml/spear_F/xml/SPEAR_experiments_Q50L33_c96_o1_HIST_jra55_B01_1958.C5.xml  SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst

## submit the runscript
    sbatch /gpfs/f5/gfdl_sd/scratch/Fanrong.Zeng/SPEAR_experiments_Q/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst/ncrc5.intel-classic-repro-openmp/scripts/run/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst

you may want to compare the runscript to the last year’s below and make sure the initial conditions and fyear variable  are the only real differences.  /lustre/f2/dev/gfdl/Fanrong.Zeng/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst/ncrc3.intel16-repro-openmp/scripts/run/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_yr2022
 
## setup and run members 06-10
Same as for the members 01-05 but setup the runscript based on  SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10
The initial conditions are transferred to gaea via this command
    gcp  /archive/fjz/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10/restart/20230101.tar gaea:/gpfs/f5/gfdl_sd/world-shared/Fanrong.Zeng/module_data/SPEAR/SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10_restart_20230101.tar
Run 2024 decadal predictions from the Jan. 2024 initial conditions

The 10-member prediction runs are conducted in two 5-member ensembles with the same experiment name i20240101 but under different directories.

## run prediction experiment: i20240101 for members 01-05

combine initial conditions for members 01-05.
    set expt = SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst
    set resfile = the-2024-restart file created in 4. # also available on archive, e.g. /archive/fjz/SPEAR/$expt/restart/????0101.tar
    set outfile = restart-file-2024 # e.g. /lustre/f2/dev/gfdl/Fanrong.Zeng/module_data/D_initCond/{$expt}_restart_20240101.tar
    cd /lustre/f2/scratch/gfdl/Fanrong.Zeng/tmpdir
    csh -f /lustre/f2/dev/gfdl/Fanrong.Zeng/module_data//combine.restart.5ees $resfile
    tar -cf $outfile *
    ls -l $outfile

## xml/runscript  for prediction:  i20240101 members 01-05
 start from  /ncrc/home2/Fanrong.Zeng/SPEAR_xml/xml/SPEAR_experiments_K_DecPred_icJRA_ERSST.bronx-18.xml
 add  <experiment name="i20240101" inherit="i20190101">
 set initCond to restart-file-2024 created above
generate runscript using frerun.

these are the commands used for 2023 predictions

    module load fre/bronx-19
    frerun  -x /ncrc/home2/Fanrong.Zeng/SPEAR_xml/xml/SPEAR_experiments_K_DecPred_icJRA_ERSST.bronx-18.xml --platform=ncrc4.intel16 --qos=urgent --target=repro,openmp i20230101
    sbatch the runscript

## run prediction experiment: i20240101 for members 06-10
Following the same steps as for members 01-05. Make sure to start from the 20240101 restart file from expt: SPEAR_Q50L33_c96_o1_Hist_AllForc_jra55_B01_1958_ersst_ens_06-10

