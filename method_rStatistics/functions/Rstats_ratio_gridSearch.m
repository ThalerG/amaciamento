function [R,varargout] = Rstats_ratio_gridSearch(x,lambda1,lambda2,lambda3,tEst,minT,t)
% Rstats_ratio Returns the ratio of variances required for the R-statistics
%   This method uses exponentially weighted average and variances to reduce
%   computational effort.
%   lambda1: filter factor of the data
%   lambda2: filter factor of the difference between the data and the
%   average
%   lambda3: filter factor of the difference between sequential data
%

if nargin>4
    if tEst > minT
        L = length(nonzeros(t<=tEst));
        t = t(1:2*L);
        x = x(1:2*L);
    else
        t = t(t<minT);
        x = x(t<minT);
    end
end

xf = zeros(1,length(x)); % Weighted average data
v = zeros(1,length(x)); % Filtered difference between averaged and original data
d = zeros(1,length(x)); % Filtered difference between sequential data
R = zeros(1,length(x)); % Ratio of variances

xf(1) = x(1); v(1) = 0; d(1) = 0; R(1) = 0;

for k = 2:length(x)
    xf(k) = lambda1*x(k)+(1-lambda1)*xf(k-1);
    v(k) = lambda2*(x(k)-xf(k-1))^2+(1-lambda2)*v(k-1);
    d(k) = lambda3*(x(k)-x(k-1))^2+(1-lambda3)*d(k-1);
    R(k) = (2-lambda1)*v(k)/d(k);
end

if nargout == 2
    varargout{1} = t;
end

end

