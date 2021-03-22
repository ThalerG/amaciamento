%% Parameter analysis for run-in detection using linear regression

clear; close all; clc;

% rt = 'D:\Documentos\Amaciamento\'; % Root folder
rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

% Create new folder for generated files
c = clock;
% fsave = [rt 'Ferramentas\Arquivos Gerados\linRegression_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
fsave = [rt 'Resultados\linRegression_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;

% fsm: Test data folder 
% tEst: Manually inputed estimated run-in time

load('EnDataA.mat');

conjVal = [1,1;4,2;5,3]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]

% Tempos de amaciamento esperados:

tEst{1} = 4.4;

tEst{2} = [7.5;
           2.5;
           2.5;
           2.5];
       
tEst{3} = [11.8;
           2.5;
           2.5];
         
tEst{4} = [6;
           2.5;
           2.5;
           2.1];

tEst{5} = [12.5;
           2.5;
           2.5];

       

       
N = 2:100; % Sample window for linear regression
D = 1:100; % Sample window for linear regression
M = [1,5:5:120]; % Moving average filter window
ALPHA = 0:0.001:1; % Significance level

wMax = 2; % Duração máxima da janela [h];
minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)

lenN = length(N);
lenM = length(M);
lenD = length(D);
lenALPHA = length(ALPHA);

r.TPR = nan(1,length(ALPHA)); r.FPR = nan(1,length(ALPHA));  % CMat = repmat({[NaN,NaN;NaN,NaN]},lenN,lenM,lenD,lenALPHA,1);
Res = repmat(r,lenN,lenM,lenD);

%% Sample processing

numIt = nnz(((N-1)'.*D/60)<=wMax)*length(M);
ppm = ParforProgressbar(numIt); % Barra de progresso do parfor

parfor n = 1:lenN
    for d = 1:lenD
        for m = 1:lenM
            classAmac = [];
            classCor = [];
            if ((N(n)-1)*D(d)/60)>wMax
                continue
            end
            
            for k1 = 1:length(EnData)
                for k2 = 1:length(EnData{k1})
                    [cor,tempo] = mkTrainData_lr(EnData{k1}(k2).cRMS,EnData{k1}(k2).tempo,N(n),M(m),D(d),tEst{k1}(k2), minT);
                    
                    classTemp = strings(length(cor(:,1)),1);
                    classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
                    classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
                    classCor = [classCor;cor];
                    classAmac = [classAmac;classTemp];
                end
            end
            
            pVal = arrayfun(@(ROWIDX) lrPValue(classCor(ROWIDX,:)), (1:size(classCor,1)).');
            classAmac = classAmac == 'amaciado';
            
            for alpha = 1:lenALPHA
                gtest = pVal>=ALPHA(alpha);
                cMat = confusionmat(classAmac,gtest);
                % CMat{n,m,d,alpha} = cMat;
                Res(n,m,d).TPR(alpha) = cMat(1,1)/sum(cMat(:,1));
                Res(n,m,d).FPR(alpha) = cMat(1,2)/sum(cMat(:,2));
            end
            ppm.increment();
        end
    end
end

delete(ppm);

save([fsave,'Results.mat'],'Res','ALPHA','N','M','D','tEst','EnData','conjVal');
% save([fsave,'cMat.mat'],'CMat','-v7.3');

figure;

p = plot(Res(1,1,1).FPR,Res(1,1,1).TPR); xlim([0 1]); ylim([0 1]);
row = dataTipTextRow('Alpha',ALPHA);
p.DataTipTemplate.DataTipRows(end+1) = row;
ylabel('True Positive Rate TP/(TP+FN)');
xlabel('False Positive Rate FP/(FP+TN)');