function d = wavSSI(x,w,n)
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
