%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_ext_full_field(year, work_dir, outdir)

run /home/Oar.Gfdl.Nmme/argo/share/matlab/startup

year_prev=year-1;

for en=101:105
    enmeb=num2str(en); 

    yr=num2str(year);
    file=['/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst/i' yr(1:4) '0101/pp_ens_' enmeb(2:3) '/ice/ts/monthly/10yr/'];
    sfile1=[file 'ice.' num2str(year) '01' '-' num2str(year+9) '12' '.EXT.nc'];
    
      f=netcdf(sfile1,'nowrite');
         tt(1:120,:,:)=squeeze(f{'EXT'}(:,:,:));
         lat=f{'yt'}(:);
         lon=f{'xt'}(:);
      close(f)  
   
      ext_ens1_5(en-100,year-2023,:,:,:)=tt;
      clear tt


end
clear lead sfile2 en 
clear yr f sfile1 file tt enmeb

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for en=101:105
    enmeb=num2str(en); 

    yr=num2str(year);
    file=['/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst_ens_06-10/i' yr(1:4) '0101/pp_ens_' enmeb(2:3) '/ice/ts/monthly/10yr/'];
    sfile1=[file 'ice.' num2str(year) '01' '-' num2str(year+9) '12' '.EXT.nc'];
    
      f=netcdf(sfile1,'nowrite');
         tt(1:120,:,:)=squeeze(f{'EXT'}(:,:,:));
         lat=f{'yT'}(:);
         lon=f{'xT'}(:);
      close(f)  
   
      ext_ens6_10(en-100,year-2023,:,:,:)=tt;
      clear tt


end
clear lead sfile2 en 
clear yr f sfile1 file tt enmeb

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ext_fcst(1:5,:,:,:,:)=ext_ens1_5;
clear ext_ens1_5

ext_fcst(6:10,:,:,:,:)=ext_ens6_10;
clear ext_ens6_10

save([work_dir 'ext_fcst.mat'], 'ext_fcst')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ext_fcst(abs(ext_fcst)>1000000)=NaN;

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

clear n yr mon real_mon

fout=[outdir 'siconc_Imon_GFDL-SPEAR_LO_Initialization_yr' num2str(year) '_10yr_prediction_r' num2str(ensemble) 'i1p1f1.nc'];
var_name='siconc';
sst_for=ext_fcst(ensemble,year-year_prev:year-year_prev,:,:,:);
% clear ext_1961_2020
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

% The variable we want to record is in the Matlab field C but we have to give it a name and defime metadatas for the cdf file:
varname = var_name;
long_name = 'sea ice area fraction';
unit = '1';

% And now we write it:
ncvar(varname,'float',{'ENS','initializationyear','time','latitude','longitude'},nc); % we need to define axis of the field
ncatt('long_name','char',long_name,nc{varname}); % Give it the long_name
ncatt('units','char',unit,nc{varname}); % The unit
ncatt('FillValue_','float',-9999.99,nc{varname}); % Missing var fill value
sst_for(isnan(sst_for)) = -9999.99;
nc{varname}(:,:,:,:,:) = sst_for;

close(nc);

end

