%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all

% load /arche/l2z/decadal_prediction/initialized_in_2021/slp/slp_1961_2019.mat 
% load /arche/l2z/decadal_prediction/initialized_in_2021/slp/slp_2020_2021.mat
% slp_1961_2019(:,60:61,:,:,:)=slp_2020_2021;
% clear slp_2020_2021
% %%%%%%%%%%1991-2020 lead time climatology
% 
% for lead=1:10
% 
%    slp_clim(:,lead,:,:,:)=nanmean(slp_1961_2019(:,31-lead+1:60-lead+1,1+(lead-1)*12:12+(lead-1)*12,:,:),2);
% 
% end
% clear lead slp_1961_2019
% 
% for lead=1:10
%     new_slp_clim(:,1+(lead-1)*12:12+(lead-1)*12,:,:)=squeeze(slp_clim(:,lead,:,:,:));
% end
% clear lead slp_clim

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load /archive/l2z/decadal_prediction/initialized_in_2023/slp/slp_clim_1991_2020.mat

load slp_2024.mat
slp_2024prediction_10yr=squeeze(slp_2024(:,1,:,:,:))-new_slp_clim;
clear ans slp_2024


save slp_2024prediction_10yr.mat slp_2024prediction_10yr lat lon














