%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all

% load /arche/l2z/decadal_prediction/initialized_in_2021/precip/precip_1961_2019.mat 
% load /arche/l2z/decadal_prediction/initialized_in_2021/precip/precip_2020_2021.mat
% precip_1961_2019(:,60:61,:,:,:)=precip_2020_2021;
% clear precip_2020_2021
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1991-2020 lead time climatology
% 
% for lead=1:10
%    precip_clim(:,lead,:,:,:)=nanmean(precip_1961_2019(:,31-lead+1:60-lead+1,1+(lead-1)*12:12+(lead-1)*12,:,:),2);
% end
% clear lead precip_1961_2019
% 
% for lead=1:10
%     new_precip_clim(:,1+(lead-1)*12:12+(lead-1)*12,:,:)=squeeze(precip_clim(:,lead,:,:,:));
% end
% clear lead precip_clim

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load /archive/l2z/decadal_prediction/initialized_in_2023/precip/precip_clim_1991_2020.mat

load precip_2024.mat
precip_2024prediction_10yr=squeeze(precip_2024(:,1,:,:,:))-new_precip_clim;
clear ans precip_2024


%save precip_clim_1991_2020.mat new_precip_clim lat lon

save precip_2024prediction_10yr.mat precip_2024prediction_10yr lat lon




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
aa=squeeze(mean(precip_2024prediction_10yr,1));
contourf(lon,lat,squeeze(mean(aa(1:12,:,:),1)),30)

caxis([-0.7 0.7])
colorbar
















