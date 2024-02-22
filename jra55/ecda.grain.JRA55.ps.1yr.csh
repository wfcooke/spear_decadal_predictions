#!/bin/csh -f

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

#remove work_dir and recreate it
if ( -e ${work_dir} ) then
    rm -rf ${work_dir}
endif

mkdir ${work_dir}

cd ${work_dir}

# grain surface pressure, 1-yr file, into 12  monthly files

#for 2023  12 files
  set yyyy = 2023 # $1 # 2023
  set infile = ${infilesDir}/anl_surf.001_pres.reg_tl319.2023010100_2023013118-319.2023120100_2023123118.zeng723562.nc.tar # $2
  
  tar -xf $infile
  ncrcat -O anl_surf.001_pres.reg_tl319.$yyyy*.nc  psfile.nc || exit -1
  ncrename -v PRES_GDS4_SFC,PS psfile.nc
    
#
  ncdump -h psfile.nc | grep "= UNLIMITED ; // (" | awk '{print $6}' | sed s/\(//
  # time steps in each month for non-leap years
  set leap = `echo $yyyy | awk '{print $1%4}'`
  if  ( $leap == 0 ) then
  set  lls = (124 116 124 120 124 120 124 124 120 124 120 124)
  else
  set  lls = (124 112 124 120 124 120 124 124 120 124 120 124)
  endif
  echo $lls
#
  @ mm = 0
  @ l1 = 0
  @ l2 = 0
  foreach ll ( $lls)
    @ l1 = $l2 + 1
    @ l2 = $l1 + $ll
    @ l2 --
    @ mm ++ 
    echo $mm $l1 $l2
    @ n1 = 1
    @ n2 = $n1 + $ll
    set mon = `echo $mm | awk '{printf "%-5.2d", $1}'`
    @ tll = $l1
    @ ttt = 1
    while ($tll <= $l2)
      echo ncks -F -O -d initial_time0_hours,$tll psfile.nc PS.$yyyy$mon.$ttt.nc
      ncks -F -O -d initial_time0_hours,$tll psfile.nc PS.$yyyy$mon.$ttt.nc
      @ tll ++ 
      @ ttt ++ 
    end
  end
#
@ mm = 1
while ( $mm <= 12) 
  set mon = `echo $mm | awk '{printf "%-5.2d", $1}'`
  set outdir = ${base_dir}/$yyyy$mon
  if ( ! -e $outdir ) mkdir -p $outdir
  # rename
  foreach f (PS.$yyyy$mon.*.nc)
       ncrename -v initial_time0_hours,time -v g4_lat_1,lat -v g4_lon_2,lon -d initial_time0_hours,time -d g4_lat_1,lat -d g4_lon_2,lon $f
  end 
  cp PS.$yyyy$mon.*.nc $outdir/.
  @ mm ++
end

ls -l ${base_dir}/$yyyy??/PS.$yyyy??.*.nc
ls -l ${base_dir}/$yyyy??/PS.$yyyy??.*.nc | wc
# should have 1460 (365*4 ) for non-leap years

