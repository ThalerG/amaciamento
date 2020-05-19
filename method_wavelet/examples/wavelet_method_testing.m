%% Setup

J = 9; % Number of levels for discrete wavelet analysis
wname = 'sym4'; % Wavelet for dwt

% w = ?; % Standard deviation of the wavelet modulus of historic measurements
lambda1 = 1; % Adjustable parameter around 1.0 determined according to measurement variability and required operation sensitivity
T1 = 3*lambda1*w; % Threshold for abnormality identification
T2 = w; % Threshold for identification of the abnormality duration
% tp = ?; % General duration of temporal spikes in measurements


load('D:\Documentos\Amaciamento\Ferramentas\cRMS_am1_test.mat');

tcRMS = cRMS.t;
cRMS = cRMS.data;

tk = 240; % Sample for steady-state detection
Dk = 128; % Sample window for wavelet transform

x = cRMS(tk+1-Dk:tk);

%% dwt decomposition

[coef,lcoef] = wavedec(x,J,wname);

Wc = coef(1:lcoef(1));
Wd = detcoef(coef,lcoef,1:J,'cells');

%% Thresholding and abnormality detection

delta_1 = mean(abs(Wd{1}));

for j = 1:J
    delta_j = delta_1*2^(-(j-1)/2);
    
    Wd{j}(abs(Wd{j})<=delta_j) = 0;
    Wd{j}(abs(Wd{j})>delta_j) = sign(Wd{j}(abs(Wd{j})>delta_j)).*(abs(Wd{j}(abs(Wd{j})>delta_j))-delta_j);
    
    if j == 2
        
        % Abnormality detection
        % ??????
        
    end
    
end

Wd = flip(Wd);
coefR = [Wc; vertcat(Wd{:})]';

f0R = appcoef(coefR,lcoef,wname,0);

figure;
plot(x); hold on;
plot(f0R); hold off;
