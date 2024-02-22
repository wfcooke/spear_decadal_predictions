#!/bin/csh

#get directory of this script
set rootdir = `dirname $0`
set script_dir = `cd $rootdir && pwd`

set yyyy = 2023

foreach mm (`seq -w 01 12`)
    ${script_dir}/ecda.combine.JRA55.all_vars.csh $yyyy $mm
end
