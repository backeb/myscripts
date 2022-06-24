
% Load relax_tem.a / relax_sal.a files, 
% calc annual mean, extract section, calc potential density
% You must be in the directory of your clim. e.g.
% /work/fanf/HYCOM_2.2.12/hycom/TP3a0.12/relax/014

clear all
close all

rtobj=abfile('relax_tem.a','relax');
rsobj=abfile('relax_sal.a','relax');
riobj=abfile('relax_int.a','relax');

levels=getlevels(rtobj)';
months=gettimes(rtobj)';

%disp('making annual mean for all layers from clim')
for ii=1:1:levels(end)

   tmptem=getfield(rtobj,'tem',ii,[]); % get all time fields for level 1
   tmptem=permute(tmptem,[2 3 1]);
   tem(:,:,ii)=nanmean(tmptem,3);

   tmpsal=getfield(rsobj,'sal',ii,[]); % get all time fields for level 1
   tmpsal=permute(tmpsal,[2 3 1]);
   sal(:,:,ii)=nanmean(tmpsal,3);

   tmpint=getfield(riobj,'int',ii,[]); % get all time fields for level 1
   tmpint=permute(tmpint,[2 3 1]);
   int(:,:,ii)=nanmean(tmpint,3); % this has something to do with the layer depths

   clear tmp*

end

dp=int/9806; % calc layer depths

clear ii months *obj int

% get the section

i_index=[1 520  ];
j_index=[300 300];

tem_sec=squeeze(tem([min(i_index):max(i_index)],[min(j_index):max(j_index)],:));
sal_sec=squeeze(sal([min(i_index):max(i_index)],[min(j_index):max(j_index)],:));
dp_sec=squeeze(dp([min(i_index):max(i_index)],[min(j_index):max(j_index)],:));

horiz_ind=[1:size(dp_sec,1)]';
horiz_ind=repmat(horiz_ind,[1 size(dp_sec,2)]);

figure
subplot(1,2,1)
pcolor(horiz_ind,-dp_sec,tem_sec);shading flat;colorbar('horiz')
title('temperature')
subplot(1,2,2)
pcolor(horiz_ind,-dp_sec,sal_sec);shading flat;colorbar('horiz')
title('salinity')


% calc pot dens. use seawater package
% note: dp = pressure

pden = sw_pden(sal_sec,tem_sec,dp_sec,0);

figure
pcolor(horiz_ind,-dp_sec,pden-1000);shading flat;colorbar('horiz')
title('potential density')
min(min(pden-1000))
max(max(pden-1000))

