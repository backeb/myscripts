function fig=plot_wavelet(Yin,TimeIn,DefTitle);
% function fig=plot_wavelet(Yin,TimeIn);
%
% apply torrence wavelet.m to time series
% requires time series to have constant delta t
%
% rename time series 'y'
% make sure time vector is in datenum format
%
% type apply_torrence_wavelet
%
% note: the period corresponds to time-units for a cycle
% e.g. for weekly data a period of 8 = 8 weeks / 2 months
% and 52 = 52 weeks / 1 year

%time=datenum(yr_mon); % construct time vector
time=TimeIn;
y=Yin;;

% normalize by standard deviation (not necessary)
variance = std(y)^2;
y = (y - mean(y))/sqrt(variance);

n = length(y);
dt = 1;
xlim = [time(1),time(n)];  % plotting range
pad = 1;      % pad the time series with zeroes (recommended)
dj = 0.25;    % this will do 4 sub-octaves per octave
s0 = 2*dt;    % this says start at a scale of 6 months
j1 = 7/dj;    % this says do 7 powers-of-two with dj sub-octaves each
lag1 = 0.7788;  % lag-1 autocorrelation for red noise background
% lag-1 = exp(-1/a), where a=time period, e.g. in the case of monthly data a=months
siglvl = 0.80;
mother = 'Morlet';

% Wavelet transform:
[wave,period,scale,coi] = wavelet(y,dt,pad,dj,s0,j1,mother);
power = (abs(wave)).^2 ;        % compute wavelet power spectrum

% Significance levels: (variance=1 for the normalized SST)
[signif,fft_theor] = wave_signif(1.0,dt,scale,0,lag1,siglvl,-1,mother);
sig95 = (signif')*(ones(1,n));  % expand signif --> (J+1)x(N) array
sig95 = power ./ sig95;         % where ratio > 1, power is significant

% Global wavelet spectrum & significance levels:
global_ws = variance*(sum(power')/n);   % time-average over all times
dof = n - scale;  % the -scale corrects for padding at edges
global_signif = wave_signif(variance,dt,scale,1,lag1,siglvl,dof,mother);


%------------------------------------------------------ Plotting

%--- Plot time series
subplot('position',[0.08 0.7 0.65 0.2])
plot(time,y);datetick;axis tight
grid on;
title('Normalised data')
hold off

%--- Contour plot wavelet power spectrum
subplot('position',[0.08 0.12 0.65 0.46])
levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
%contourf(time,log2(period),log2(power),log2(levels));  %*** or use 'contourfill'
pcolor(time,log2(period),log2(power));shading interp;
%colormap(gray);
%colorbar('horiz');
caxis([log2(levels(1)) log2(levels(length(levels)))]);
ylabel('Period');
datetick;
title('Wavelet power spectrum');
%imagesc(time,log2(period),log2(power));  %*** uncomment for 'image' plot
set(gca,'XLim',xlim(:))
set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel',Yticks)
% 95% significance contour, levels at -99 (fake) and 1 (95% signif)
hold on
contour(time,log2(period),sig95,[1 1],'w','linew',2.0);
hold on
% cone-of-influence, anything "below" is dubious
plot(time,log2(coi),'w--','linew',2.0)
hold off
grid on

%--- Plot global wavelet spectrum
subplot('position',[0.75 0.12 0.2 0.46])
plot(global_ws,log2(period))
hold on
plot(global_signif,log2(period),'--')
hold off
title(['Global spectrum'])
xlabel({'Power';['Significance level: ',num2str(siglvl*100),'%']})
%ylabel('Period')
set(gca,'YLim',log2([min(period),max(period)]), ...
	'YDir','reverse', ...
	'YTick',log2(Yticks(:)), ...
	'YTickLabel','')
set(gca,'XLim',[0,1.25*max(global_ws)])
grid on

