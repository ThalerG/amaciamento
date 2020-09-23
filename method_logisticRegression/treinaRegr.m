clear; close all;

load('dados_ensaios.mat');

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
       
N = 24; % Janela (número de amostras) da regressão
M = 50; % Janela da média móvel
D = 1; % Distância entre amostras da regressão
extra = 0; % Valor adicionado ao tempo de amaciamento para deixar mais conservador
minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)
thr = 0:0.001:1;

Res.TPR = nan(1,length(thr)); Res.FPR = nan(1,length(thr)); Res.conf = nan(length(thr),2,2);
thrTPR = 0.05;

classAmac = [];
classCor = [];

for k1 = 1:length(EnData)

    for k2 = 1:length(EnData{k1})
        temp = [];
        [temp(:,1:N),~] = mkTrainData(EnData{k1}(k2).cRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*1+1:N*2),~] = mkTrainData(EnData{k1}(k2).cKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*2+1:N*3),~] = mkTrainData(EnData{k1}(k2).vInfRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*3+1:N*4),~] = mkTrainData(EnData{k1}(k2).vInfKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*4+1:N*5),~] = mkTrainData(EnData{k1}(k2).vSupRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*5+1:N*6),~] = mkTrainData(EnData{k1}(k2).vSupKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*6+1:N*7),tempo] = mkTrainData(EnData{k1}(k2).vaz,EnData{k1}(k2).tempo,N,1,D,tEst{k1}(k2), minT);
        classTemp = strings(length(temp(:,1)),1);
        classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
        classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
    end

    classCor = [classCor;temp];
    classAmac = [classAmac;classTemp];
end
classAmac = categorical(classAmac);
[B,dev,stats] = mnrfit(classCor,classAmac);
prob = mnrval(B,classCor);
prob = prob(:,1);
classAmac = classAmac == 'amaciado';

for k = 1:length(thr)
    gtest = prob>=thr(k);
    cMat = confusionmat(classAmac,gtest);
    Res.conf(k,:,:) = cMat;
    Res.TPR(k) = cMat(1,1)/sum(cMat(:,1));
    Res.FPR(k) = cMat(1,2)/sum(cMat(:,2));
end
maxTPR = max(Res.TPR(Res.FPR<thrTPR));


%%

figure;
p = plot(Res.FPR,Res.TPR); xlim([0 1]); ylim([0 1]);
row = dataTipTextRow('Thr',thr);
p.DataTipTemplate.DataTipRows(end+1) = row;
ylabel('True Positive Rate TP/(TP+FN)');
xlabel('False Positive Rate FP/(FP+TN)');