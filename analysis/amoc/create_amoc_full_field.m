% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_amoc_full_field(year, workdir, outdir)

run /home/Oar.Gfdl.Nmme/argo/share/matlab/startup

year_prev=year-1;

for en=101:105
    enmeb=num2str(en);

    yr=num2str(year);
    file=['/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst/i' yr(1:4) '0101/pp_ens_' enmeb(2:3) '/ocean_z/ts/monthly/10yr/'];
    sfile1=[file 'ocean_z.' num2str(year) '01' '-' num2str(year+9) '12' '.vh.nc']
    
      f=netcdf(sfile1,'nowrite');
         vv(1:120,:,:,:)=squeeze(f{'vh'}(:,:,97:254,200:321));
         lat=f{'yq'}(97:254);
         lon=f{'xh'}(200:321);
         depth=f{'z_l'}(:);
      close(f)  
      vv(abs(vv)>1e+19)=NaN;
      load /archive/cem/spear_decadal_climo_1991_2020/amoc/new_mask.mat
      vv=vv.*new_mask;
      clear new_mask
      
      v_x=squeeze(nansum(vv,4));
      clear vv

      for z=1:length(depth)
       sf(:,z,:)=-nansum(v_x(:,z:end,:),2);
      end
      clear v_x z
      
   
      anmoc_fcst_ens1_5(en-100,year-year_prev,:,:,:)=sf;
      clear sf

end
clear lead sfile2 en 
clear yr f sfile1 file tt enmeb

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for en=101:105
    enmeb=num2str(en); 

    yr=num2str(year);
    file=['/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst_ens_06-10/i' yr(1:4) '0101/pp_ens_' enmeb(2:3) '/ocean_z/ts/monthly/10yr/'];
    sfile1=[file 'ocean_z.' num2str(year) '01' '-' num2str(year+9) '12' '.vh.nc'];
    
      f=netcdf(sfile1,'nowrite');
         vv(1:120,:,:,:)=squeeze(f{'vh'}(:,:,97:254,200:321));
         lat=f{'yq'}(97:254);
         lon=f{'xh'}(200:321);
         depth=f{'z_l'}(:);
      close(f)  
      vv(abs(vv)>1e+19)=NaN;
      load /archive/cem/spear_decadal_climo_1991_2020/amoc/new_mask.mat
      vv=vv.*new_mask;
      clear new_mask
      
      v_x=squeeze(nansum(vv,4));
      clear vv

      for z=1:length(depth)
       sf(:,z,:)=-nansum(v_x(:,z:end,:),2);
      end
      clear v_x z
      
   
      anmoc_fcst_ens6_10(en-100,year-year_prev,:,:,:)=sf;
      clear sf

end
clear lead sfile2 en 
clear yr f sfile1 file tt enmeb

anmoc_fcst(1:5,:,:,:,:)=anmoc_fcst_ens1_5;
clear anmoc_fcst_ens1_5

anmoc_fcst(6:10,:,:,:,:)=anmoc_fcst_ens6_10;
clear anmoc_fcst_ens6_10

save([workdir 'anmoc_fcst.mat'], 'anmoc_fcst')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

anmoc_fcst(abs(anmoc_fcst)>1e+19)=NaN;

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
initialization_year(n)=datenum(['01/01/' int2str(year)])-datenum('01/01/1960');
n=n+1;

clear n yr mon real_mon

fout=[outdir 'msftmyz_Omon_GFDL-SPEAR_LO_Initialization_yr' num2str(year) '_10yr_prediction_r1-10i1p1f1.nc'];
var_name='msftmyz';
sst_for=anmoc_fcst(:,year-year_prev:year-year_prev,:,:,:)/1e+6;

initialization_year=initialization_year;
time=time;
ens=1:10;
depth=depth;
lat=lat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nc = netcdf(fout,'clobber');
close(nc)
nc = netcdf(fout,'write');

% Define dimensions:
ncdim('ENS',length(ens),nc);
ncdim('initializationyear',length(initialization_year),nc);
ncdim('time',length(time),nc);
ncdim('depth',length(depth),nc);
ncdim('latitude',length(lat),nc);


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
long_name = 'Atlantic_meridional_overturning_circulation';
unit = 'Sv'; % for example of course

% And now we write it:

ncvar(varname,'float',{'ENS','initializationyear','time','depth','latitude'},nc); % we need to define axis of the field
ncatt('long_name','char',long_name,nc{varname}); % Give it the long_name
ncatt('units','char',unit,nc{varname}); % The unit
ncatt('FillValue_','float',-9999.99,nc{varname}); % Missing var fill value
sst_for(isnan(sst_for)) = -9999.99;
nc{varname}(:,:,:,:,:) = sst_for;


close(nc);


end
