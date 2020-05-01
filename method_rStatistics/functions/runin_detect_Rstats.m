function [n,ta] = runin_detect_Rstats(x,t,lambda1,lambda2,lambda3,alpha,r,f)
%  runin_detect_Rstats indicates the STT instant using R-statistics test
%
%   [n,ta] = runin_detect_Rstats(x,t,lambda1,lambda2,lambda3,alpha,r,f): 
%   Estimates the steady state transition (STT) using a R-statistics test.
%   This test checks if the ratio R of two variances is less than a
%   predetermined critical R value. lambda1, lamda2, and lambda3 are weight
%   parameters for the data and variances (0<lambda<=1), and alpha is the 
%   level of significance (0<alpha<1). The STT is assumed when this test
%   result persist over at least r samples, with tolerance of f samples 
%   with different result. The t input is the time vector corresponding to 
%   the data vector x.
%
%   Recommended values for run-in detection:
%       lambda1 = 0.1
%       lambda2 = 0.2
%       lambda3 = 0.2
%       alpha = 0.05
%       r = 62
%       f = 3
%       -> Squared error for samples 1-5 = 126.754
%
%   See also Rstats_ratio

L = length(t);

Rstats = Rstats_ratio(x(t>0),lambda1,lambda2,lambda3); % p-values for every sample
t = t(t>0);
L = L-length(t); % Number of samples before the starting time t=0

count = 0;
flag = 0;

T = load('criticalR.mat','T'); % Loads the critical R values table (T);
T = T.T;

Rc = T(T(:,1)==lambda1 & T(:,2)==lambda2 & T(:,3)==lambda3 & T(:,4)==alpha,5);
clear T;

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
    
    