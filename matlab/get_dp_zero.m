clear all
close all

addpath /home/nersc/bjornb/hycom/MSCPROGS/matlab/toolbox/My_Loaddata/

flist=dir('AGUrestart*00.a');

dp0=zeros(520,430,30);

for i=1:1:length(flist)

   disp([num2str(i),' of ',num2str(length(flist))])
   [dp,tmp,tmp,tmp]=loadrestart(flist(i).name,'dp',1,30);
   clear tmp
   dp=permute(dp,[2 3 1]);

   ind=find(dp==0);
   disp(['zero index is ',num2str(length(ind))])
   dp0(ind)=dp0(ind)+1;

   clear ind dp

end
