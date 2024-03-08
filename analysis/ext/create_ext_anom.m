%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_ext_anom(year, workdir, outdir)

run /home/Oar.Gfdl.Nmme/argo/share/matlab/startup

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load /archive/cem/spear_decadal_climo_1991_2020/ext_clim_1991_2020.mat

load([workdir 'ext_fcst.mat'])

ext_prediction_10yr=squeeze(ext_fcst(:,1,:,:,:))-new_ext_clim;
clear ans ext_fcst


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

fout=[outdir 'siconc_Imon_GFDL-SPEAR_LO_s' num2str(year) 'Jan1st_r' num2str(ensemble) 'i1p1f1' '_gn_climatology-1991-2020.nc'];

var_name='siconc';
sst_for=ext_prediction_10yr(ensemble,:,:,:);
time=time;
ens=ensemble;
lat=lat;
lon=lon;

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

% The variable we want to record is in the Matlab field C but we have to give it a name and defime metadatas for the cdf file:
varname = var_name;
long_name = 'sea ice area fraction anomaly';
unit = '1'; % for example of course

% And now we write it:
ncvar(varname,'float',{'ENS','time','latitude','longitude'},nc); % we need to define axis of the field
ncatt('long_name','char',long_name,nc{varname}); % Give it the long_name
ncatt('units','char',unit,nc{varname}); % The unit
ncatt('FillValue_','float',-9999.99,nc{varname}); % Missing var fill value
sst_for(isnan(sst_for)) = -9999.99;
nc{varname}(:,:,:,:) = sst_for;

close(nc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

