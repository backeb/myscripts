clear all
close all

D=[0:10:100 125:25:500 600:100:3000 3500:500:5000]';

dlmwrite('depthlevels.in',[num2str(length(D)),'                  # Number of z levels'],'delimiter','');
dlmwrite('depthlevels.in',D,'-append');

