%% Parameter analysis for run-in detection using filtered difference

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
% rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

fpr = [rt 'Dados Processados\']; % General rocessed data folder (see documentation for data format)

% Create new folder for generated files
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\spacedDif_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
% fsave = [rt 'Resultados\spacedDif_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;

% fsm: Test data folder 
% tEst: Manually inputed estimated run-in time

load('EnDataA.mat');

conjVal = [2,1;4,2;5,3]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]

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

       
for k1 = 1:size(conjVal,1) % Apaga os valores dos conjuntos de validação
    tEst{conjVal(k1,1)}(conjVal(k1,2)) = [];
    EnData{conjVal(k1,1)}(conjVal(k1,2)) = [];
end      

W1 = [1,5:5:120]; % Sample window for the data filter
N = [1:60,65:5:120];
W2 = [1,5:5:130]; % Sample window for the difference filter
S = 1e-4:1e-4:5e-2; % Maximum tolerated difference

wMax = 2; % Duração máxima da janela [h];
minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)

lenW1 = length(W1);
lenW2 = length(W2);
lenN = length(N);
lenS = length(S);

r.TPR = nan(1,lenS); r.FPR = nan(1,lenS); r.CMat = repmat({[NaN,NaN;NaN,NaN]},lenS,1);
Res = repmat(r,lenW1,lenN,lenW2);

%% Sample processing

numIt = nnz((lenN/60)<=wMax)*lenW1*lenW2;
ppm = ParforProgressbar(numIt); % Barra de progresso do parfor

parfor w1 = 1:lenW1
    for w2 = 1:lenW2
        for n = 1:lenN
            classAmac = [];
            d2Tot = [];
            if (N(n)/60)>wMax
                continue
            end

            for k1 = 1:length(EnData)
                for k2 = 1:length(EnData{k1})
                    [d2, tempo] = spacedDiff(EnData{k1}(k2).cRMS(EnData{k1}(k2).tempo>0),W1(w1),N(n),W2(w2),EnData{k1}(k2).tempo(EnData{k1}(k2).tempo>0), tEst{k1}(k2), minT);
                    classTemp = strings(length(d2(:,1)),1);
                    classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
                    classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
                    d2Tot = [d2Tot;d2];
                    classAmac = [classAmac;classTemp];
                end
            end

            classAmac = classAmac == 'amaciado';

            for s = 1:lenS
                gtest = d2Tot<=S(s);
                cMat = confusionmat(classAmac,gtest);

                Res(w1,n,w2).CMat{s} = cMat;
                Res(w1,n,w2).TPR(s) = cMat(1,1)/sum(cMat(:,1));
                Res(w1,n,w2).FPR(s) = cMat(1,2)/sum(cMat(:,2));
            end

            ppm.increment();
        end
    end
end

delete(ppm);

save([fsave,'Results.mat'],'Res','W1','N', 'W2','S','tEst','EnData','conjVal');

figure;

p = plot(Res(1,1,1).FPR,Res(1,1,1).TPR); xlim([0 1]); ylim([0 1]);
row = dataTipTextRow('S',S);
p.DataTipTemplate.DataTipRows(end+1) = row;
ylabel('True Positive Rate TP/(TP+FN)');
xlabel('False Positive Rate FP/(FP+TN)');
