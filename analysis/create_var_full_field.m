%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_var_full_field(var, year, workdir, outdir)

run /home/Oar.Gfdl.Nmme/argo/share/matlab/startup

year_prev=year-1;

for en=101:105
    enmeb=num2str(en); 

    yr=num2str(year);
    file=['/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst/i' yr(1:4) '0101/pp_ens_' enmeb(2:3) '/atmos/ts/monthly/10yr/'];
    sfile1=[file 'atmos.' num2str(year) '01' '-' num2str(year+9) '12' '.' var '.nc'];
    
      f=netcdf(sfile1,'nowrite');
         tt(1:120,:,:)=squeeze(f{var}(:,:,:));
         lat=f{'lat'}(:);
         lon=f{'lon'}(:);
      close(f)  

   if strcmp(var, 'precip') == 1
        var_ens1_5(en-100,year-year_prev,:,:,:)=tt.*3600.*24;
   else
        var_ens1_5(en-100,year-year_prev,:,:,:)=tt;
   end
   clear tt

end
clear lead sfile2 en 
clear f sfile1 file tt enmeb

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for en=101:105
    enmeb=num2str(en); 

    yr=num2str(year);
    file=['/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst_ens_06-10/i' yr(1:4) '0101/pp_ens_' enmeb(2:3) '/atmos/ts/monthly/10yr/'];
    sfile1=[file 'atmos.' num2str(year) '01' '-' num2str(year+9) '12' '.' var '.nc'];
    
      f=netcdf(sfile1,'nowrite');
         tt(1:120,:,:)=squeeze(f{var}(:,:,:));
         lat=f{'lat'}(:);
         lon=f{'lon'}(:);
      close(f)  
 
   if strcmp(var, 'precip') == 1
        var_ens6_10(en-100,year-year_prev,:,:,:)=tt.*3600.*24;
   else
        var_ens6_10(en-100,year-year_prev,:,:,:)=tt;
   end
   clear tt

end
clear lead sfile2 en 
clear f sfile1 file tt enmeb

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var_fcst(1:5,:,:,:,:)=var_ens1_5;
clear var_ens1_5
var_fcst(6:10,:,:,:,:)=var_ens6_10;
clear var_ens6_10
clear ans

save([workdir var '_fcst.mat'], 'var_fcst')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ensemble=1:1:10

n=1;
for yr=year:year+9
    year_str=int2str(yr);
    for mon=101:112
        real_mon=num2str(mon);
        time(n)=datenum([real_mon(2:3) '/01/' year_str])-datenum('01/01/1960');
        n=n+1;
    end
end
clear n yr mon real_mon

n=1;
initialization_year(n)=datenum(['01/01/' num2str(year)])-datenum('01/01/1960');
n=n+1;

clear n yr mon real_mon

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%output variables
if strcmp(var, 't_ref') == 1 
    var_name='tas';
    long_name = 'air temperature at 2m';
    unit = 'K';
elseif strcmp(var, 't_surf') == 1
    var_name='ts';
    long_name = 'Surface temperature';
    unit = 'K';
elseif strcmp(var, 'slp') == 1
    var_name='psl';
    long_name = 'air_pressure_at_sea_level';
    unit = 'hPa';
elseif strcmp(var, 'precip') == 1
    var_name='pr';
    long_name='precipitation_flux';
    unit='mm/day';
end


fout=[outdir var_name '_Amon_GFDL-SPEAR_LO_Initialization_yr' num2str(year) '_10yr_prediction_r' num2str(ensemble) 'i1p1f1.nc'];

sst_for=var_fcst(ensemble,year-year_prev:year-year_prev,:,:,:);
initialization_year=initialization_year;
time=time;
ens=ensemble;
lat=lat;
lon=lon;

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

% And now we write it:
ncvar(var_name,'float',{'ENS','initializationyear','time','latitude','longitude'},nc); % we need to define axis of the field
ncatt('long_name','char',long_name,nc{var_name}); % Give it the long_name
ncatt('units','char',unit,nc{var_name}); % The unit
ncatt('FillValue_','float',-9999.99,nc{var_name}); % Missing var fill value
sst_for(isnan(sst_for)) = -9999.99;
nc{var_name}(:,:,:,:,:) = sst_for;

close(nc);

end

