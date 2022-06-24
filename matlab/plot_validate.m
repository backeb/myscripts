% fig=plot_validate(fprefix,ftype)

clear all
close all


fprefix='AGUAVE'
ftype='nc'

flist=dir([fprefix,'*.',ftype])

display('load all data')
for ii=1:1:length(flist)

   nc=netcdf(flist(ii).name);
   %ncdump(nc)


   % load all data into single matrices
   tmp=permute(nc{'saln'}(:),[4 3 2 1]);
   tmp(tmp==nc{'saln'}.FillValue_(:))=NaN;
   saln(:,:,ii)=tmp; clear tmp
   tmp=permute(nc{'temp'}(:),[4 3 2 1]);
   tmp(tmp==nc{'temp'}.FillValue_(:))=NaN;
   temp(:,:,ii)=tmp; clear tmp
   tmp=permute(nc{'ssh'}(:),[4 3 2 1]);
   tmp(tmp==nc{'ssh'}.FillValue_(:))=NaN;
   ssh(:,:,ii)=tmp; clear tmp
   tmp=permute(nc{'utot'}(:),[4 3 2 1]);
   tmp(tmp==nc{'utot'}.FillValue_(:))=NaN;
   utot(:,:,ii)=tmp; clear tmp
   tmp=permute(nc{'vtot'}(:),[4 3 2 1]);
   tmp(tmp==nc{'vtot'}.FillValue_(:))=NaN;
   vtot(:,:,ii)=tmp; clear tmp
   close(nc); clear nc

end
clear flist fprefix ftype ii

display('calculating avg saln, ssh, temp, utot, vtot')
   avg.saln=nanmean(saln,3);
   avg.ssh=nanmean(ssh,3);
   avg.temp=nanmean(temp,3);
   avg.utot=nanmean(utot,3);
   avg.vtot=nanmean(vtot,3);

display('calculating eke')
   [tmp,tmp,avg.eke]=calc_kinetic(utot,vtot);
   clear tmp

[lon,lat,depths]=loadgrid();

whos
avg

save validate.mat

m_proj('mercator','lon',[min(lon(:)) max(lon(:))],'lat',[min(lat(:)) max(lat(:))])

   m_pcolor(lon,lat,avg.ssh);
   shading flat;
   colormap(jet(25))
   caxis([-1 1.5])
   m_grid
   h=colorbar('horiz');
      set(h,'Position',[0.1544 0.8833 0.4098 0.0173])
      set(h,'XAxisLocation','bottom')
      set(h,'XTick',[-1 -0.5 0 0.5 1 1.5])
   title('Mean SSH [m]')
   print('-dpng','-r200','mean_ssh.png')
      
   m_pcolor(lon,lat,avg.temp);
   shading flat;
   colormap(jet(32))
   caxis([-2 30])
   m_grid
   h=colorbar('horiz');
      set(h,'Position',[0.1544 0.8833 0.4098 0.0173])
      set(h,'XAxisLocation','bottom')
   title('Mean SST [deg C]')
   print('-dpng','-r200','mean_sst.png')

   m_pcolor(lon,lat,avg.saln);
   shading flat;
   colormap(jet(20))
   caxis([34 36])
   m_grid
   h=colorbar('horiz');
      set(h,'Position',[0.1544 0.8833 0.4098 0.0173])
      set(h,'XAxisLocation','bottom')
   title('Mean SSS [psu]')
   print('-dpng','-r200','mean_sss.png')

   avg.uvtot=sqrt(avg.utot.^2+avg.vtot.^2);
   m_pcolor(lon,lat,avg.uvtot);
   shading flat;
   colormap(jet(12))
   caxis([0 1.2])
   i=[1:6:520];
   j=[1:6:430];
   tmpuv=avg.uvtot(i,j);
   tmplon=lon(i,j); tmplon=tmplon(isfinite(tmplon) & tmpuv>0.2);
   tmplat=lat(i,j); tmplat=tmplat(isfinite(tmplat) & tmpuv>0.2);
   tmpu=avg.utot(i,j); tmpu=tmpu(isfinite(tmpu) & tmpuv>0.2);
   tmpv=avg.vtot(i,j); tmpv=tmpv(isfinite(tmpv) & tmpuv>0.2);
   hold on
      m_quiver(tmplon,tmplat,tmpu,tmpv,1,'Color',[.9 .9 .9])
   hold off
   m_grid
   h=colorbar('horiz');
      set(h,'Position',[0.1544 0.8833 0.4098 0.0173])
      set(h,'XAxisLocation','bottom')
      set(h,'XTick',[0:0.2:1.2])
   title('Mean SFC VEL [m/s]')
   print('-dpng','-r200','mean_sfcvel.png')

   m_pcolor(lon,lat,avg.eke);
   shading flat;
   colormap(jet(25))
   caxis([0 0.5])
   m_grid
   h=colorbar('horiz');
      set(h,'Position',[0.1544 0.8833 0.4098 0.0173])
      set(h,'XAxisLocation','bottom')
   title('Mean EKE [m^2/s^2]')
   print('-dpng','-r200','mean_eke.png')

