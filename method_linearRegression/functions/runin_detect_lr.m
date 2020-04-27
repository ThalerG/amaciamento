function [n,ta] = runin_detect_lr(x,t,w,r,s,f)
%  runin_detect_lr indicates the run-in instant through t-test
%   
%
%   Recommended values
%       w = 35
%       r = 28
%       s = 0.1
%       f = 0
%
%   See also lrPValue

L = length(t);

pval = lrPValue(x(t>0),w);
t = t(t>0);
L = L-length(t); % Discarded elements

count = 0;
flag = 0;

for k = 1:length(pval)
    if pval(k)>s
        count = count+1;
    else
        if flag<f
            flag = flag+1;
        else
            flag = 0;
            count = 0;
        end
    end
    
    if count>=r
        n = k+L;
        ta = t(k);
        return
    end
end

if count<r
    n = NaN;
    ta = NaN;
end

end
    
    