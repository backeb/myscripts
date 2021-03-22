function fig=fitvario(type,lineopt,x,C1,a1,C2,a2);
% function fig=fitvario(type,lineopt,x,C1,a1,C2,a2);
%
% fit theoretical curve to variogram
% where type	type of theoretical curve
% 	lineopt	lineoptions for plot, color, linestyle etc
%	x	distance vector
%	C1/C2	amplitude
%	a1/a2	range
% 	lineopt	lineoptions for plot, color, linestyle etc
%
% use C2 and a2 for combination fits, e.g. gaussian + cosine
%
% available theoretical curves (types):
% - 'gaussian'
% - 'exponential'
% - 'cardinal sine'
% - 'gaussian + cardinal sine'
% - 'gaussian + cosine'

if strcmp(type,'gaussian')==1

	% gaussian:
	% yi = C1 * (1 - exp(-(x / a1) .^ 2))
	% where C1 = amplitude, a1 = range, x = distance vector.
	yi=C1*(1-exp(-([0 x]/a1).^2)); % theoretical gaussian curve

	disp(' ');
	disp('fitvario variables:')
	disp(' ');
	disp(['amplitude C1 = ',num2str(C1)]);
	disp(['range a1 = ',num2str(a1)]);
	disp(' ');

elseif strcmp(type,'exponential')==1

	% exponential:
	% yi = C1 * (1 - exp(-(x / a1)))
	% where C1 = amplitude, a1 = range, x = distance vector
	yi=C1*(1-exp(-([0 x]/a1)));
	
	disp(' ');
	disp('fitvario variables:')
	disp(' ');
	disp(['amplitude C1 = ',num2str(C1)]);
	disp(['range a1 = ',num2str(a1)]);
	disp(' ');

elseif strcmp(type,'cardinal sine')==1

	% cardinal sine:
	% yi = C1 * (1 - (sin(x/a1))/abs(x/a1))
	% where C1 = amplitude, a1 = range, x = distance vector
	yi=C1*(1-sin([0 x]/a1)./abs([0 x]/a1));
	
	disp(' ');
	disp('fitvario variables:')
	disp(' ');
	disp(['amplitude C1 = ',num2str(C1)]);
	disp(['range a1 = ',num2str(a1)]);
	disp(' ');

elseif strcmp(type,'gaussian + cardinal sine')==1

	% gaussian + cardinal sine:
	% yi=C1*(1-(exp(-(x/a1).^2)))+C2*(sin(x/a2)./abs(x/a2))
	% where C[1/2] = amplitude, a[1/2] = range, x = distance vector
	yi=C1*((1-exp(-([0 x]/a1).^2)))+C2*(1-sin([0 x]/a2)./abs([0 x]/a2));

	disp(' ');
	disp('fitvario variables:')
	disp(' ');
	disp(['amplitude C1 = ',num2str(C1)]);
	disp(['range a1 = ',num2str(a1)]);
	disp(' ');
	disp(['amplitude C2 = ',num2str(C2)]);
	disp(['range a2 = ',num2str(a2)]);
	disp(' ');

elseif strcmp(type,'gaussian + cosine')==1

	% gaussian + cosine:
	% yi=C1*(1-exp(-([0 x]/a1).^2))+C2*(1-cos([0 x]/a2)); 
	% where C = amplitude, a = range, x = distance vector
	yi=C1*(1-exp(-([0 x]/a1).^2))+C2*(1-cos([0 x]/a2)); 

	disp(' ');
	disp('fitvario variables:')
	disp(' ');
	disp(['amplitude C1 = ',num2str(C1)]);
	disp(['range a1 = ',num2str(a1)]);
	disp(' ');
	disp(['amplitude C2 = ',num2str(C2)]);
	disp(['range a2 = ',num2str(a2)]);
	disp(' ');

else

	disp(['theoretical cure: type "',type,'" unknown']);

end

plot([0 x],yi,lineopt);


