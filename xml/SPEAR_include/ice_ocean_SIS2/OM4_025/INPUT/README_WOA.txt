Recreate WOA05_pottemp_salt.nc from WOA05_depth.nc, WOA05_ptemp.nc, WOA05_salt.nc


cp WOA05_depth.nc  WOA05_pottemp_salt.nc
ncks -A WOA05_ptemp.nc WOA05_pottemp_salt.nc
ncks -A WOA05_salt.nc  WOA05_pottemp_salt.nc
