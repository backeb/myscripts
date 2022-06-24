function [meanssh,lon,lat,depths]=load_meanssh_dot_uf(fname,idm,jdm)
% function [meanssh,lon,lat,depths]=load_meanssh_dot_uf(fname);
% where  fname = meanssh.uf, or similar
%        idm = length of i-dimension
%        jdm = length of j-dimension

fid=fopen(fname,'r','ieee-be');
stat=fseek(fid,4,'bof'); % Skip fortran 4-byte header
meanssh=fread(fid,[idm jdm],'double');

[lon,lat,depths]=loadgrid();

% replace land with NaN
meanssh(depths==0)=NaN;
