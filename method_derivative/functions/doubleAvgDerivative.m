function [d2, varargout] = doubleAvgDerivative(x,w1,w2,t,tEst,minT)
% doubleAvgDerivative Filtered derivative of filtered x
%
%   d = doubleAvgDerivative(x,w1,w2): For every x(k) element of the x data
%   vector, this function returns a d2(k) value equivalent to the filtered 
%   difference between two samples x'(k) and x'(k-w), where x'(k) is the 
%   filtered value of x obtained using a moving average filter with window
%   length w1. The derivative filter is also a moving average one, but with
%   window length w2.
%
%   This operation is demonstrated considering the x data vector:
%   x = x(1) x(2) ...  x(k-2w1+1) ... x(k-w1) x(k-w1+1) ... x(k-1) x(k)
%                      |_________M1_________| |__________M2___________|                     
%                                d(k) = M2 - M1, where M1 and M2
%                                          are average operations.
%                                   d2(k) = d(k-w2+1:k)/w2
% 
%   If k<2w, the windows length w is reduced to the maximum possible length
%   (w = floor(k/2)). The same goes for k values smaller than the window 
%   length w2.

d = movmean(x,[w1-1,0]);
d = d(w1+1:end)-d(1:(end-w1));

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

end