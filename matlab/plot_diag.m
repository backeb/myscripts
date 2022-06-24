load hycom_diag.mat

% plot
figure( 'Units','centimeters',...
        'Position',[1 1 20 30],...
        'PaperUnits','centimeters',...
        'PaperPosition',[1 1 20 30],...
                'Color',[1 1 1])

subplot(7,1,1)
   plot([1:length(vol)],vol,'k');
   axis tight
   title('Total volume (m^3)');

subplot(7,1,2)
   plot([1:length(surfkin)],surfkin,'k');
   axis tight
   title('Surfave averaged kinetic energy (m^2.s^-^2)')

subplot(7,1,3)
   plot([1:length(volkin)],volkin,'k');
   axis tight
   title('Volume averaged kinetic energy (m^2.s^-^2)')

subplot(7,1,4)
   plot([1:length(surftemp)],surftemp,'k');
   axis tight
   title('Surface averaged temperature ({\circ}C)')

subplot(7,1,5)
   plot([1:length(voltemp)],voltemp,'k');
   axis tight
   title('Volume averaged temperature ({\circ}C)')


subplot(7,1,6)
   plot([1:length(surfsaln)],surfsaln,'k');
   axis tight
   title('Surface averaged salinity (PSU)')

subplot(7,1,7)
   plot([1:length(volsaln)],volsaln,'k');
   axis tight
   title('Volume averaged salinity (PSU)')
   xlabel('Model weeks')

ModExp=pwd;
ModExp=[ModExp(33:40),ModExp(42:45),ModExp(47:50)]
print('-dpng','-r200',['~/Figs/',ModExp,'_diag.png'])  
clear ModExp


