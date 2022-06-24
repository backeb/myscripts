clear all
close all

cnt=1;
for julday=21843:7:21913-7 % because 21913 is the last time we assimilate, we stop running the forecast

   pname=['../',num2str(julday),'/ANALYSIS/'];
   % obs at model points
   nc=netcdf([pname,'observations-SST.nc']);
   lon=nc{'lon'}(:);
   lat=nc{'lat'}(:);
   obs=nc{'d'}(:);
   obs_error=sqrt(nc{'var'}(:));
   ipiv=nc{'ipiv'}(:);
   jpiv=nc{'jpiv'}(:);
   %inno=nc{'innovation'}(:);
   close(nc); clear nc
   
   % forecast, i.e. before assimilation
   nc=netcdf([pname,'Dyna001.nc']);
   tmpfcast=nc{'temp'}(1,:,:)';
   close(nc); clear nc
   
   % analysis, i.e. after assimilation
   nc=netcdf([pname,'fixanalysis001.nc']);
   tmpana=nc{'temp'}(1,:,:)';
   close(nc); clear nc pname
   
   % daily avg the day after assimilation
   pname=['../',num2str(julday+7),'/FORECAST/']; % +7 because forecast fields are stored in next weeks folder
   year=datestr(datenum(1950,1,1)+julday,'yyyy');
   dayofyear=datenum(1950,1,1)+julday-datenum(str2num(year),1,1);
   if dayofyear<10
      dayofyear=['00',num2str(dayofyear)];
   elseif dayofyear>=10 & dayofyear<100
      dayofyear=['0',num2str(dayofyear)];
   else
      dayofyear=num2str(dayofyear);
   end
   [tmpdaily,tmp,tmp,depths]=loaddaily([pname,'AGUDAILY_',year,'_',dayofyear,'_',year,'_',dayofyear,'.a'],'temp',1);
   tmpdaily(find(depths==0))=NaN;
   clear depths tmp pname
   
   % free run daily avg
   pname='../../hycom/AGUa0.10/expt_01.3/data/';
   f=dir([pname,'AGUDAILY_',year,'_*_',year,'_',dayofyear,'.a']);
   [tmpfree,tmp,tmp,depths]=loaddaily([pname,f.name],'temp',1);
   tmpfree(find(depths==0))=NaN;
   clear depths tmp pname year
   
   display(['calc rmse for julday ',num2str(julday)])
   
   for ii=1:1:length(ipiv)
      fcast(ii,1)=tmpfcast(ipiv(ii),jpiv(ii));
      ana(ii,1)=tmpana(ipiv(ii),jpiv(ii));
      ana_daily(ii,1)=tmpdaily(ipiv(ii),jpiv(ii));
      free_daily(ii,1)=tmpfree(ipiv(ii),jpiv(ii));
   end
   clear ii tmp* *piv
   
   obs_error2(cnt)=mean(obs_error);
   fcast_rmse(cnt)=sqrt(sum(((fcast-obs).^2))/length(obs));
   ana_rmse(cnt)=sqrt(sum(((ana-obs).^2))/length(obs));
   ana_daily_rmse(cnt)=sqrt(sum(((ana_daily-obs).^2))/length(obs));
   free_daily_rmse(cnt)=sqrt(sum(((free_daily-obs).^2))/length(obs));
   clear fcast ana ana_daily free_daily
   
   cnt=cnt+1;
   
end


