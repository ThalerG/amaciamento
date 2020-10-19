%% Parameter analysis for run-in detection using linear regression

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
% rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

% Create new folder for generated files
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\rStatistics_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
% fsave = [rt 'Resultados\rStatistics_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
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
       
L1 = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5]; % lambda1 values (Exponential average weight for data)
L23 = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5]; % lambda2 and lambda3 values (Exponential average weights for variance)
ALPHA = [0.01 0.05 0.1 0.25 0.5]; % Significance level

wMax = 2; % Duração máxima da janela [h];
minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)

lenL1 = length(L1);
lenL23 = length(L23);
lenALPHA = length(ALPHA);

r.TPR = nan(1,lenALPHA); r.FPR = nan(1,lenALPHA); r.CMat = repmat({[NaN,NaN;NaN,NaN]},lenALPHA,1);
Res = repmat(r,lenL1,lenL23);

T = load('criticalR.mat','T'); % Loads the critical R values table (T);
T = T.T;

%% Sample processing

numIt = lenL1*lenL23;
ppm = ParforProgressbar(numIt); % Barra de progresso do parfor

parfor l1 = 1:lenL1
    for l23 = 1:lenL23
        classAmac = [];
        RTot = [];

        for k1 = 1:length(EnData)
            for k2 = 1:length(EnData{k1})
                [Ren,tempo] = Rstats_ratio(EnData{k1}(k2).cRMS(EnData{k1}(k2).tempo>0),L1(l1),L23(l23),L23(l23),tEst{k1}(k2), minT,EnData{k1}(k2).tempo(EnData{k1}(k2).tempo>0)); % R-stats per instant
                Ren = Ren';
                classTemp = strings(length(Ren(:,1)),1);
                classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
                classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
                RTot = [RTot;Ren];
                classAmac = [classAmac;classTemp];
            end
        end
        
        classAmac = classAmac == 'amaciado';
        
        for alpha = 1:lenALPHA
            Rc = T(T(:,1)==L1(l1) & T(:,2)==L23(l23) & T(:,3)==L23(l23) & T(:,4)==ALPHA(alpha),5);
            
            gtest = RTot<=Rc;
            cMat = confusionmat(classAmac,gtest);

            Res(l1,l23).CMat{alpha} = cMat;
            Res(l1,l23).TPR(alpha) = cMat(1,1)/sum(cMat(:,1));
            Res(l1,l23).FPR(alpha) = cMat(1,2)/sum(cMat(:,2));
        end
        
        ppm.increment();
    end
end

delete(ppm);

save([fsave,'Results.mat'],'Res','L1','L23','ALPHA','tEst','EnData','conjVal');

figure;

p = plot(Res(1,1).FPR,Res(1,1).TPR); xlim([0 1]); ylim([0 1]);
row = dataTipTextRow('Alpha',ALPHA);
p.DataTipTemplate.DataTipRows(end+1) = row;
ylabel('True Positive Rate TP/(TP+FN)');
xlabel('False Positive Rate FP/(FP+TN)');