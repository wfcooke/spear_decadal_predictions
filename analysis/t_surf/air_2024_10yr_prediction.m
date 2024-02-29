%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
% 
% load /arche/l2z/decadal_prediction/initialized_in_2021/t_surf/airt_1961_2019.mat 
% load /arche/l2z/decadal_prediction/initialized_in_2021/t_surf/airt_2020_2021.mat 
% airt_1961_2019(:,60:61,:,:,:)=airt_2020_2021;
% clear airt_2020_2021
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1991-2020 lead time climatology
% 
% for lead=1:10
%    airt_clim(:,lead,:,:,:)=nanmean(airt_1961_2019(:,31-lead+1:60-lead+1,1+(lead-1)*12:12+(lead-1)*12,:,:),2);
% end
% clear lead airt_1961_2019
% 
% for lead=1:10
%     new_airt_clim(:,1+(lead-1)*12:12+(lead-1)*12,:,:)=squeeze(airt_clim(:,lead,:,:,:));
% end
% clear lead airt_clim

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load /archive/l2z/decadal_prediction/initialized_in_2023/t_surf/airt_clim_1991_2020.mat

load airt_2024.mat
airt_2024prediction_10yr=squeeze(airt_2024(:,1,:,:,:))-new_airt_clim;
clear ans airt_2024


% save airt_clim_1991_2020.mat new_airt_clim lat lon

save airt_2024prediction_10yr.mat airt_2024prediction_10yr lat lon


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
aa=squeeze(mean(airt_2024prediction_10yr,1));
contourf(lon,lat,squeeze(mean(aa(1:12,:,:),1)),30)

caxis([-1.5 1.5])
colorbar
















