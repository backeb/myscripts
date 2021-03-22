function jpgprint(title)
% saves images as jpg using print('-depsc2','...') function
%
% usage jpgprint('filename')
% e.g.  jpgprint('/home/bjornb/Work/filename')
title=[title,'.jpg'];
disp(['image saved as ',title])
print('-depsc2','-r600',title)

