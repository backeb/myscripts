
close all
clear all

data='/media/jenny/Minotaur/ERA5/CLIM_ERA5_M1.nc';



FillValue=-32767;

%% load the required variables

u10=ncread(data,'u10'); %% NOTE in matlab: LON x LAT
v10=ncread(data,'v10'); %                   LON x LAT         
lon=ncread(data,'longitude');
lat=ncread(data,'latitude');

sst=ncread(data,'sst'); %% this is what we use as the mask

mask=sst;
mask(mask==FillValue)=nan;
mask(isfinite(mask))=1;

u10=u10.*mask; 
v10=v10.*mask;
%% create 2D lat and lon array

lon2D=repmat(lon,[1 size(lat)]);
lat2D=repmat(lat,[1 size(lon)])';



%% Calcul1. convert wind speed (in m/s) to wind stress (in N/m-2)
%   use tau_x=C_d*rho_a*u^2
%       tau_y=C_d*rho_a*v^2 
       
%      C_d = dimensionless drag coefficient. (it varies according to wind speed, surface roughness. We will use       a value of 0.0015.
%      rho_a = air density, which we will take as 1.2 kg/m3ate wind stress from wind speed.  

rho_a=1.2;

Cd=0.0015;

tau_x=Cd*rho_a*(u10.*u10);
tau_y=Cd*rho_a*(v10.*v10);

%% To calculate windstress curl (dTy/dx)-(dTx/dy)
% we first compute dx and dy 

[M1,N1]=size(lat2D);

dx=zeros(M1-1,N1-1);
dy=zeros(M1-1,N1-1);

for k0=1:N1-1 
    LT=lat(k0);
    for k1=1:M1-1
        LN1=lon(k1);
        LN2=lon(k1+1);
        dx(k1,k0)=spheric_dist(LT,LT,LN1,LN2);
    end
end

for k0=1:M1-1 
    LN=lon(k0);
    for k1=1:N1-1
        LT1=lat(k1);
        LT2=lat(k1+1);
        dy(k0,k1)=spheric_dist(LT1,LT2,LN,LN);
    end
end
% calculate dTy shear in E-W direction and dTx shear in N-S direction

dTy=tau_y(2:end,:)-tau_y(1:end-1,:); %% NB to differentiate along the correct dimension!
dTx=tau_x(:,2:end)-tau_x(:,1:end-1); %% NB to differentiate along the correct dimension!

%% calculate the windstress (taking care to correct the size of the dTy and dTx (to match dx and dy respectively)

wsc=(((dTy(:,2:end)+dTy(:,1:end-1))/2)./dx)-(((dTx(2:end,:)+dTx(1:end-1,:))/2)./dy);

%% calculate f (based on the lat2D)

%%% define g:
g=9.8;
%%% calculate f (f = 2 * omega * sin (latitude) ) Remember! latitude should
%%% omega = angular velocity of earth in rad/s: 
omega=(2*pi)/86400;
%%% be converted to radians
f=2*omega*sin(lat2D*pi/180);

%% calculate the Ekman pumping velocities: wsc/(rho0*f) = We
rho0=1027;
new_f=(f(2:end,2:end)+f(1:end-1,1:end-1))/2;
We=wsc./(rho0*new_f);

%% plot Wind stress Curl
% NOTE: need to check the size of the lat2D and lon2D coordinaes

lon2D_new=(lon2D(2:end,2:end)+lon2D(1:end-1,1:end-1))/2;
lat2D_new=(lat2D(2:end,2:end)+lat2D(1:end-1,1:end-1))/2;

Xf=12;
Yf=9;

cmin=-0.000001;
cmax=0.000001;
cint=0.000001

cmap='jet';

figure;pcolor(lon2D_new,lat2D_new,wsc);shading interp
caxis([cmin cmax]);
hold on;
contour(lon2D_new,lat2D_new,wsc,[cmin:cint:cmax],'k');
colorbar;
colormap(cmap);
hold on;

title(['Wind stress curl [N/m] - January']);
hold on;



%% Extract coordinate of interest
LT=-34.15;
LN= 18;

LT_index=find((abs(lat-LT))==min(abs(lat-LT)));
LN_index=find((abs(lon-LN))==min(abs(lon-LN)));

We_coast=We(LN_index,LT_index);



