% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

startyr=2024;
endyr=2024;

for en=101:105
    enmeb=num2str(en); 

 for year=startyr:endyr
    yr=num2str(year);
    file=['/archive/cem/SPEAR_lo/fcst_hist/D_jra_ersst/i' yr(1:4) '0101/pp_ens_' enmeb(2:3) '/ocean_z/ts/monthly/10yr/'];
    sfile1=[file 'ocean_z.' num2str(year) '01' '-' num2str(year+9) '12' '.vh.nc'];
    
      f=netcdf(sfile1,'nowrite');
         vv(1:120,:,:,:)=squeeze(f{'vh'}(:,:,97:254,200:321));
         lat=f{'yq'}(97:254);
         lon=f{'xh'}(200:321);
         depth=f{'z_l'}(:);
      close(f)  
      vv(abs(vv)>1e+19)=NaN;
      load /archive/l2z/decadal_prediction/initialized_in_2021/amoc/new_mask.mat
      vv=vv.*new_mask;
      clear new_mask
      
      v_x=squeeze(nansum(vv,4));
      clear vv

      for z=1:length(depth)
       sf(:,z,:)=-nansum(v_x(:,z:end,:),2);
      end
      clear v_x z
      
   
      anmoc_2024_ens1_5(en-100,year-2023,:,:,:)=sf;
      clear sf

end

end
clear lead endyr startyr sfile2 en 
clear yr f sfile1 file year tt enmeb



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

startyr=2024;
endyr=2024;

for en=101:105
    enmeb=num2str(en); 

 for year=startyr:endyr
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
      load /archive/l2z/decadal_prediction/initialized_in_2021/amoc/new_mask.mat
      vv=vv.*new_mask;
      clear new_mask
      
      v_x=squeeze(nansum(vv,4));
      clear vv

      for z=1:length(depth)
       sf(:,z,:)=-nansum(v_x(:,z:end,:),2);
      end
      clear v_x z
      
   
      anmoc_2024_ens6_10(en-100,year-2023,:,:,:)=sf;
      clear sf

end

end
clear lead endyr startyr sfile2 en 
clear yr f sfile1 file year tt enmeb



anmoc_2024(1:5,:,:,:,:)=anmoc_2024_ens1_5;
clear anmoc_2024_ens1_5

anmoc_2024(6:10,:,:,:,:)=anmoc_2024_ens6_10;
clear anmoc_2024_ens6_10

save anmoc_2024.mat 

















