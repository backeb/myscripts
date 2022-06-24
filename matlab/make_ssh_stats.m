clear all
close all

cnt=1;

ncload('AGUrestart1999_335_00_ssh.nc','depths')

for yy=1998:2007

   yy
   
   flist=dir(['AGUrestart',num2str(yy),'*ssh.nc']);

   for ii=1:1:length(flist)
      ncload(flist(ii).name,'ssh');
      ssh(find(depths==0))=NaN;
      tmp(:,:,ii)=ssh';
      clear ssh
   end

   meanssh(:,:,cnt)=nanmean(tmp,3);
   sigmassh(:,:,cnt)=nanstd(tmp,0,3);

   clear tmp

   cnt=cnt+1;

end

clear depths ans cnt flist ii yy

ncload('AGUrestart1999_335_00_ssh.nc','lon','lat')

lon=lon';
lat=lat';

save mean_sigma_ssh.mat
