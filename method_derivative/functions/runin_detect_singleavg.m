function [n,ta] = runin_detect_singleavg(x,t,w,r,s,f)
%  runin_detect_singleavg indicates the STT using a derivative test
%
%   [n,ta] = runin_detect_singleavg(x,t,w,r,s,f): Estimates the steady
%   state transition (STT) by executing a difference test over the x data
%   filtered with a w window length. The STT is assumed when the
%   difference is smaller than s for at least r samples, with tolerance of
%   f samples with different result. The t input is the time vector 
%   corresponding to the data vector x.
%
%   The outputs n and ta are, respectively, the index and instant
%   of the detected STT.
%
%   Recommended values for run-in detection:
%       w = ? 
%       r = ?
%       s = ?
%       f = ?
%
%   See also singleAvgDerivative

L = length(t);

der = singleAvgDerivative(x(t>0),w); % Difference between filtered values
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
    
    if count>=r % Algorithm stops when steady state is detected
        n = k+L;
        ta = t(k);
        return
    end
end

if count<r  % No steady state detected
    n = NaN;
    ta = NaN;
end
    
    