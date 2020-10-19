function [d2,varargout] = spacedDiff(x,w1,n,w2,t,tEst,minT)
% spacedDiff DIfference between spaced samples of filtered x
%
%   d = spacedDiff(x,w,n): For every x(k) element of the x data
%   vector, this function returns a d(k) value equivalent to the difference
%   between two filtered x values, with a space of n samples in between.
%   The filter used is a moving average filter with window length w.
%               d(k) = mean(x((k-w+1):k))-mean(x((k-w-n+1):(k-w-n)));
%   
%   If k<(w+n), the windows length w is reduced to the maximum possible
%   length, mantaining spacing between means (w = k-n).

if nargin <= 3
    w2 = 1;
end


d = movmean(x,[w1-1,0]);
d = d(n+1:end)-d(1:(end-n));

d2 = movmean(d,[w2-1,0]);

if nargin > 3
    t = t(w1:length(x));
else
    t = w1:length(x);
end

if nargin > 4
    if tEst > minT
        L = length(nonzeros(t<=tEst));
        t = t(1:2*L);
        d2 = d2(1:2*L);
    else
        t = t(t<minT);
        d2 = d2(t<minT);
    end
end

if nargout == 2
    varargout{1} = t;
end
