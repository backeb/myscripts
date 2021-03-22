function [lon,lat,varout]=LoadDrifterData(filename,varin)
% load drifter data from MEDS-SDMM
%
% usage: [lon,lat,varout]=LoadDrifterData(filename,varin)
% e.g.   [lon,lat,pdt]=LoadDrifterData('BUOY_CSV0408193599_001.CSV','pdt');
%
% available data (for varin):
% 'id' - identifier = wmo buoy number
% 'odt' - observation date and time (MatLab datenum format)
% 'qc_pos' - quality control flag for position**
% 'pdt' - position date and time (MatLab datenum format)
% 'drogue' - drogue depth (m)*
% 'sst' - seasurface temperature (C)
% 'qc_sst' - quality control sst**
% 'air_temp' - air temperature (C)
% 'qc_air_temp' - quality control air temperature**
% 'pres' - air pressure at sea level
% 'qc_pres' - quality control air pressure at sea level**
% 'wsp' - wind speed (m/s)
% 'qc_wsp' - quality control wind speed**
% 'wdir' - wind direction relative to true north
% 'qc_wdir' - quality control wind direction**
% 'relhum' - relative humidity (%)
% 'qc_relhum' - quality control relative humidity
%
% ** quality control flags:
% 0=not checked, 1=good, 3=doubtful, 4=bad
%
% note about observation and position date and time
% where no observation / position date and time available
% odt / pdt set to zero
%
% note about drogue depth
% 9999.9 indicates that the drogue is detached
% a blank value usually means that the buoy was not drogued

% data starts at line 32
% cvsread row and column read are zero-based, therefore start read at 31
% tmp file to extract data from
tmp=csvread(filename,31,0);

% latitude (positive north)
lat=tmp(:,4);
% longitude (positive east)
lon=tmp(:,5)*(-1);

%disp(['extracting ',varin,' from ',filename]);

switch varin
 case 'id'
  varout=tmp(:,1);
 case 'odt' % observation date and time (MatLab datenum format) - n/a
  tmp1=tmp(:,2);
  % treat tmp1 (date) for inclusion in datenum format
  tmp1(find(tmp1==0))=99999999;tmp1=num2str(tmp1);
  % treat tmp2 (time) for inclusion in datenum format
  tmp2=tmp(:,3);
  tmp2(find(tmp2==0))=9999;
  z=find(tmp2<100);zz=find(tmp2>100 & tmp2<1000);
  tmp2=num2str(tmp2);
  tmp2(z,1)='0';tmp2(z,2)='0';
  tmp2(zz,1)='0';
  % create datenum vector
  varout=[str2num(tmp1(:,1:4)) str2num(tmp1(:,5:6)) str2num(tmp1(:,7:8)) ...
          str2num(tmp2(:,1:2)) str2num(tmp2(:,3:4)) zeros(length(tmp1),1)];
  varout(find(varout(:,1)==9999),:)=0; 
  varout=datenum(varout);
  %disp(['Note: where no observation date / time available, datenum set to zero']);
 case 'qc_pos' % quality control flag for position**
  varout=tmp(:,6);
 case 'pdt' % position date and time (MatLab datenum format) - n/a
  tmp1=tmp(:,7);
  % treat tmp1 (date) for inclusion in datenum format
  tmp1(find(tmp1==0))=99999999;tmp1=num2str(tmp1);
  % treat tmp2 (time) for inclusion in datenum format
  tmp2=tmp(:,8);
  tmp2(find(tmp2==0))=9999;
  z=find(tmp2<100);zz=find(tmp2>100 & tmp2<1000);
  tmp2=num2str(tmp2);
  tmp2(z,1)='0';tmp2(z,2)='0';
  tmp2(zz,1)='0';
  % create datenum vector
  varout=[str2num(tmp1(:,1:4)) str2num(tmp1(:,5:6)) str2num(tmp1(:,7:8)) ...
          str2num(tmp2(:,1:2)) str2num(tmp2(:,3:4)) zeros(length(tmp1),1)];
  varout(find(varout(:,1)==9999),:)=0; 
  varout=datenum(varout);
  %disp(['Note: where no observation date / time available, datenum set to zero']);
 case 'drogue' % drogue depth (m)
  varout=tmp(:,9);
 case 'sst' % seasurface temperature (C)
  varout=tmp(:,10);
 case 'qc_sst' % quality control sst**
  varout=tmp(:,11);
 case 'air_temp' % air temperature (C)
  varout=tmp(:,12);
 case 'qc_air_temp' % quality control air temperature**
  varout=tmp(:,13);
 case 'pres' % air pressure at sea level
  varout=tmp(:,14);
 case 'qc_pres' % quality control air pressure at sea level**
  varout=tmp(:,15);
 case 'wsp' % wind speed (m/s)
  varout=tmp(:,16);
 case 'qc_wsp' % quality control wind speed**
  varout=tmp(:,17);
 case 'wdir' % wind direction relative to true north
  varout=tmp(:,18);
 case 'qc_wdir' % quality control wind direction**
  varout=tmp(:,19);
 case 'relhum' % relative humidity (%)
  varout=tmp(:,20);
 case 'qc_relhum' % quality control relative humidity
  varout=tmp(:,21);
 otherwise
  disp('error varin - unknown variable')
end

clear tmp
