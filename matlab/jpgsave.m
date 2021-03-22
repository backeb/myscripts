function jpgsave(title)
% saves image as jpg
%
% usage: jpgsave('filename')
% e.g.   jpgsave('/home/bjornb/Work/plot')
%
% note: 
% often does not save filled colours when used with m_map toolbox
disp(['image saved as ',title])
saveas(gcf,title,'jpg')
