%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all

% load /arche/l2z/decadal_prediction/initialized_in_2021/ext/ext_1961_2019.mat 
% ext_1961_2019(abs(ext_1961_2019)>1e+12)=NaN;
% load /arche/l2z/decadal_prediction/initialized_in_2021/ext/ext_2020_2021.mat 
% ext_2020_2021(abs(ext_2020_2021)>1e+12)=NaN;
% ext_1961_2019(:,60:61,:,:,:)=ext_2020_2021;
% clear ext_2020_2021
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1991-2020 lead time climatology
% 
% for lead=1:10
%    ext_clim(:,lead,:,:,:)=nanmean(ext_1961_2019(:,31-lead+1:60-lead+1,1+(lead-1)*12:12+(lead-1)*12,:,:),2);
% end
% clear lead ext_1961_2019
% 
% for lead=1:10
%     new_ext_clim(:,1+(lead-1)*12:12+(lead-1)*12,:,:)=squeeze(ext_clim(:,lead,:,:,:));
% end
% clear lead ext_clim

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load /archive/l2z/decadal_prediction/initialized_in_2023/ext/ext_clim_1991_2020.mat

load ext_2024.mat

ext_2024prediction_10yr=squeeze(ext_2024(:,1,:,:,:))-new_ext_clim;
clear ans ext_2024


%save ext_clim_1991_2020.mat new_ext_clim lat lon

save ext_2024prediction_10yr.mat ext_2024prediction_10yr lat lon






