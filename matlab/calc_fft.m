function [y,pyy,pyynorm,nf,freq]=calc_fft(datain)
% function [y,pyy,pyynorm,nf,freq]=calc_fft(datain)
%
% apply fft to data series
% requires data series to have constant delta t / delta x
%
% output:
% y		=	fft
% pyy 		= 	power spectrum
% pyynorm	= 	power spectrum normalised by its maximum value
% nf 		=	nyquist frequency
% freq 		= 	frequency vector 
%			(the number of times a signal is repeated for a data series)
% to plot do:
%   semilogx(pyy(1:nf))
%   title('power spectrum')


% normalize by standard deviation (not necessary)
%variance = std(datain)^2;
%datain = (datain - mean(datain))/sqrt(variance);

%% condition data
s=length(datain);
taped=datain;
%% detrend data
taped=detrend(taped);
%% taper first 10% of data
for i=1:1:floor(0.1*s)
  taped(i,1)=taped(i,1)*(sin(pi*(i-1)/(floor(0.1*s)*2)))^2;
end
%% taper last 10% of data
for i=s:-1:floor(0.9*s)
   taped(i,1)=taped(i,1)*(sin(pi*(i-1)/(floor(0.1*s)*2)))^2;
end
datain=taped;

%% the fft
y=fft(datain,length(datain));

%% power spectrum
pyy=y.*conj(y); % is the same as pyy=abs(y)^2;

%% normalise by max
pyynorm=pyy./max(pyy);

%% nyquist frequency
nf=floor(size(pyy,1)/2)+1;
%disp(['Nyquist frequency is ',num2str(nf)]);

%% frequency is given here as the number of times a signal is repeated for the data series
freq=[1:1:nf];

