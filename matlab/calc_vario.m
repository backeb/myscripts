function [gamma,avg_gamma,lag,scale,dist]=calc_vario(z,zdim,lonin,latin)
% function [gamma,avg_gamma,lag,scale,dist]=calc_vario(z,zdim,lonin,latin)
%
% calculates variagram from input data
%
% input variables
% z 	 	variable for which to calcute variogram
% zdim		dimensions of z
%		1 = 1d, e.g. section data
%		2 = 2d, e.g. gridded data
% lonin		lon vector / matrix used for scale calculation
% latin		lat vector / matrix used for scale calculation
%
% output variables
% gamma	 	variogram
% avg_gamma	avg variogram calculated from mean over time
% lag		lag scaled according to horizontal resolution section / grid data
% scale		scaling factor for lag, calculated from distance between lon's and lat's
% dist		lag distance vector
% 
% example plot of time avg variogram
% plot(dist,avg_gamma);
% xlabel('lag (distance between points)');
% ylabel('semivariance (units^2)');
%
% to fit theoretical variogram use fitvario.m

if zdim==1

  % set lag max
  lagmax=.5*size(z,1);

  % calc vario for each time step
  for jj=1:1:size(z,2)

    for ii=1:1:lagmax

     % dissimilarity
     delta=.5*nanmean((diff(z(1:ii:size(z,1),jj),1)).^2); 
 
     % variogram
     gamma(ii,jj)=delta;
     lag(ii)=ii;

    end

  end

  % calculate scaling factor for lag from lon, lat
  scale=nanmean(m_lldist(lonin,latin));
  
  % distance vector
  dist=lag*scale;

  % time avg variogram
  avg_gamma=nanmean(gamma,2); 
  %std_gamma=nanstd(gamma); % std of semivariograms

elseif zdim==2
  
  % set lag max
  if size(z,1)>=size(z,2)
    lagmax=.5*size(z,1);
  else
    lagmax=.5*size(z,2);
  end

  for jj=1:1:size(z,3)

    for ii=1:1:lagmax

     % variogram in y-axis
     delta1=.5*squeeze(nanmean(nanmean((diff(z(1:ii:size(z,1),:,jj),1,1)).^2)));
     % variogram in x=axis
     delta2=.5*squeeze(nanmean(nanmean((diff(z(:,1:ii:size(z,2),jj),1,2)).^2)));

     % average x and y axis variagrams = total variogram
     gamma(ii,jj)=(delta1+delta2)/2;
     lag(ii)=ii;

    end

  end

  % calculate scaling factor for lag from lon, lat
  scale=nanmean(m_lldist(lonin(:,1),latin(:,1)));
   
  % distance vector 
  dist=lag*scale;

  % time avg variogram
  avg_gamma=nanmean(gamma,2);
  %std_gamma=nanstd(gamma); % std of semivariograms

else

  disp('error dimensions (zdim) of input variable not specified')

end


