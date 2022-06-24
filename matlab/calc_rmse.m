clear all
close all

% make sure in right directory
if strcmp('/work/users/bjornb/RESULTS/mfiles',pwd)==0

   return
   disp('not in the right directory: check that you are in /work/users/bjornb/RESULTS/mfiles/')
   
else

   % load mean ssh
   idm=520;
   jdm=430;
   fid=fopen('~/REANALYSIS/FILES/meanssh.uf','r','ieee-be');
   xstat=fseek(fid,4,'bof'); % Skip fortran 4-byte header
   mssh=fread(fid,[idm jdm],'double');
   clear fid xstat idm jdm
   mssh(find(mssh==mssh(1,1)))=NaN;

   cnt=0;
   
   for julday=21143:7:21150

      disp(['calculating rmse for files in ','../',num2str(julday),'/'])

      % observations
      nc=netcdf(['../',num2str(julday),'/ANALYSIS/observations-TSLA.nc']);
      obs=nc{'d'}(:);
      age=nc{'age'}(:);
      %inov=nc{'innovation'}(:);
      ipiv=nc{'ipiv'}(:);
      jpiv=nc{'jpiv'}(:);
      clear nc

      % analysis - restart file for day of assimilation
      flist=dir(['../',num2str(julday),'/FORECAST/AGUDAILY*.a']);
      for ii=1:1:length(flist)
         [ssh,lon,lat,depths]=loaddaily(['../',num2str(julday),'/FORECAST/',flist(ii).name(1:end-2)],'ssh',0);
         ssh(find(depths==0))=NaN;
         sla(:,:,ii)=ssh-mssh;
         myear(cnt+ii)=str2num(flist(ii).name(10:13));
         mday(cnt+ii)=str2num(flist(ii).name(24:26));
      end
      for tt=1:1:size(sla,3)
         for ii=1:1:length(ipiv)
            ana(ii,tt)=sla(ipiv(ii),jpiv(ii),tt);
         end
      end
      clear sla ssh depths lon lat tt ii
   
      % calc RMSE
      uniq_age=[6:-1:0];
      for ii=1:1:length(uniq_age)
         agei=find(age==uniq_age(ii));
         ana_rmse(cnt+ii)=sqrt(sum(((ana(agei,ii)-obs(agei)).^2))/length(agei));
         %test(cnt+ii)=sqrt(mean(inov(agei).^2));
         clear agei
      end

      cnt=cnt+ii;

      clear ana age flist ii ipiv jpiv obs uniq_age

   end

end

jday=[julday-cnt+1:1:julday];
time=datenum(1950,1,1)+jday;

clear mssh cnt julday

save rmse.mat

%figure('Position',[22 107 1234 569],'PaperPositionMode','auto')
%plot(time,ana_rmse,'k-','linew',1.2)
%datetick('x','dd/mm/yyyy')        
%set(gca,'XTick',time)
%xlim([time(1) time(end)])
%ylim([0 0.25])
%grid
%hold on
%for ii=1:7:length(time)
   %plot([time(ii) time(ii)],[0 0.25],'k--')
%end; clear ii
%title('RMSE HYCOM - along track SLA')
%ylabel('RMSE (m^2)')
%print('-dpng','-r200',[pwd,'/RMSE.png')
