
%This program performs the Continuous Wavelet Transform (CWT) 
%of the input time series y. 
%It plots the series in normalized form 
%and displays the modulus (amplitude) of the CWT 
%in the time-period space. 
%The period is expressed in unit of time.
%
%The normalization of the CWT is 1/a instead of the 
%usual 1/sqrt(a)  (a is the dilatation
%parameter). With this normalization, the 
%amplitudes may be compared to each other
%

%What you simply have to do is:
%(1) rename your time series y
%(2) type CWT

%If you want to look more precisely at the output, 
%there two important files:
%(1) the matrix named "wave" is the CWT matrix
%(2) the periods for which the CWT is calculated 
%   are in the vector named "period" 

%reference:
%
%Mallat, S. 1998: A wavelet Tour of Signal Processing. 
%Academic Press, 577 pp.
%
%some parts of this script are adapted from:
%
%Torrence C., Compo G.P. 1999: A practical guide to 
%wavelet analysis. Bull. Am. Meteorol. Soc. 79: 61-78.
%( in this paper the normalization is 1/sqrt(a) ) 
%




y=reshape(y,length(y),1);
clear aa period yyyy yyyylab x1 x2 wave scale f x scale;
ny=length(y);
ny2=round(ny/2);
exp1=0;
exp2=round(log2(ny2))+1;
inter=20;

j=0;
k0=5.4;
for m=exp1:exp2-1;
   jj=inter-1;
   for n=0:jj;
      a=2^(m+n/inter);
      j=j+1;
      aa(j)=a;
   end;
end;
a=2^exp2;
aa(j+1)=a;
omega0=1/2*(k0./aa+sqrt(2+k0*k0)./aa);
period=1./omega0*2*pi;
aa=aa';
period=period';



  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


y=y';
y=(y-mean(y))/std(y);
k0=5.4;
%
dt=1;
n1=length(y);
base2=fix(log(n1)/log(2)+0.4999);
if(2^base2-n1 < 0) base2=base2+1;
   end;
x=[y,zeros(1,2^base2-n1)];
y=y';
n=length(x);
%
k=[1:fix(n/2)];
k=k.*((2.*pi)/(n*dt));
k=[0., k, -k(fix((n-1)/2):-1:1)];
%
f=fft(x);
%
scale=aa;
J=length(aa);
wave=zeros(J,n);
wave=wave+i*wave;
%
nn=length(k);
for a1=1:J;
expnt=-(scale(a1).*k - k0).^2/2.*(k > 0.);
norm=sqrt(scale(a1)*k(2))*(pi^(-0.25))*sqrt(nn);
daughter=norm*exp(expnt);
daughter=daughter.*(k>0.);
wave(a1,:)=ifft(f.*daughter)/sqrt(scale(a1));
end;
wave=wave(1:J,1:n1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
orient tall;
subplot(4,1,2);
plot(y);
axis([1 length(y) min(y) max(y)]);
ylabel('standardized data','FontSize',12);

subplot(2,1,2);
contourf(abs(wave),8);
view(0,-90);

  for k=1:exp2+1;
     exponent=k-1;
     brol=abs(period-2^exponent);
     [x1,x2]=min(brol);
     yyyy(k)=x2;
     yyyylab(k)=2^exponent;
  end;
  set(gca,'yTick',yyyy,'yTickLabel',yyyylab);
  ylabel('period (in time unit)','FontSize',12);
  title('CWT modulus','FontSize',12);
  colorbar('horiz');



