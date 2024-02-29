%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all

load precip_2024.mat


for newnum=2024:1:2024

       for ensemble=1:1:10 
           
n=1;
for yr=newnum:newnum+9
    year=int2str(yr);
    for mon=101:112
        real_mon=num2str(mon);
        time(n)=datenum([real_mon(2:3) '/01/' year])-datenum('01/01/1960');
        n=n+1;
    end
end
clear n yr mon real_mon


n=1;
for yr=newnum:newnum
    initialization_year(n)=datenum(['01/01/' int2str(yr)])-datenum('01/01/1960');
    n=n+1;
end
clear n yr mon real_mon


fout=['pr_Amon_GFDL-SPEAR_LO_Initialization_yr' num2str(newnum) '_10yr_prediction_r' num2str(ensemble) 'i1p1f1.nc'];

var_name='pr';
sst_for=precip_2024(ensemble,newnum-2023:newnum-2023,:,:,:);
initialization_year=initialization_year;
time=time;
ens=ensemble;
lat=lat;
lon=lon;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nc = netcdf(fout,'clobber');
close(nc)
nc = netcdf(fout,'write');
% Define dimensions:

ncdim('ENS',length(ens),nc);
ncdim('initializationyear',length(initialization_year),nc);
ncdim('time',length(time),nc);
ncdim('latitude',length(lat),nc);
ncdim('longitude',length(lon),nc);

%%%ens
ncvar('ENS','float',{'ENS'},nc);
ncatt('units','char','member',nc{'ENS'});
ncatt('axis','char','e',nc{'ENS'});
ncatt('long_name','char','ensemble',nc{'ENS'})
nc{'ENS'}(:) = ens;

% Define axis:
ncvar('initializationyear','float',{'initializationyear'},nc);
ncatt('units','char','days since 1960-01-01 00:00:00',nc{'initializationyear'});
ncatt('long_name','char','Initialization year',nc{'initializationyear'})
ncatt('axis','char','I',nc{'initializationyear'});
ncatt('calendar','char','gregorian',nc{'initializationyear'});
nc{'initializationyear'}(:) = initialization_year(:)'

% Define axis:
ncvar('time','float',{'time'},nc);
ncatt('units','char','days since 1960-01-01 00:00:00',nc{'time'});
ncatt('long_name','char','10 years prediction',nc{'time'})
ncatt('axis','char','T',nc{'time'});
ncatt('calendar','char','gregorian',nc{'time'});
nc{'time'}(:) = time(:)'

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
long_name = 'precipitation_flux';
unit = 'mm/day'; % for example of course

% And now we write it:
ncvar(varname,'float',{'ENS','initializationyear','time','latitude','longitude'},nc); % we need to define axis of the field
ncatt('long_name','char',long_name,nc{varname}); % Give it the long_name
ncatt('units','char',unit,nc{varname}); % The unit
ncatt('FillValue_','float',-9999.99,nc{varname}); % Missing var fill value
sst_for(isnan(sst_for)) = -9999.99;
nc{varname}(:,:,:,:,:) = sst_for;

close(nc);


nc_dump ( fout )

       end

end


