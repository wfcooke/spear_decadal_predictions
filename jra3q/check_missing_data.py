import xarray as xr
import argparse


parser=argparse.ArgumentParser()
parser.add_argument('--infile')
args=parser.parse_args()

in_file=args.infile

ds=xr.open_dataset(in_file)

var_list=['PS', 'T', 'U', 'V', 'Q']

for var in var_list:
    num_miss=ds[var].isnull().sum().values
    if num_miss>0:
        print('Missing values for var {} in {}'.format(var, in_file))
