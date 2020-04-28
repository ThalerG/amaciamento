function d2 = doubleAvgDerivative(x,w1,w2)
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


d = zeros(1,length(x));
d2 = zeros(1,length(x));

for k = 2:length(x)
    
    if k<(2*w1) % Reduces window length for first 2*w1 samples
        wt = floor(k/2);
        d(k) = mean(x((k-wt+1):k))-mean(x((k-2*wt+1):(k-wt)));
    else
        d(k) = mean(x((k-w1+1):k))-mean(x((k-2*w1+1):(k-w1)));
    end
    
    if k<w2 % Reduces window length for first w2 samples
        d2(k) = mean(d(1:k));
    else
        d2(k) = mean(d((k-w2+1):k));
    end
end