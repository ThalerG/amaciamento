function [n,ta] = runin_detect_wav(x,t,w,n,r,s,f)
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
