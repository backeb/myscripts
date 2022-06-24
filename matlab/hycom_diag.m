% 
% calculate weekly (or daily) means of 
% 1. total volume (add up all the layer thicknesses and times by dx and dy)
% 2. surface averaged (over whole domain) kinetic energy
% 3.volume averaged (over whole domain) kinetic energy
% 4. surface averaged salinity and temperature 
% 5. volume averaged temperature and salt. 
% 
% need to be in the directory where your data is for this to work

clear all
close all

% get grid info
obj=abfile('regional.grid.a','regional_grid');
%lat=getfield(obj,'plat',[],[]);
%lon=getfield(obj,'plon',[],[]);
dx=getfield(obj,'scpx',[],[]);
dy=getfield(obj,'scpy',[],[]);

% get land mask
%[depths]=readbathy(size(dx,1),size(dx,2));
%landmask=find(depths==depths(1,1));
%clear depths

filelist=dir(['*AVE_*.a']);
if  isempty(filelist)==1;
   disp('error - no files of this type in directory')
   break
end
yrstrt=str2num(filelist(1).name(8:11))
yrnd=str2num(filelist(end).name(8:11))

filetype=[];
if isempty(strfind(filelist(1).name,'AVE'))==0
   filetype='nersc_weekly';
elseif isempty(strfind(filelist(1).name,'DAILY'))==0  
   filetype='nersc_daily';
else
   disp('error - filetype could not be defined');
end   

% get landmask
obj=abfile(filelist(1).name,filetype);
dp=getfield(obj,'pres',[],[]);
landmask=find(dp==0);
clear obj

clear filelist

for yy=yrstrt:1:yrnd

   filelist=dir(['AGUAVE_',num2str(yy),'*.a']);
   if  isempty(filelist)==1;
         disp('error - no files of this type in directory')
         break
   end


   for ii=1:1:length(filelist)
   
      obj=abfile(filelist(ii).name,filetype);

      disp(['calculating fields for ',filelist(ii).name])

      % 1. volume
      dp=getfield(obj,'pres',[],[]);
      dp(landmask)=NaN;
      dp=permute(dp,[2 3 1]);
      vol(ii)=nansum(nansum(nansum(dp,3).*dx.*dy));
      clear dp

      % 2. surface avg kinetic
      tmpk=getfield(obj,'kinetic',[],[]);
      tmpk(landmask)=NaN;
      tmpk=permute(tmpk,[2 3 1]);
      tmpk2=tmpk(:,:,1);
      surfkin(ii)=nanmean(nanmean(tmpk2));
      clear tmpk2

      % 3. volume avg kinetic
      volkin(ii)=nansum(nansum(nansum(tmpk)))./vol(ii);
      clear tmpk

      % 4. surface avg T & S
      tmpT=getfield(obj,'temp',[],[]);
      tmpT(landmask)=NaN;
      tmpT=permute(tmpT,[2 3 1]);
      tmpT2=tmpT(:,:,1);
      surftemp(ii)=nanmean(nanmean(tmpT2));
      clear tmpT2
      tmpS=getfield(obj,'saln',[],[]);
      tmpS(landmask)=NaN;
      tmpS=permute(tmpS,[2 3 1]);
      tmpS2=tmpS(:,:,1);
      surfsaln(ii)=nanmean(nanmean(tmpS2));
      clear tmpS2

      % 5. volume avg T & S
      voltemp(ii)=nansum(nansum(nansum(tmpT)))./vol(ii);
      volsaln(ii)=nansum(nansum(nansum(tmpS)))./vol(ii);
      clear tmpT tmpS

   end

   clear filelist obj
   close all

   save(['hycom_diag_',num2str(yy),'.mat'],'surfkin','surfsaln','surftemp','vol','volkin','volsaln','voltemp')

   clear surfkin surfsaln surftemp vol volkin volsaln voltemp
   close all

end

clear all
close all

filelist=dir(['hycom_diag_*.mat']);
if  isempty(filelist)==1;
      disp('error - no hycom_diag_YYYY.mat files in directory')
      break
end

len=0;

for ii=1:1:length(filelist)
   a=load(filelist(ii).name);

   surfkin(len+1:len+length(a.surfkin))=a.surfkin;
   surfsaln(len+1:len+length(a.surfsaln))=a.surfsaln;
   surftemp(len+1:len+length(a.surftemp))=a.surftemp;
   vol(len+1:len+length(a.vol))=a.vol;
   volkin(len+1:len+length(a.volkin))=a.volkin;
   volsaln(len+1:len+length(a.volsaln))=a.volsaln;
   voltemp(len+1:len+length(a.voltemp))=a.voltemp;

   len=len+length(a.vol);

   clear a
end
clear len filelist

save hycom_diag.mat

