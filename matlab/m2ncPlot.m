clear all
close all

ModExp=pwd;
ModExp=[ModExp(33:40),ModExp(42:45),ModExp(47:50)]


disp('loading tmp1.nc')
nc=netcdf('tmp1.nc');

lon=nc{'longitude'}(:)';
lat=nc{'latitude'}(:)';

depth=nc{'depth'}(:)'; depth(find(depth==nc{'depth'}.FillValue_))=NaN;


ssh=nc{'ssh00'}(:); ssh(find(ssh==nc{'ssh00'}.FillValue_(:)))=NaN; ssh=permute(ssh,[3 2 1]);
sst=nc{'temp01'}(:); sst(find(sst==nc{'temp01'}.FillValue_(:)))=NaN; sst=permute(sst,[3 2 1]);
kinetic=nc{'kinetic01'}(:); kinetic(find(kinetic==nc{'kinetic01'}.FillValue_(:)))=NaN; kinetic=permute(kinetic,[3 2 1]);
u=nc{'UROT_tot01'}(:); u(find(u==nc{'UROT_tot01'}.FillValue_(:)))=NaN; u=permute(u,[3 2 1]);
v=nc{'VROT_tot01'}(:); v(find(v==nc{'VROT_tot01'}.FillValue_(:)))=NaN; v=permute(v,[3 2 1]);

weeks=size(ssh,3);

disp('calc means')
ssh=nanmean(ssh,3);
sst=nanmean(sst,3);
kinetic=nanmean(kinetic,3);
u=nanmean(u,3);
v=nanmean(v,3);
uv=sqrt(u.^2+v.^2);

disp('plot data')

%m_proj('mercator','lon',[-2 70],'lat',[-52 -3])
m_proj('mercator','lon',[10 50],'lat',[-45 -10])

% ssh
figure
colormap(jet(20));
m_pcolor(lon,lat,ssh);shading flat;caxis([min(min(ssh)) max(max(ssh))]);
colorbar
hold on
m_contour(lon,lat,depth,[200 500 1000 2000 4000],'k','linew',1.5);
hold off
grid on
m_grid
m_coast('patch',[.5 .5 .5])
title([ModExp, ': Mean SSH (in m, avg. of ',num2str(weeks),' weeks)']);
print('-dpng','-r200',[ModExp,'_mean_ssh.png'])

% sst
figure
colormap(jet(20));
m_pcolor(lon,lat,sst);shading flat;caxis([min(min(sst)) max(max(sst))]);
colorbar
hold on
m_contour(lon,lat,depth,[200 500 1000 2000 4000],'k','linew',1.5);
hold off
grid on
m_grid
m_coast('patch',[.5 .5 .5])
title([ModExp,': Mean SST (in {\circ}C, avg. of ',num2str(weeks),' weeks)']);
print('-dpng','-r200',[ModExp,'_mean_sst.png'])

% kinetic
figure
colormap(jet(20));
m_pcolor(lon,lat,kinetic);shading flat;caxis([0 1.5]);
colorbar
hold on
m_contour(lon,lat,depth,[200 500 1000 2000 4000],'k','linew',1.5);
hold off
grid on
m_grid
m_coast('patch',[.5 .5 .5])
title([ModExp,': Mean kinetic (in m^2.s^-^2, avg. of ',num2str(weeks),' weeks)']);
print('-dpng','-r200',[ModExp,'_mean_kinetic.png'])

% uv
figure
colormap(jet(20));
m_pcolor(lon,lat,uv);shading flat;caxis([min(min(uv)) max(max(uv))]);
colorbar
hold on
m_contour(lon,lat,depth,[200 500 1000 2000 4000],'k','linew',1.5);
hold off
grid on
m_grid
m_coast('patch',[.5 .5 .5])
title([ModExp,': Mean vel. mag. (in m.s^-^1, avg. of ',num2str(weeks),' weeks)']);
print('-dpng','-r200',[ModExp,'_mean_vel.png'])

!mv *.png ~/Figs/.
