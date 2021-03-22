% MAKE DRIFTER FIGURE

clear

% make list of all drifter data
DataDirPath='/home/bjornb/Work/AgulhasDrifterData/data/';
FileList=dir([DataDirPath,'*.CSV']);

LenCnt=0;
for ff=1:1:length(FileList)
	disp(['#',num2str(ff),': Processing ',DataDirPath,FileList(ff).name])

	% load all data as tmp variables
	[tmpLon,tmpLat,tmpId]=LoadDrifterData([DataDirPath,FileList(ff).name],'id');
	[tmpLon,tmpLat,tmpQcPos]=LoadDrifterData([DataDirPath,FileList(ff).name],'qc_pos');
	[tmpLon,tmpLat,tmpPdt]=LoadDrifterData([DataDirPath,FileList(ff).name],'pdt');
	[tmpLon,tmpLat,tmpDrogue]=LoadDrifterData([DataDirPath,FileList(ff).name],'drogue');

	% find good drifter data indices
	% tmpQcPos==1 - position given is good!
	% tmpDrogue==15 - drifters which have a drogue at 15 m!
	% tmpPdt~=0 - drifters where position date and time is available!
	GoodDataIndex=find(tmpQcPos==1 & tmpDrogue==15 & tmpPdt~=0);	

	% remove bad drifter data and create final variables
	Id(LenCnt+1:LenCnt+length(GoodDataIndex),1)=tmpId(GoodDataIndex);
	Lon(LenCnt+1:LenCnt+length(GoodDataIndex),1)=tmpLon(GoodDataIndex);
	Lat(LenCnt+1:LenCnt+length(GoodDataIndex),1)=tmpLat(GoodDataIndex);
	Pdt(LenCnt+1:LenCnt+length(GoodDataIndex),1)=tmpPdt(GoodDataIndex);
	
	% update LenCnt
	LenCnt=LenCnt+length(GoodDataIndex);

	clear tmp* GoodDataIndex

end

clear DataDirPath FileList LenCnt ff

% remove drifter ID 33503
% drifter was transmitting data while onboard a ship
RmData=find(Id~=33503);
Id=Id(RmData);
Lon=Lon(RmData);
Lat=Lat(RmData);
Pdt=Pdt(RmData);
clear RmData

save DrifterData.mat
