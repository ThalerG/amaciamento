function [n,ta] = runin_detect_spacedDif(x,t,w,n,r,s,f)
%  runin_detect_spacedDif indicates the SST using a spaced difference test
%
%   [n,ta] = runin_detect_singleavg(x,t,w,r,s,f): Estimates the steady
%   state transition (SST) by executing a difference test over the x data, 
%   with moving average filter applied the x data with window length w.
%   The SST is assumed when the difference is smaller than s for at least r samples, 
%   with tolerance of f samples with different result. The t input is the 
%   time vector  corresponding to the data vector x.
%
%   The outputs n and ta are, respectively, the index and instant
%   of the detected SST.
%
%   Recommended values for run-in detection:
%       w = 25
%       n = 30
%       r = 31
%       s = 7e-4
%       f = 0
%       -> Squared error for samples 1-5 = 60.16
%
%   See also spacedDiff

L = length(t);

der = spacedDiff(x(t>0),w,n); % Spaced difference between filtered values
t = t(t>0);
L = L-length(t); % Number of samples before the starting time t=0

count = 0;
flag = 0;

for k = 1:length(der)
    if abs(der(k))<s
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

if count<=r  % No steady state detected
    n = NaN;
    ta = NaN;
end
    
    