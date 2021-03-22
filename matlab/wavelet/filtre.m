%first run CWT
%type contourf(abs(wave),40);
%first and second are the numbers (index) of the periods 
%for which you want to filter the data
%the corresponding periods are period(first) and period(second)
%filtrage is the filter between period(first) and period (second)
%you can then plot filtrage (the filered data) superimposed on the real data y
%you just do plot(filtrage), hold on, plot(y,'r')


somme=sum(real(wave(1:length(aa),:)));
filtrage=sum(real(wave(first:second,:)));
standard=std(somme);
filtrage=filtrage/standard;
