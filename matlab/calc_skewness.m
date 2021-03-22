function [skew,err]=calc_skewness(sshin,tin,calc_err);
% function [skew,err]=calc_skewness(sshin,tin,calc_err);
%  
% calculate skewness and standard error from sea surface height
% standard error only valid in regions with little or no inter annual variability
% 
% routine assumes that data dimensions are layed out as:
% lon x lat x time (time in datenum format)
%
% for a complete description of the method and the standard error calculation see
% Thompson and Demirov (2006). Skewness of sea level variability of the world's oceans.
% JGR, 111, doi:10.1029/2004JC002839
% 
% input variables:
% sshin		input ssh
% tin		time input variable used in error calculation - in matlab datenum format
% calc_err	string ['y']es or ['n']o
%
% output variables:
% skew = skewness for domain
% err = standard error, if calc_err specified 'y'

disp('calculating skewness')

for ii=1:1:size(sshin,1)
  for jj=1:1:size(sshin,2)
    skew(ii,jj)=skewness(sshin(ii,jj,:));
  end
end
clear ii jj

if calc_err=='y'

  disp('calculating standard error')

  % calc annual skewness
  cnt=1;
  for yy=str2num(datestr(min(tin),10)):1:str2num(datestr(max(tin),10))
    for ii=1:1:size(sshin,1)
      for jj=1:1:size(sshin,2)
        skewtmp(ii,jj,cnt)=skewness(sshin(ii,jj,find(tin<datenum(yy,12,31))));
      end
    end
    cnt=cnt+1;
  end
  clear yy cnt ii jj
  
  % calc std (s) of annual skewness and standard error
  s=std(skewtmp,0,3);
  err=s./sqrt(size(skewtmp,3));
  
end
