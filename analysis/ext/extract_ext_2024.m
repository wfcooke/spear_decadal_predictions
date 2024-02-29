%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all

startyr=2024;
endyr=2024;

for en=101:105
    enmeb=num2str(en); 

 for year=startyr:endyr
    yr=num2str(year);
    file=['/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst/i' yr(1:4) '0101/pp_ens_' enmeb(2:3) '/ice/ts/monthly/10yr/'];
    sfile1=[file 'ice.' num2str(year) '01' '-' num2str(year+9) '12' '.EXT.nc'];
    
      f=netcdf(sfile1,'nowrite');
         tt(1:120,:,:)=squeeze(f{'EXT'}(:,:,:));
         lat=f{'yt'}(:);
         lon=f{'xt'}(:);
      close(f)  
   
      ext_2024_ens1_5(en-100,year-2023,:,:,:)=tt;
      clear tt

end

end
clear lead endyr startyr sfile2 en 
clear yr f sfile1 file year tt enmeb

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startyr=2024;
endyr=2024;

for en=101:105
    enmeb=num2str(en); 

 for year=startyr:endyr
    yr=num2str(year);
    file=['/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst_ens_06-10/i' yr(1:4) '0101/pp_ens_' enmeb(2:3) '/ice/ts/monthly/10yr/'];
    sfile1=[file 'ice.' num2str(year) '01' '-' num2str(year+9) '12' '.EXT.nc'];
    
      f=netcdf(sfile1,'nowrite');
         tt(1:120,:,:)=squeeze(f{'EXT'}(:,:,:));
         lat=f{'yT'}(:);
         lon=f{'xT'}(:);
      close(f)  
   
      ext_2024_ens6_10(en-100,year-2023,:,:,:)=tt;
      clear tt

end

end
clear lead endyr startyr sfile2 en 
clear yr f sfile1 file year tt enmeb

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ext_2024(1:5,:,:,:,:)=ext_2024_ens1_5;
clear ext_2024_ens1_5

ext_2024(6:10,:,:,:,:)=ext_2024_ens6_10;
clear ext_2024_ens6_10



save ext_2024.mat -v7.3 









