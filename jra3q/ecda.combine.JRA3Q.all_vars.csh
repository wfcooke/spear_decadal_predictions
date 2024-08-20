#!/bin/csh -f

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

source ${script_dir}/env.csh

#these files are used to convert the JRA vertical levels to GFDL vertical levels

### put ak, bk, surface geopotential, and all invars into the final outfile
set yyyy = $1
set outdir =  ${base_dir}/$yyyy
if ( ! -e $outdir) mkdir $outdir
cd $outdir || exit -1

set mm = $2 # 01 02 03 04 05 06 07 08 09 10 11 12  # run one month 
set NN = `ls ${base_dir}/$yyyy$mm/tmp-hyb-an-gauss.*.nc | wc | awk '{print $1}'`
echo $NN 
#if ("$NN" != 120  && "$NN" != 124 && "$NN" != 112 ) then
if ("$NN" < 112 ) then
   ls -l ${base_dir}/$yyyy$mm/tmp-hyb-an-gauss.*.nc
   echo "found $NN, which is less than 112, exit -1" 
   exit -1
endif

ls $yyyy$mm*Z_jra3q.nc |wc | grep $NN
if ($status == 0 ) then
   echo "outfiles exist , exit 0"
   exit 0
endif
  
@ ll = 0
set count = 1
while ($ll < $NN)
  echo $count
  set dd = `echo $count | awk '{printf "%-5.2d", $1}'`
  echo $yyyy $mm $dd
  @ ll = $ll + 1 ;  set ss = 00
  echo $ll $ss
if ( ! -e $yyyy$mm$dd{_}$ss{Z_jra3q.nc} ) then
  ls ${base_dir}/$yyyy$mm/{tmp-hyb-an-gauss,ugrd-hyb-an-gauss,vgrd-hyb-an-gauss,spfh-hyb-an-gauss}.$yyyy$mm.$ll.nc | wc
  ncap2 -O -v -s 'T=temp.reverse($lev)' ${base_dir}/$yyyy$mm/tmp-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc  || exit -1
  ncap2 -A -v -s 'U=uwnd.reverse($lev)' ${base_dir}/$yyyy$mm/ugrd-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'V=vwnd.reverse($lev)' ${base_dir}/$yyyy$mm/vgrd-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'Q=spfh.reverse($lev)' ${base_dir}/$yyyy$mm/spfh-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncks -A -v PS ${base_dir}/$yyyy$mm/PS.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncks -A -C -v PHIS ${script_dir}/data/gpfile_jra3q.nc foo.nc || exit -1
  ncks -A -v HYAI,HYBI ${script_dir}/data/akbk_jra3q.nc foo.nc || exit -1
  mv foo.nc $yyyy$mm$dd{_}$ss{Z_jra3q.nc}
endif 
  @ ll = $ll + 1 ;  set ss = 06
  echo $ll $ss
if ( ! -e $yyyy$mm$dd{_}$ss{Z_jra3q.nc} ) then
  ls ${base_dir}/$yyyy$mm/{tmp-hyb-an-gauss,ugrd-hyb-an-gauss,vgrd-hyb-an-gauss,spfh-hyb-an-gauss}.$yyyy$mm.$ll.nc | wc
  ncap2 -O -v -s 'T=temp.reverse($lev)' ${base_dir}/$yyyy$mm/tmp-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'U=uwnd.reverse($lev)' ${base_dir}/$yyyy$mm/ugrd-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'V=vwnd.reverse($lev)' ${base_dir}/$yyyy$mm/vgrd-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'Q=spfh.reverse($lev)' ${base_dir}/$yyyy$mm/spfh-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncks -A -v PS ${base_dir}/$yyyy$mm/PS.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncks -A -C -v PHIS ${script_dir}/data/gpfile_jra3q.nc foo.nc || exit -1
  ncks -A -v HYAI,HYBI ${script_dir}/data/akbk_jra3q.nc foo.nc || exit -1
  mv foo.nc $yyyy$mm$dd{_}$ss{Z_jra3q.nc}
endif  
  @ ll = $ll + 1 ;  set ss = 12
  echo $ll $ss
if ( ! -e $yyyy$mm$dd{_}$ss{Z_jra3q.nc} ) then
  ls ${base_dir}/$yyyy$mm/{tmp-hyb-an-gauss,ugrd-hyb-an-gauss,vgrd-hyb-an-gauss,spfh-hyb-an-gauss}.$yyyy$mm.$ll.nc | wc
  ncap2 -O -v -s 'T=temp.reverse($lev)' ${base_dir}/$yyyy$mm/tmp-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'U=uwnd.reverse($lev)' ${base_dir}/$yyyy$mm/ugrd-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'V=vwnd.reverse($lev)' ${base_dir}/$yyyy$mm/vgrd-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'Q=spfh.reverse($lev)' ${base_dir}/$yyyy$mm/spfh-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncks -A -v PS ${base_dir}/$yyyy$mm/PS.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncks -A -C -v PHIS ${script_dir}/data/gpfile_jra3q.nc foo.nc || exit -1
  ncks -A -v HYAI,HYBI ${script_dir}/data/akbk_jra3q.nc foo.nc || exit -1
  mv foo.nc $yyyy$mm$dd{_}$ss{Z_jra3q.nc}
endif  
  @ ll = $ll + 1 ;  set ss = 18
  echo $ll $ss
if ( ! -e $yyyy$mm$dd{_}$ss{Z_jra3q.nc} ) then
  ls ${base_dir}/$yyyy$mm/{tmp-hyb-an-gauss,ugrd-hyb-an-gauss,vgrd-hyb-an-gauss,spfh-hyb-an-gauss}.$yyyy$mm.$ll.nc | wc
  ncap2 -O -v -s 'T=temp.reverse($lev)' ${base_dir}/$yyyy$mm/tmp-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'U=uwnd.reverse($lev)' ${base_dir}/$yyyy$mm/ugrd-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'V=vwnd.reverse($lev)' ${base_dir}/$yyyy$mm/vgrd-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncap2 -A -v -s 'Q=spfh.reverse($lev)' ${base_dir}/$yyyy$mm/spfh-hyb-an-gauss.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncks -A -v PS ${base_dir}/$yyyy$mm/PS.$yyyy$mm.$ll.nc foo.nc || exit -1
  ncks -A -C -v PHIS ${script_dir}/data/gpfile_jra3q.nc foo.nc || exit -1
  ncks -A -v HYAI,HYBI ${script_dir}/data/akbk_jra3q.nc foo.nc || exit -1
  mv foo.nc $yyyy$mm$dd{_}$ss{Z_jra3q.nc}
endif  
  @ count ++
end   # while ($count <= $NN)
rm -f foo.nc

