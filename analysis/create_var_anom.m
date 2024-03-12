%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_var_anom(var, year, workdir, outdir)

run /home/Oar.Gfdl.Nmme/argo/share/matlab/startup

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(var,'t_ref') == 1
    clim_var_name='new_reft_clim';
    var1='reft';
    var_name='tas';
    long_name = 'air_temperature_anomaly_at_2m';
    unit = 'K';
elseif strcmp(var, 't_surf') == 1
    clim_var_name='new_airt_clim';
    var1='airt';
    var_name='ts';
    long_name = 'Surface temperature anomaly';
    unit = 'K';
elseif strcmp(var, 'slp') == 1
    clim_var_name='new_slp_clim';
    var1='slp';
    var_name='psl';
    long_name = 'air_pressure_anomaly_at_sea_level';
    unit = 'hPa';
elseif strcmp(var, 'precip') == 1
    clim_var_name='new_precip_clim';
    var1='precip';
    var_name='pr';
    long_name='precipitation_flux_anomaly';
    unit='mm/day';
end 


clim_file=load(['/archive/cem/spear_decadal_climo_1991_2020/' var1 '_clim_1991_2020.mat']);
clim_var=clim_file.(clim_var_name);

load([workdir var '_fcst.mat'], 'var_fcst');
var_prediction_10yr=squeeze(var_fcst(:,1,:,:,:))-clim_var;
clear ans reft_fcst

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ensemble=1:10

n=1;
for yr=year:year+9
    for mon=101:112
        real_mon=num2str(mon);
        time(n)=datenum([real_mon(2:3) '/01/' int2str(yr)])-datenum('01/01/1960');
        n=n+1;
    end
end
clear n yr

fout=[outdir var_name '_Amon_GFDL-SPEAR_LO_s' num2str(year) 'Jan1st_' 'r' num2str(ensemble) 'i1p1f1' '_gn_climatology-1991-2020.nc'];

sst_for=var_prediction_10yr(ensemble,:,:,:);
time=time;
ens=ensemble;
lat=clim_file.('lat');
lon=clim_file.('lon');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nc = netcdf(fout,'clobber');
close(nc)
nc = netcdf(fout,'write');
% Define dimensions:
ncdim('time',length(time),nc);
ncdim('ENS',length(ens),nc);
ncdim('latitude',length(lat),nc);
ncdim('longitude',length(lon),nc);


% Define axis:
ncvar('time','float',{'time'},nc);
ncatt('units','char','days since 1960-01-01 00:00:00',nc{'time'});
ncatt('long_name','char','Center time of the day',nc{'time'})
ncatt('axis','char','T',nc{'time'});
ncatt('calendar','char','gregorian',nc{'time'});
%nc{'TIME'}(:) = time(:)'-datenum(1860,1,1,0,0,0)+datenum(1800,1,1,0,0,0);
nc{'time'}(:) = time(:)'

%%%ens
ncvar('ENS','float',{'ENS'},nc);
ncatt('units','char','member',nc{'ENS'});
ncatt('axis','char','e',nc{'ENS'});
ncatt('long_name','char','ensemble',nc{'ENS'})
nc{'ENS'}(:) = ens;

%%%lat
ncvar('latitude','float',{'latitude'},nc);
ncatt('units','char','degrees_north',nc{'latitude'});
ncatt('axis','char','Y',nc{'latitude'});
ncatt('long_name','char','latitude',nc{'latitude'})
nc{'latitude'}(:) = lat;
%%%lon
ncvar('longitude','float',{'longitude'},nc);
ncatt('units','char','degrees_east',nc{'longitude'});
ncatt('long_name','char','longitude',nc{'longitude'})
ncatt('axis','char','X',nc{'longitude'});
nc{'longitude'}(:) = lon;

% And now we write it:
ncvar(var_name,'float',{'ENS','time','latitude','longitude'},nc); % we need to define axis of the field
ncatt('long_name','char',long_name,nc{var_name}); % Give it the long_name
ncatt('units','char',unit,nc{var_name}); % The unit
ncatt('FillValue_','float',-9999.99,nc{var_name}); % Missing var fill value
sst_for(isnan(sst_for)) = -9999.99;
nc{var_name}(:,:,:,:) = sst_for;

close(nc);


nc_dump ( fout )


end
