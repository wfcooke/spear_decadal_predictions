%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all

% load /arche/l2z/decadal_prediction/initialized_in_2021/amoc/anmoc_1961_2020.mat 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1991-2020 lead time climatology
% 
% for lead=1:10
%    amoc_clim(:,lead,:,:,:)=nanmean(anmoc_1961_2020(:,31-lead+1:60-lead+1,1+(lead-1)*12:12+(lead-1)*12,:,:),2);
% end
% clear lead anmoc_1961_2020
% 
% for lead=1:10
%     new_amoc_clim(:,1+(lead-1)*12:12+(lead-1)*12,:,:)=squeeze(amoc_clim(:,lead,:,:,:));
% end
% clear lead amoc_clim

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load /archive/l2z/decadal_prediction/initialized_in_2023/amoc/amoc_clim_1991_2020.mat

load anmoc_2024.mat

amoc_2024prediction_10yr=squeeze(anmoc_2024(:,1,:,:,:))-new_amoc_clim;
clear ans anmoc_2024


%save amoc_clim_1991_2020.mat new_amoc_clim lat depth

save amoc_2024prediction_10yr.mat amoc_2024prediction_10yr lat depth


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
aa=squeeze(mean(amoc_2024prediction_10yr,1));
contourf(lat,-flipud(depth),flipud(squeeze(mean(aa(1:60,:,:),1)))/1e+6,30)

caxis([-5 5])
colorbar















