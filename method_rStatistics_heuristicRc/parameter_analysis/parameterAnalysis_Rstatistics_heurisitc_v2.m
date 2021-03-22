%% Parameter analysis for run-in detection using linear regression

clear; close all; clc;

% rt = 'D:\Documentos\Amaciamento\'; % Root folder
rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

% Create new folder for generated files
c = clock;
% fsave = [rt 'Ferramentas\Arquivos Gerados\rStatisticsH_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
fsave = [rt 'Resultados\rStatisticsH_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
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

       
for k1 = 1:size(conjVal,1) % Apaga os valores dos conjuntos de validação
    tEst{conjVal(k1,1)}(conjVal(k1,2)) = [];
    EnData{conjVal(k1,1)}(conjVal(k1,2)) = [];
end      
       
L1 = 0.02:0.02:0.8; % lambda1 values (Exponential average weight for data)
L2 = 0.05:0.05:0.8; % lambda2 values (Exponential average weight for variance numerator)
L3 = 0.01:0.01:0.8; % lambda3 values (Exponential average weight for variance denominator)
Rc = 0.5:0.01:4; % Critical R value

wMax = 2; % Duração máxima da janela [h];
minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)

lenL1 = length(L1);
lenL2 = length(L2);
lenL3 = length(L3);
lenRc = length(Rc);

r.TPR = nan(1,lenRc); r.FPR = nan(1,lenRc); % CMat = repmat({[NaN,NaN;NaN,NaN]},lenL1,lenL2,lenL3,lenRc);
Res = repmat(r,lenL1,lenL2,lenL3);

%% Sample processing

numIt = lenL1*lenL2*lenL3;
ppm = ParforProgressbar(numIt); % Barra de progresso do parfor

parfor l1 = 1:lenL1
    for l2 = 1:lenL2
        for l3 = 1:lenL3
            classAmac = [];
            RTot = [];

            for k1 = 1:length(EnData)
                for k2 = 1:length(EnData{k1})
                    [Ren,tempo] = Rstats_ratio_gridSearch(EnData{k1}(k2).cRMS(EnData{k1}(k2).tempo>0),L1(l1),L2(l2),L3(l3),tEst{k1}(k2), minT,EnData{k1}(k2).tempo(EnData{k1}(k2).tempo>0)); % R-stats per instant
                    Ren = Ren';
                    classTemp = strings(length(Ren(:,1)),1);
                    classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
                    classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
                    RTot = [RTot;Ren];
                    classAmac = [classAmac;classTemp];
                end
            end

            classAmac = classAmac == 'amaciado';

            for r = 1:lenRc
                gtest = RTot<=Rc(r);
                cMat = confusionmat(classAmac,gtest);

                % CMat{l1,l2,l3,r} = cMat;
                Res(l1,l2,l3).TPR(r) = cMat(1,1)/sum(cMat(:,1));
                Res(l1,l2,l3).FPR(r) = cMat(1,2)/sum(cMat(:,2));
            end

            ppm.increment();
        end
    end
end

delete(ppm);

save([fsave,'Results.mat'],'Res','L1','L2','L3','Rc','tEst','EnData','conjVal');
% save([fsave,'cMat.mat'],'CMat','-v7.3');

figure;

p = plot(Res(1,1,1).FPR,Res(1,1,1).TPR); xlim([0 1]); ylim([0 1]);
row = dataTipTextRow('Rc',Rc);
p.DataTipTemplate.DataTipRows(end+1) = row;
ylabel('True Positive Rate TP/(TP+FN)');
xlabel('False Positive Rate FP/(FP+TN)');