function [mag,alpha]=uv2magdir(uin,vin);
% function [mag,alpha]=uv2magdir(uin,vin);
%
% convert u and v components to magnitude and direction
%

% calculate magnitude
mag=sqrt(uin.^2+vin.^2);

% degrees from north (0-360)
for ii=1:1:size(uin,1)
	for jj=1:1:size(uin,2)
		if isnan(uin(ii,jj))==1 | isnan(vin(ii,jj))==1
			alpha(ii,jj)=NaN;
		elseif uin(ii,jj)==0 & vin(ii,jj)>0
			alpha(ii,jj)=0;
		elseif uin(ii,jj)>0 & vin(ii,jj)==0
			alpha(ii,jj)=90;
		elseif uin(ii,jj)==0 & vin(ii,jj)<0
			alpha(ii,jj)=180;
		elseif uin(ii,jj)<0 & vin(ii,jj)==0
			alpha(ii,jj)=270;
		elseif uin(ii,jj)>0 & vin(ii,jj)>0
			beta=90-abs(atand(vin(ii,jj)./uin(ii,jj)));
			alpha(ii,jj)=beta;
		elseif uin(ii,jj)>0 & vin(ii,jj)<0
			beta=90-abs(atand(vin(ii,jj)./uin(ii,jj)));
			alpha(ii,jj)=180-beta;
		elseif uin(ii,jj)<0 & vin(ii,jj)<0
			beta=90-abs(atand(vin(ii,jj)./uin(ii,jj)));
			alpha(ii,jj)=180+beta;
		elseif uin(ii,jj)<0 & vin(ii,jj)>0
			beta=90-abs(atand(vin(ii,jj)./uin(ii,jj)));
			alpha(ii,jj)=360-beta;
		end
	end
end
clear beta
