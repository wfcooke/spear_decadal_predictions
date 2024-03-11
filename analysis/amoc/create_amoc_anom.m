%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_amoc_anom(year, workdir, outdir)

run /home/Oar.Gfdl.Nmme/argo/share/matlab/startup

load /archive/cem/spear_decadal_climo_1991_2020/amoc_clim_1991_2020.mat

load ([workdir 'anmoc_fcst.mat'], 'anmoc_fcst');

amoc_prediction_10yr=squeeze(anmoc_fcst(:,1,:,:,:))-new_amoc_clim;
clear ans anmoc_fcst

n=1;
for yr=year:year+9
    for mon=101:112
        real_mon=num2str(mon);
        time(n)=datenum([real_mon(2:3) '/01/' int2str(yr)])-datenum('01/01/1960');
        n=n+1;
    end
end
clear n yr

fout=[outdir 'msftmyz_Omon_GFDL-SPEAR_LO_s' num2str(year) 'Jan1st_10ensembles_gn_climatology-1991-2020.nc'];
var_name='msftmyz';
sst_for=amoc_prediction_10yr/1e+6;
clear amoc_prediction_10yr
time=time;
ens=1:1:10;
depth=depth;
lat=lat;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nc = netcdf(fout,'clobber');
close(nc)
nc = netcdf(fout,'write');
% Define dimensions:
ncdim('time',length(time),nc);
ncdim('ENS',length(ens),nc);
ncdim('depth',length(depth),nc);
ncdim('latitude',length(lat),nc);

% Define axis:
ncvar('time','float',{'time'},nc);
ncatt('units','char','days since 1960-01-01 00:00:00',nc{'time'});
ncatt('long_name','char','Center time of the day',nc{'time'})
ncatt('axis','char','T',nc{'time'});
ncatt('calendar','char','gregorian',nc{'time'});
nc{'time'}(:) = time(:)'

%%%ens
ncvar('ENS','float',{'ENS'},nc);
ncatt('units','char','member',nc{'ENS'});
ncatt('axis','char','e',nc{'ENS'});
ncatt('long_name','char','ensemble',nc{'ENS'})
nc{'ENS'}(:) = ens;

%%%depth
ncvar('depth','float',{'depth'},nc);
ncatt('units','char','meter',nc{'depth'});
ncatt('axis','char','Z',nc{'depth'});
ncatt('long_name','char','ocean depth',nc{'depth'})
nc{'depth'}(:) = depth;

%%%lat
ncvar('latitude','float',{'latitude'},nc);
ncatt('units','char','degrees_north',nc{'latitude'});
ncatt('axis','char','Y',nc{'latitude'});
ncatt('long_name','char','latitude',nc{'latitude'})
nc{'latitude'}(:) = lat;

% The variable we want to record is in the Matlab field C but we have to give it a name and defime metadatas for the cdf file:
varname = var_name;
long_name = 'Atlantic_meridional_overturning_circulation_anomaly';
unit = 'Sv'; % for example of course

% And now we write it:
ncvar(varname,'float',{'ENS','time','depth','latitude'},nc); % we need to define axis of the field
ncatt('long_name','char',long_name,nc{varname}); % Give it the long_name
ncatt('units','char',unit,nc{varname}); % The unit
ncatt('FillValue_','float',-9999.99,nc{varname}); % Missing var fill value
sst_for(isnan(sst_for)) = -9999.99;
nc{varname}(:,:,:,:) = sst_for;

close(nc);

nc_dump ( fout )

