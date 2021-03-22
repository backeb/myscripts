function [kurt]=calc_kurtosis(sshin,tin);
% function [kurt]=calc_kurtosis(sshin,tin);
%  
% calculate kurtosis from sea surface height
% standard error only valid in regions with little or no inter annual variability
% 
% routine assumes that data dimensions are layed out as:
% lon x lat x time (time in datenum format)
%
% reference: Gille and Sura (2008). A Global View of Non-Gaussian Sea Surface Height Variability.
%
% input variables:
% sshin = input ssh
% tin = time input variable used in error calculation - in matlab datenum format
%
% output variables:
% kurt = kurtosis for domain
% err = standard error

disp('calculating kurtosis')

for ii=1:1:size(sshin,1)
  for jj=1:1:size(sshin,2)
    kurt(ii,jj)=kurtosis(sshin(ii,jj,:));
  end
end
clear ii jj
