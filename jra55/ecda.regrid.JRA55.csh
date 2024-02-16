#!/bin/csh -f

mkdir /work/$user/jra55/old
#set yyyy = 2018                  # running on an011 1/29/2020
#set yyyy = 2019                  # running on an011 4/28/2020
#set yyyy = 2020                  # running on an011 1/22/2021
# set yyyy =  2022                  # running on an011 2/06/2022, an008 12/7/2022
set yyyy = $1 # 2023                  #  an202 2/5/2023

  cd /work/$user/jra55
  # mv $yyyy/* files to old/$yyyy/.
  mkdir old/$yyyy
  mv $yyyy/* old/$yyyy/.
  # specifie outdir 
  set outdir = /work/$user/jra55/$yyyy
  # specifie indir 
  set indir = /work/$user/jra55/old/$yyyy
  mkdir -p $outdir
  cd $outdir || exit -1
  foreach infile ($indir/$yyyy*.nc)
   if ( ! -e $infile:t ) then
    ls -l $infile
    ferret -script "/home/$user/sdDecPred/Regrid_SPEAR_lo.atmos.jnl" "$infile"
    mv new.nc $infile:t || exit -1
   endif
  end

ls -l $outdir/$yyyy*.nc

# final checking the file size
    echo $yyyy
    ls -lh /work/$user/jra55/old/$yyyy/*.nc | grep "190M" # the original files
    ls -lh /work/$user/jra55/$yyyy/*.nc | grep "96M"  # outfiles created
