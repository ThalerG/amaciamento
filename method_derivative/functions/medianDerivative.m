function d = medianDerivative(x,w)
% medianDerivative Derivative of filtered x
%
%   d = medianDerivative(x,w): For every x(k) element of the x data
%   vector, this function returns a d(k) value equivalent to the difference
%   between two samples x'(k) and x'(k-w), where x'(k) is the filtered
%   value of x obtained using a moving median filter with window length w.
%
%   This operation is demonstrated considering the x data vector:
%   x = x(1) x(2) ... x(k-2w) x(k-2w+1) ... x(k-w) x(k-w+1) ... x(k-1) x(k)
%                             |________M1________| |__________M2__________|                     
%                                          d(k) = M2 - M1, where M1 and M2
%                                                   are median operations.
%
%   If k<2w, the windows length w is reduced to the maximum possible length
%   (w = floor(k/2)).


d = zeros(1,length(x));

for k = 1:length(x)
    if k<(2*w) % Reduces window length for first 2*w samples
        wt = floor(k/2);
        d(k) = median(x((k-wt+1):k))-median(x((k-2*wt+1):(k-wt)));
    else
        d(k) = median(x((k-w+1):k))-median(x((k-2*w+1):(k-w)));
    end
end