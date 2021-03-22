function figprint(title,res)
% saves images using print('-depsc2','resolution','filename.extension') function
%
% usage figprint('filename',resolution)
% e.g.  figprint('/home/bjornb/Work/filename',100)
title=[title];
disp(['image saved as ',title])
%print('-depsc2','-r600',title)
print('-depsc2',['-r',num2str(res)],title)

