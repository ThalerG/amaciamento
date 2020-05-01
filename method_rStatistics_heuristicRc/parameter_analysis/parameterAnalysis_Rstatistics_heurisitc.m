%% Parameter analysis for run-in detection using R-statistics and unknown Rc

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
fpr = [rt 'Dados Processados\']; % General rocessed data folder (see documentation for data format)

% Create new folder for generated files
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\rStatistics_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d')];
mkdir(fsave); clear rt c;

% fsm: Test data folder 
% tEst: Manually inputed estimated run-in time

fsm{1} = {'Amostra 1\N_2019-07-01\'};

tEst{1} = 7;

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
      
tEst{4} = [8;
           2;
           2;
           2];

fsm{5} = {'Amostra 5\N_2020-01-22\';
          'Amostra 5\A_2020-01-27\';
          'Amostra 5\A_2020-01-28\'};

tEst{5} = [13;
           2;
           2];      

       
path = cell(length(fsm),1); % Cell array for the data file path
tAmac = cell(length(fsm),1); % Cell array for the run-in instant

L1 = 0.02:0.02:0.5; % lambda1 values (Exponential average weight for data)
L2 = 0.05:0.05:0.5; % lambda2 values (Exponential average weight for variance numerator)
L3 = 0.01:0.01:0.5; % lambda3 values (Exponential average weight for variance denominator)
Rc = 0.5:0.05:3; % Critical R value
R = 1:1:60; % Sample relevance
F = 0; % Sample tolerance

for k1 = 1:length(fsm)
    path{k1} = strcat(fpr,fsm{k1},'corrente_RMS.mat');
    tAmac{k1} = cell(length(fsm{k1}),1);
    for k2 = 1:length(fsm{k1})
        tAmac{k1}{k2} = zeros(length(L1),length(L2),length(L3),length(Rc),length(R),length(F));
    end
end

T = load('criticalR.mat','T'); % Loads the critical R values table (T);
T = T.T;

%% Sample processing

totalIt = 0; % Number of iterations
for k1 = 1:length(path)
    totalIt = totalIt+length(path{k1});
end
totalIt = totalIt*length(L1)*length(L2);

it = 0;

for k1 = 1:length(path) % For every sample
    for k2 = 1:length(path{k1}) % For every test of the sample
        load(path{k1}{k2}); % Loads the RMS current data
        count = zeros(length(cRMS.data(cRMS.t>0)),1); % Counts the number of samples where the null hypothesis is valid
        time = cRMS.t(cRMS.t>0);
        
        for l1 = 1:length(L1) % For every lambda1 value
            for l2 = 1:length(L2) % For every lambda2 value
                
                it=it+1;
                prog = ['Progresso:' num2str(100*it/totalIt),'%' newline...
                        'Amostra:' num2str(k1) '/' num2str(length(path)) newline...
                        'Ensaio:' num2str(k2) '/' num2str(length(path{k1})) newline...
                        'l1 :' num2str(l1) '/' num2str(length(L1)) newline...
                        'l2 :' num2str(l2) '/' num2str(length(L2))]; display(prog); % Displays the current progress

                for l3 = 1:length(L3) % For every lambda3 value
                    dataF = Rstats_ratio(cRMS.data(cRMS.t>0),L1(l1),L2(l2),L3(l3)); % R-stats per instant

                    flag = 0;

                    for rc = 1:length(Rc) % For every significance level
                        for f = 1:length(F)
                            for n = 2:length(dataF) % Counts the number of samples where the null hypothesis (H0: slope = 0) can be accepted 
                                if dataF(n)<=Rc(rc)
                                    count(n) = count(n-1)+1;
                                else
                                    if flag<F(f)
                                        flag = flag+1;
                                    else
                                        flag = 0;
                                        count(n) = 0;
                                    end
                                end
                            end
                            for r = 1:length(R)
                                temp = min(time(count>R(r)));
                                if isempty(temp)
                                    tAmac{k1}{k2}(l1,l2,l3,rc,r:end,f) = NaN;
                                    break
                                else
                                    tAmac{k1}{k2}(l1,l2,l3,rc,r,f) = temp;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

save([fsave,'tAmac.mat'],'fsm','tAmac','-v7.3');
save([fsave,'parameters.mat'],'L1','L2','L3','Rc','R','F','-v7.3');

clear count time fsm

%% Difference between the estimated and detected run-in instant

dif = cell(length(tAmac),1);

for k1 = 1:length(dif)
    dif{k1} = cell(length(tAmac{k1}),1);
    for k2 = 1:length(tAmac{k1})
        dif{k1}{k2} = tAmac{k1}{k2}-tEst{k1}(k2);
    end
end

clear tAmac

save([fsave,'dif.mat'],'dif','tEst','-v7.3');

%% Cost function (quadratic error)

J = zeros(length(L1),length(L2),length(L3),length(Rc),length(R),length(F));

for k1 = 1:length(dif)
    for k2 = 1:length(dif{k1})
        J = J+dif{k1}{k2}.^2;
    end
end

J(isnan(J)) = inf;

save([fsave,'J.mat'],'J','tEst','-v7.3');

[minval, minidx] = min(abs(J(:)));
[m, n, o, p, q, r] = ind2sub( size(J), minidx);
l1min = L1(m)
l2min = L2(n)
l3min = L3(o)
Rcmin = Rc(p)
rmin = R(q)
fmin = F(r)
J(m,n,o,p,q,r)