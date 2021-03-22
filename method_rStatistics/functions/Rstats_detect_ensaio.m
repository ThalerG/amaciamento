function [amaciado,varargout] = Rstats_detect_ensaio(x,lambda1,lambda2,lambda3,Rc)
% Rstats_detect_ensaio Returns the ratio of variances required for the R-statistics
%   This method uses exponentially weighted average and variances to reduce
%   computational effort.
%   lambda1: filter factor of the data
%   lambda2: filter factor of the difference between the data and the
%   average
%   lambda3: filter factor of the difference between sequential data
%

xf = zeros(1,length(x)); % Weighted average data
v = zeros(1,length(x)); % Filtered difference between averaged and original data
d = zeros(1,length(x)); % Filtered difference between sequential data
R = zeros(1,length(x)); % Ratio of variances

xf(1) = x(1); v(1) = 0; d(1) = 0; R(1) = 0;

for k = 2:length(x)
    [xf(k), v(k), d(k), R(k)] = next_R(x(k),x(k-1),xf(k-1),v(k-1),d(k-1),lambda1,lambda2,lambda3);
end

amaciado =  R<=Rc;

if nargout == 2
    varargout{1} = R;
end

end

