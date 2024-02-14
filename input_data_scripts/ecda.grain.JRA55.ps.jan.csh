#  # grain surface pressure

#for 2024  jan

  set yyyy = 2024 # $1 
  set infiles = /nbhome/fjz/anl_surf.001_pres.reg_tl319.2024010100_2024013118.zeng726459.nc # $2
  ls $infiles
  ncrcat -O $infiles psfile.nc || exit -1
  ncrename -v PRES_GDS4_SFC,PS psfile.nc
    
#
  ncdump -h psfile.nc | grep "= UNLIMITED ; // (" | awk '{print $6}' | sed s/\(//
  # time steps in each month for non-leap years
  set leap = `echo $yyyy | awk '{print $1%4}'`
  if  ( $leap == 0 ) then
  set  lls = (124 )
  else
  set  lls = (124 )
  endif

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

@ mm = 1
#while ( $mm <= 12) 
  set mon = `echo $mm | awk '{printf "%-5.2d", $1}'`
  set outdir = /work/$user/jra55/$yyyy$mon
  if ( ! -e $outdir ) mkdir -p $outdir
  # rename
  foreach f (PS.$yyyy$mon.*.nc)
       ncrename -v initial_time0_hours,time -v g4_lat_1,lat -v g4_lon_2,lon -d initial_time0_hours,time -d g4_lat_1,lat -d g4_lon_2,lon $f
  end 
  cp PS.$yyyy$mon.*.nc $outdir/.
#  @ mm ++
#end

  ls -l /work/$user/jra55/$yyyy??/PS.$yyyy??.*.nc
  ls -l /work/$user/jra55/$yyyy??/PS.$yyyy??.*.nc | wc
  # should have 1460 (365*4 ) for non-leap years

