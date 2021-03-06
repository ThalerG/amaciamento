%% Parameter analysis for run-in detection using wavelets

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
fpr = [rt 'Dados Processados\']; % General rocessed data folder (see documentation for data format)

% Create new folder for generated files
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\wavelet_parameters_' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;

% fsm: Test data folder 
% tEst: Manually inputed estimated run-in time

fsm{1} = {'Amostra 1\N_2019-07-01\'};

tEst{1} = 4;

fsm{2} = {'Amostra 2\N_2019-07-09\';
          'Amostra 2\A_2019-08-08\';
          'Amostra 2\A_2019-08-12\';
          'Amostra 2\A_2019-08-28\'};

tEst{2} = [7;
           2;
           2;
           2];

fsm{3} = {'Amostra 3\N_2019-12-04\';
          'Amostra 3\A_2019-12-09\';
          'Amostra 3\A_2019-12-11\'};

tEst{3} = [12;
           2;
           2];
       
      
fsm{4} = {'Amostra 4\N_2019-12-16\';
          'Amostra 4\A_2019-12-19\';
          'Amostra 4\A_2020-01-06\';
          'Amostra 4\A_2020-01-13\'};
      
tEst{4} = [5.5;
           2;
           2;
           2];

fsm{5} = {'Amostra 5\N_2020-01-22\';
          'Amostra 5\A_2020-01-27\';
          'Amostra 5\A_2020-01-28\'};

tEst{5} = [12.5;
           2;
           2];         
      
path = cell(length(fsm),1); % Cell array for the data file path
tAmac = cell(length(fsm),1); % Cell array for the run-in instant

R = 1:70; % Sample relevance
W = [1,5:5:50]; % Sample window for the data filter
N = [1,5:5:100]; % Space between differenced samples
S = 1e-4:1e-4:5e-2; % Maximum tolerated difference
F = 0:5; % Sample tolerance

for k1 = 1:length(fsm)
    path{k1} = strcat(fpr,fsm{k1},'corrente_RMS.mat');
    tAmac{k1} = cell(length(fsm{k1}),1);
    for k2 = 1:length(fsm{k1})
        tAmac{k1}{k2} = zeros(length(W),length(N),length(R),length(S),length(F));
    end
end


%% Sample processing

totalIt = 0; % Number of iterations
for k1 = 1:length(path)
    totalIt = totalIt+length(path{k1});
end
totalIt = totalIt*length(W)*length(N);

it = 0;

for k1 = 1:length(path) % For every sample
    for k2 = 1:length(path{k1}) % For every test of the sample
        load(path{k1}{k2}); % Loads the RMS current data
        count = zeros(length(cRMS.data(cRMS.t>0)),1); % Counts the number of samples where the null hypothesis is valid
        time = cRMS.t(cRMS.t>0);
        for w = 1:length(W) % For every window length size
            for n = 1:length(N)  % For every window length size
                it=it+1;
                prog = ['Progresso:' num2str(100*it/totalIt),'%' newline...
                        'Amostra:' num2str(k1) '/' num2str(length(path)) newline...
                        'Ensaio:' num2str(k2) '/' num2str(length(path{k1})) newline...
                        'w :' num2str(w) '/' num2str(length(W)) newline...
                        'n :' num2str(n) '/' num2str(length(N))]; display(prog); % Displays the current progress

                for s = 1:length(S)  % For every maximum tolerance
                    
                    dataF = spacedDiff(cRMS.data(cRMS.t>0),W(w),N(n));

                    flag = 0;
                    for f = 1:length(F)
                        for m = 2:length(dataF) % Counts the number of samples where the difference is smaller than the tolerated value
                            if abs(dataF(m))<S(s)
                                count(m) = count(m-1)+1;
                            else
                                if flag<F(f)
                                    flag = flag+1;
                                else
                                    flag = 0;
                                    count(m) = 0;
                                end
                            end
                        end
                        for r = 1:length(R)
                            temp = min(time(count>R(r)));
                            if isempty(temp)
                                tAmac{k1}{k2}(w,n,r:end,s,f) = NaN;
                                break
                            else
                                tAmac{k1}{k2}(w,n,r,s,f) = temp;
                            end
                        end
                    end
                end
            end
        end
    end
end

save([fsave,'tAmac.mat'],'fsm','tAmac','-v7.3');
save([fsave,'parameters.mat'],'W','N','R','S','F','-v7.3');

clear count time fsm

%% Difference between the estimated and detected run-in instant

dif = cell(length(tAmac),1);
for k1 = 1:length(dif)
    dif{k1} = cell(length(tAmac{k1}),1);
    for k2 = 1:length(tAmac{k1})
        dif{k1}{k2} = tAmac{k1}{k2}-tEst{k1}(k2);
        tAmac{k1}{k2} = []; % Frees memory
    end
    tAmac{k1} = [];
end

clear tAmac

save([fsave,'dif.mat'],'dif','tEst','-v7.3');

%% Cost function (quadratic error)

J = zeros(length(W),length(N),length(R),length(S),length(F));

for k1 = 1:length(dif)
    for k2 = 1:length(dif{k1})
        J = J+dif{k1}{k2}.^2;
    end
end

save([fsave,'J.mat'],'J','tEst','-v7.3');

[minval, minidx] = min(abs(J(:)));
[m, n, o, p, q] = ind2sub( size(J), minidx);
wmin = W(m)
nmin = N(n)
rmin = R(o)
smin = S(p)
fmin = F(q)
J(m,n,o,p,q)