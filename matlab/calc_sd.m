function [sd]=calc_sd(sshin);
% function [sd]=calc_sd(sshin);
% 
% calculate standard deviation from ssh data, very similar (almost the same) as the standard deviation of ssh
% which gives an indication of the ssh variability, similarly to eddy kinetic energy
%
% routine assumes that data dimensions are layed out as:
% lon x lat x time (time in datenum format)
%
% equation:     
% sd = sqrt { 1/n * (sum(ssh^2) - 1/n^2*[sum(ssh)]^2 ) }
% where n is the number of weeks
%
% input variables:
% sshin = ssh input data
%
% output variables:
% sd = ssh sd

n=size(sshin,3);

% term 1 = 1/n*(sum(ssh^2))
for ii=1:1:size(sshin,3)
  ssh_sqd(:,:,ii)=sshin(:,:,ii).^2;
end
term_1=1/n*(sum(ssh_sqd,3));

% term 2 = 1/n^2*([sum(ssh)]^2)
sum_ssh=sum(sshin,3);
term_2=(1/(n^2))*(sum_ssh.^2);

% RMS

sub=term_1-term_2;

% sqrt for RMS
sd=sqrt(sub);

