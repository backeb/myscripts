function [vtcty,dvdx,dudy,lon1,lat1]=calc_vort(uin,vin,lonin,latin)
% function [vtcty,dvdx,dudy,lon1,lat1]=calc_vort(uin,vin,lonin,latin)
% 
% calculate vorticity from the velocity field
% 
% where 
% uin		input U-velocity
% vin		input V-velocity
% lonin 	lon input vector
% latin 	lat input vector
%
% example	load velocity field, e.g. from HYCOM. 
% 		if 3 dimensional matrix, e.g. 520x430x47.
%		will assume dimensions 1 and 2 are lon and lat vectors.

%% create distance matrix between successive lon lat points
disp([' ']);
disp(['getting distance between lon lat points (in m) to be used in vorticity calculation']);
for j=1:1:size(lonin,2)-1
	for i=1:1:size(latin,1)-1
		ydist(i,j)=m_lldist([lonin(1,j) lonin(1,j)],[latin(i,1) latin(i+1,1)])*1000;
    	xdist(i,j)=m_lldist([lonin(1,j) lonin(1,j+1)],[latin(i,1) latin(i,1)])*1000;
	end
end


% Calculate the vorticity
disp(['calculating vorticity...']);
for ii=1:1:size(uin,3)

 dvdx1=diff(vin(:,:,ii),1,2);
 dudy1=diff(uin(:,:,ii),1,1);

 dvdx=dvdx1(1:size(dudy1,1),1:size(dvdx1,2))./xdist;
 dudy=dudy1(1:size(dudy1,1),1:size(dvdx1,2))./ydist;

 vtcty(:,:,ii)=dvdx-dudy;

end

lon1=lonin(1:size(lonin,1)-1,1:size(lonin,2)-1);
lat1=latin(1:size(latin,1)-1,1:size(latin,2)-1);

disp([' ']);
disp(['done. new variables created']);
disp([' ']);

%tmp=find(isnan(vort)==0);
%mini=min(min(vort(tmp)));
%maxi=max(max(vort(tmp)));
%mn=mean(vort(tmp));
%stdev=std(vort(tmp));
%%vort(tmp)=NaN;
%V=[ mn-3*stdev   mn-stdev*2:(4*stdev/20):mn+stdev*2  mn+3*stdev ];
%%V=[ mini+stdev :0.05:maxi-stdev ];
%vort=max(min(min(V)),vort);
%vort=min(max(max(V)),vort);
