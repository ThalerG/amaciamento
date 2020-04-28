function [n,ta] = runin_detect_lr(x,t,w,r,s,f)
%  runin_detect_lr indicates the STT instant using t-test
%
%   [n,ta] = runin_detect_lr(x,t,w,r,s,f): Estimates the steady state
%   transition (STT) by executing a linear regression and t-test over 
%   the last w samples with significance level s. The STT is 
%   assumed when this test result persist over at least r samples, with
%   tolerance of f samples with different result. The t input is the time
%   vector corresponding to the data vector x.
%
%   The outputs n and ta are, respectively, the index and instant
%   of the detected STT.
%
%   Recommended values for run-in detection:
%       w = 60
%       r = 83
%       s = 0.05
%       f = 0
%
%   See also lrPValue

L = length(t);

pval = lrPValue(x(t>0),w); % p-values for every sample
t = t(t>0);
L = L-length(t); % Number of samples before the starting time t=0

count = 0;
flag = 0;

for k = 1:length(pval)
    if pval(k)>s % p-value greater than significance level accepts null hypothesis (slope = 0)
        count = count+1;
    else
        if flag<f
            flag = flag+1;
        else
            flag = 0;
            count = 0;
        end
    end
    
    if count>=r % Algorithm stops when steady state is detected
        n = k+L;
        ta = t(k);
        return
    end
end

if count<r % No steady state detected
    n = NaN;
    ta = NaN;
end

end
    
    