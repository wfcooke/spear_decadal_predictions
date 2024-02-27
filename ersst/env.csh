source /usr/local/Modules/default/init/csh
module load cdo
module load pyferret
module load fre-nctools
module load gcp
module load nco

set base_dir = /local2/home/ersst/
set raw_dir = ${base_dir}/raw
set archive_dir = /archive/$USER/ersst/
