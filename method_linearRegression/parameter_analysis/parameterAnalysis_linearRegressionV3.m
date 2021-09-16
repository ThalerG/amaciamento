%% Parameter analysis for run-in detection using linear regression

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
% rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

% Create new folder for generated files
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\linRegressionA' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;

% fsm: Test data folder 
% tEst: Manually inputed estimated run-in time

load('EnDataA_Dissertacao.mat');

% Tempo mínimo e máximo para avaliação dos ensaios
tempoMin = 1;
tempoMaxA = 20;
tempoMaxB = 40;

cortaEnsaios;

EnData = EnDataA; 

clear EnDataA;

% Tempos de amaciamento esperados:

loadTempoAmacAPopular

N = 2:100; % Sample window for linear regression
M = [1, 5, 10:10:180]; % Janela da média móvel
D = [1:2:5, 10:10:90, 100:20:180]; % Distância entre amostras da regressão

ALPHA = 0:0.001:1; % Significance level

vars = {'cRMS', 'cKur', 'cVar', 'vaz'}; % Variáveis utilizadas

wMax = 3.02; % Duração máxima da janela [h];
minT = Inf; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)

lenN = length(N);
lenM = length(M);
lenD = length(D);
lenV = length(vars);
lenALPHA = length(ALPHA);

r.TPR = nan(1,length(ALPHA)); r.FPR = nan(1,length(ALPHA));  CMat = repmat({[NaN,NaN;NaN,NaN]},lenN,lenM,lenD,lenALPHA,lenV);
Res = repmat(r,lenN,lenM,lenD,lenV);

%% Sample processing

numIt = nnz(((N-1)'.*D/60)<=wMax)*length(M);
ppm = ParforProgressbar(numIt); % Barra de progresso do parfor

parfor n = 1:lenN
% for n = 1:lenN
    for d = 1:lenD
        for m = 1:lenM
            
            if ((N(n)-1)*D(d)/60)>wMax
                continue
            end
            for v = 1:lenV
                if numel(conjVal) == 1
                   [Ttrain,Xtrain,Ytrain,Xtest,Ytest,indTest{n,m,d}] = preproc_data(EnData,tEst,conjVal,N(n),M(m),D(d),Inf,vars,paramOvers,standardize);
                else
                   [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N(n),M(m),D(d),Inf,vars,paramOvers,standardize);
                end

                for alpha = 1:lenALPHA
                    gtest = pVal>=ALPHA(alpha);
                    cMat = confusionmat(Y,gtest);
                    CMat{n,m,d,alpha,v} = cMat;
                    Res(n,m,d,v).TPR(alpha) = cMat(1,1)/sum(cMat(:,1));
                    Res(n,m,d,v).FPR(alpha) = cMat(1,2)/sum(cMat(:,2));
                end
            end
            ppm.increment();
        end
    end
end

delete(ppm);

save([fsave,'Results.mat'],'Res','ALPHA','N','M','D','vars','tEst','EnData','conjVal');
save([fsave,'cMat.mat'],'CMat','-v7.3');

figure;

p = plot(Res(1,1,1,1).FPR,Res(1,1,1,1).TPR); xlim([0 1]); ylim([0 1]);
row = dataTipTextRow('Alpha',ALPHA);
p.DataTipTemplate.DataTipRows(end+1) = row;
ylabel('True Positive Rate TP/(TP+FN)');
xlabel('False Positive Rate FP/(FP+TN)');