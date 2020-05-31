function [n,ta] = runin_detect_Rstats_hRc(x,t,lambda1,lambda2,lambda3,Rc,r,f)
%  runin_detect_Rstats_hRc indicates the SST instant using R-statistics test
%
%   [n,ta] = runin_detect_Rstats(x,t,lambda1,lambda2,lambda3,alpha,r,f): 
%   Estimates the steady state transition (SST) using a R-statistics test.
%   This test checks if the ratio R of two variances is less than a
%   predetermined critical R value. lambda1, lamda2, and lambda3 are weight
%   parameters for the data and variances (0<lambda<=1), and Rc is the 
%   critical R value (SST -> R<=Rc). The SST is assumed when this test
%   result persist over at least r samples, with tolerance of f samples 
%   with different result. The t input is the time vector corresponding to 
%   the data vector x.
%
%   Recommended values for run-in detection:
%       lambda1 = 0.06
%       lambda2 = 0.75
%       lambda3 = 0.21
%       Rc = 1.35
%       r = 11
%       f = 0
%       -> Squared error for samples 1-5 = 43.59
%
%   See also Rstats_ratio

L = length(t);

Rstats = Rstats_ratio(x(t>0),lambda1,lambda2,lambda3); % p-values for every sample
t = t(t>0);
L = L-length(t); % Number of samples before the starting time t=0

count = 0;
flag = 0;

for k = 1:length(Rstats)
    if Rstats(k)<=Rc % If R-statistic is less than R-critical, the proccess may be at steady state
        count = count+1;
    else
        if flag<f
            flag = flag+1;
        else
            flag = 0;
            count = 0;
        end
    end
    
    if count>r % Algorithm stops when steady state is detected
        n = k+L;
        ta = t(k);
        return
    end
end

if count<=r % No steady state detected
    n = NaN;
    ta = NaN;
end

end
    
    