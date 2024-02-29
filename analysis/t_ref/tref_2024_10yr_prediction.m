%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all

% load /arche/l2z/decadal_prediction/initialized_in_2021/t_ref/reft_1961_2019.mat 
% load /arche/l2z/decadal_prediction/initialized_in_2021/t_ref/reft_2020_2021.mat
% 
% reft_1961_2019(:,60:61,:,:,:)=reft_2020_2021;
% clear reft_2020_2021
% 
% %%%%%%%%%%1991-2020 lead time climatology
% 
% for lead=1:10
% 
%    reft_clim(:,lead,:,:,:)=nanmean(reft_1961_2019(:,31-lead+1:60-lead+1,1+(lead-1)*12:12+(lead-1)*12,:,:),2);
% 
% end
% clear lead reft_1961_2019
% 
% for lead=1:10
%     new_reft_clim(:,1+(lead-1)*12:12+(lead-1)*12,:,:)=squeeze(reft_clim(:,lead,:,:,:));
% end
% clear lead reft_clim

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load /archive/l2z/decadal_prediction/initialized_in_2023/t_ref/reft_clim_1991_2020.mat

load reft_2024.mat
reft_2024prediction_10yr=squeeze(reft_2024(:,1,:,:,:))-new_reft_clim;
clear ans reft_2024


save reft_2024prediction_10yr.mat reft_2024prediction_10yr lat lon






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
aa=squeeze(mean(reft_2024prediction_10yr,1));
contourf(lon,lat,squeeze(mean(aa(1:12,:,:),1)),30)

caxis([-1.5 1.5])
colorbar































