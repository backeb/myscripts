function ttg(yri,moni,dayi,hri,mini,seci);

%
% displays time to go until ...
%
% usage:
% ttg(yri,moni,dayi,hri,mini,seci);
%
% ttg(2007,11,12,22,40,0);
%

toa=datenum(yri,moni,dayi,hri,mini,seci);

days=floor(toa-datenum(now));
hrs=floor((toa-datenum(now)-days)*24);
mins=floor((((toa-datenum(now)-days)*24)-hrs)*60);
secs=floor((((((toa-datenum(now)-days)*24)-hrs)*60)-mins)*60);

t=[days hrs mins secs];

disp(['time to go is: ',num2str(days),' days ', ...
                        num2str(hrs),' hrs ', ...
                        num2str(mins),' mins ', ...
                        num2str(secs),' secs']);
