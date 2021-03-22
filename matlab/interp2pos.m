
nc=netcdf('dataset-duacs-dt-ref-global-merged-msla-h_1350389958661.nc');

time=nc{'time'}(:)./24+datenum(1950,1,1);
lat=nc{'NbLatitudes'}(:);
lon=nc{'NbLongitudes'}(:);
sla=permute(nc{'Grid_0001'}(:),[3 2 1]);
fill=nc{'Grid_0001'}.FillValue_(:);
sla(find(sla==fill))=NaN;

clear fill nc

for ii=1:1:length(time)

	dbn(ii,1)=interp2(lon,lat,sla(:,:,ii),31.03,-31.52,'nearest');
	lmu(ii,1)=interp2(lon,lat,sla(:,:,ii),40.54,-2.16,'nearest');
	mbs(ii,1)=interp2(lon,lat,sla(:,:,ii),39.39,-4.04,'nearest');
	zzb(ii,1)=interp2(lon,lat,sla(:,:,ii),39.11,-6.09,'nearest');
	plr(ii,1)=interp2(lon,lat,sla(:,:,ii),55.32,-4.40,'nearest');
	ptl(ii,1)=interp2(lon,lat,sla(:,:,ii),59.30,-20.09,'nearest');

end

time=str2num(datestr(time,'yyyymmdd'));

dlmwrite('durban.txt',dbn,'precision','%.10f');
dlmwrite('lamu.txt',lmu,'precision','%.10f');
dlmwrite('mombasa.txt',mbs,'precision','%.10f');
dlmwrite('zanzibar.txt',zzb,'precision','%.10f');
dlmwrite('ptlarue.txt',plr,'precision','%.10f');
dlmwrite('portlouise.txt',ptl,'precision','%.10f');
dlmwrite('time.txt',time,'precision','%.0f');



