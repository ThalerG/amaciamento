function [n,ta] = runin_detect_doubleavg(x,t,w1,w2,d_f_lim,r,f)
%  runin_detect_singleavg indicates the STT using a filtered derivative test
%
%   [n,ta] = runin_detect_singleavg(x,t,w,d_f_lim,r,f): Estimates the steady
%   state transition (STT) by executing a difference test over the x data, 
%   with moving average filter applied both to the x data and difference 
%   (w1 and w2 window length, respectively). The STT is assumed 
%   when the filtered difference is smaller than d_f_lim for at least r samples, 
%   with tolerance of f samples with different result. The t input is the 
%   time vector  corresponding to the data vector x.
%
%   The outputs n and ta are, respectively, the index and instant
%   of the detected STT.
%
%   Recommended values for run-in detection:
%       w1 = 30
%       w2 = 1
%       r = 32
%       d_f_lim = 7e-4
%       f = 0
%       -> Squared error for samples 1-5 = 60.42
%
%   See also doubleAvgDerivative

L = length(t);

der = doubleAvgDerivative(x(t>0),w1,w2); % Filtered difference between filtered values
t = t(t>0);
L = L-length(t); % Number of samples before the starting time t=0

count = 0;
flag = 0;

for k = 1:length(der)
    if abs(der(k))<d_f_lim
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
    
    