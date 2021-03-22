% load ADCP .mat files extracted using WinADCP into Matlab and export to .txt file

% create file list for recall in loop
prefix='alg160_';
filelist=dir([prefix,'*.mat']);

% load all data in directory
display(['loading all ',prefix,' data in directory'])
lcnt=0;
for ff=1:1:size(filelist,1)

	% load filename from list
	load([filelist(ff).name]);

	% find and replace fill values with NaN
	% fill value is -32786
	fillval=-32768;
	SerMagmmpersec(find(SerMagmmpersec==fillval))=NaN;
	SerDir10thDeg(find(SerDir10thDeg==fillval))=NaN;
	SerEmmpersec(find(SerEmmpersec==fillval))=NaN;
	SerNmmpersec(find(SerNmmpersec==fillval))=NaN;
	clear fillval

	for ii=1:1:size(SerNmmpersec,2)

		% --Bjorn: 	Ignore magnitude and direction for time being
		% 			Unsure of treatment of variables wrt Nav info

		%% magnitude in cm/s 
		%mag(lcnt+1:lcnt+size(SerDay,1),ii)=SerMagmmpersec(:,ii);
		%% degrees 0-360
		%direc(lcnt+1:lcnt+size(SerDay,1),ii)=SerDir10thDeg(:,ii);

		% u comp in cm/s
		u(lcnt+1:lcnt+size(SerDay,1),ii)=AnNVEmmpersec+SerEmmpersec(:,ii);
		% v comp in cm/s
    	v(lcnt+1:lcnt+size(SerDay,1),ii)=AnNVNmmpersec+SerNmmpersec(:,ii);
	
		% percent good of beams 1-4
    	pg1(lcnt+1:lcnt+size(SerDay,1),ii)=SerPG1(:,ii);
	    pg2(lcnt+1:lcnt+size(SerDay,1),ii)=SerPG2(:,ii);
    	pg3(lcnt+1:lcnt+size(SerDay,1),ii)=SerPG3(:,ii);
	    pg4(lcnt+1:lcnt+size(SerDay,1),ii)=SerPG4(:,ii);

	end

	clear ii

	% longitude in decimal degrees
	% AnFLonDeg = lon at beginning of data ensemble
	% AnLLonDeg = lon at end of data ensemble
	lon(lcnt+1:lcnt+size(SerDay,1))=AnFLonDeg+(AnFLonDeg-AnLLonDeg)/2;
	% latitude in decimal degrees
	% AnFLatDeg = lat at beginning of data ensemble
	% AnLLatDeg = lat at end of data ensemble
	lat(lcnt+1:lcnt+size(SerDay,1))=AnFLatDeg+(AnFLatDeg-AnLLatDeg)/2;
	% time in matlabs datenum format
	time(lcnt+1:lcnt+size(SerDay,1))=datenum(2000+SerYear,SerMon,SerDay,SerHour,SerMin,SerSec);

	% modify lcnt
 	lcnt=lcnt+size(SerDay,1);
 
 	clear An* RDI* Ser*
 
end

clear ff i lcnt m n prefix

% adjust scale to degrees and m/s
%direc=direc./10;
%mag=mag./1000;
u=u./1000;
v=v./1000;
[mag,direc]=uv2magdir(u,v);


% permute for plotting
%direc=direc';
%mag=mag';
pg1=pg1';
pg2=pg2';
pg3=pg3';
pg4=pg4';
u=u';
v=v';

% create distance vector
dist=[0 cumsum(m_lldist(lon,lat))']';

% create depth depth in m
load([filelist(1).name],'RDIBin1Mid','RDIBinSize','SerBins'); 
depth=[RDIBin1Mid RDIBin1Mid+RDIBinSize*SerBins(2:end)]*(-1);
clear RDIBin1Mid RDIBinSize SerBins

% select time period
tp=find(time>=datenum(2008,11,29,6,0,0) & time<=datenum(2008,12,2,6,0,0));
direc=direc(tp,:);
dist=dist(tp);
lat=lat(tp)';
lon=lon(tp)';
mag=mag(tp,:);
pg1=pg1(:,tp)';
pg2=pg2(:,tp)';
pg3=pg3(:,tp)';
pg4=pg4(:,tp)';
time=time(tp)';
u=u(:,tp)';
v=v(:,tp)';

%save matlab file
disp('saving matlab file')
save adcp_data_raw.mat

%% write to .txt
disp('writing data to ascii files')
dlmwrite('depth.txt',depth,'delimiter','\t','precision','%.2f');
dlmwrite('direc.txt',direc,'delimiter','\t','precision','%.2f');
dlmwrite('dist.txt',dist,'delimiter','\t','precision','%.2f');
dlmwrite('lat.txt',lat,'delimiter','\t','precision','%.2f');
dlmwrite('lon.txt',lon,'delimiter','\t','precision','%.2f');
dlmwrite('mag.txt',mag,'delimiter','\t','precision','%.2f');
dlmwrite('pg1.txt',pg1,'delimiter','\t','precision','%.2f');
dlmwrite('pg2.txt',pg2,'delimiter','\t','precision','%.2f');
dlmwrite('pg3.txt',pg3,'delimiter','\t','precision','%.2f');
dlmwrite('pg4.txt',pg4,'delimiter','\t','precision','%.2f');
dlmwrite('time.txt',datevec(time),'delimiter','\t');
dlmwrite('u.txt',u,'delimiter','\t','precision','%.2f');
dlmwrite('v.txt',v,'delimiter','\t','precision','%.2f');
%clear data

