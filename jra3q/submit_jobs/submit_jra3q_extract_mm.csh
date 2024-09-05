#!/bin/sh 
  
#SBATCH -J regrid_jra3q
#SBATCH -t 2-12:00:00 
#SBATCH -o /home/cem/git/spear_decadal_predictions/jra3q/log/%x.o%j

/home/Colleen.McHugh/git/spear_decadal_predictions/jra3q/ecda.grain.JRA3Q_month.csh 2002 08 spfh 
