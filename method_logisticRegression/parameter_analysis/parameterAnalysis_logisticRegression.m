clear; % close all;

load('EnData.mat');

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
       
N = 1:60; % Janela (número de amostras) da regressão
M = [1,5:5:90]; % Janela da média móvel
D = 1:60; % Distância entre amostras da regressão
extra = 0; % Valor adicionado ao tempo de amaciamento para deixar mais conservador [h]
minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)
wMax = 2; % Duração máxima da janela [h];
thr = 0:0.001:1;


lenN = length(N);
lenM = length(M);
lenD = length(D);
numIt = nnz(((N-1)'.*D/60)<wMax)*length(M);
ppm = ParforProgressbar(numIt); % Barra de progresso do parfor

r.TPR = nan(1,length(thr)); r.FPR = nan(1,length(thr)); % r.conf = nan(length(thr),2,2);
Res = repmat(r,lenN,lenM,lenD); % Matriz com struct contendo TPR e FPR de cada ajuste
maxTPR = nan(length(N),length(M),length(D)); % Maior TPR encontrado dentro do limite de TPR thrTPR
thrTPR = 0.05;

for n = 1:lenN
    for m = 1:lenM
        for d = 1:lenD
            classAmac = [];
            classCor = [];
            if ((N(n)-1)*D(d)/60)>wmax
                Res(n,m,d).TPR = nan(1,length(thr));
                Res(n,m,d).FPR = nan(1,length(thr));
                continue
            end
                
            for k1 = 1:length(EnData)
                
                for k2 = 1:length(EnData{k1})
                    temp = [];
                    [temp(:,1:N(n)),~] = mkTrainData(EnData{k1}(k2).cRMS,EnData{k1}(k2).tempo,N(n),M(m),D(d),tEst{k1}(k2), minT);
                    [temp(:,N(n)*1+1:N(n)*2),~] = mkTrainData(EnData{k1}(k2).cKur,EnData{k1}(k2).tempo,N(n),M(m),D(d),tEst{k1}(k2), minT);
                    [temp(:,N(n)*2+1:N(n)*3),~] = mkTrainData(EnData{k1}(k2).vInfRMS,EnData{k1}(k2).tempo,N(n),M(m),D(d),tEst{k1}(k2), minT);
                    [temp(:,N(n)*3+1:N(n)*4),~] = mkTrainData(EnData{k1}(k2).vInfKur,EnData{k1}(k2).tempo,N(n),M(m),D(d),tEst{k1}(k2), minT);
                    [temp(:,N(n)*4+1:N(n)*5),~] = mkTrainData(EnData{k1}(k2).vSupRMS,EnData{k1}(k2).tempo,N(n),M(m),D(d),tEst{k1}(k2), minT);
                    [temp(:,N(n)*5+1:N(n)*6),~] = mkTrainData(EnData{k1}(k2).vSupKur,EnData{k1}(k2).tempo,N(n),M(m),D(d),tEst{k1}(k2), minT);
                    [temp(:,N(n)*6+1:N(n)*7),tempo] = mkTrainData(EnData{k1}(k2).vaz,EnData{k1}(k2).tempo,N(n),1,D(d),tEst{k1}(k2), minT);
                    classTemp = strings(length(temp(:,1)),1);
                    classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
                    classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
                    classCor = [classCor;temp];
                    classAmac = [classAmac;classTemp];
                end

            end
            classAmac = categorical(classAmac);
            [B,dev,stats] = mnrfit(classCor,classAmac);
            prob = mnrval(B,classCor);
            prob = prob(:,1);
            classAmac = classAmac == 'amaciado';

            Res(n,m,d).TPR = nan(1,length(thr));
            Res(n,m,d).FPR = nan(1,length(thr));
            
            for k = 1:length(thr)
                gtest = prob>=thr(k);
                cMat = confusionmat(classAmac,gtest);
 %               Res(n,m,d).conf(k,:,:) = cMat;
                Res(n,m,d).TPR(k) = cMat(1,1)/sum(cMat(:,1));
                Res(n,m,d).FPR(k) = cMat(1,2)/sum(cMat(:,2));
            end
            maxTPR(n,m,d) = max(Res(n,m,d).TPR(Res(n,m,d).FPR<thrTPR));
            ppm.increment();
        end
    end
end
    
delete(ppm);

%%

[maxval, maxidx] = max(maxTPR(:));
[maxInd(1), maxInd(2), maxInd(3)] = ind2sub( size(maxTPR), maxidx);
nmax = N(maxInd(1));
mmax = M(maxInd(2));
dmax = D(maxInd(3));

thr = 0:0.001:1;

save('method_logisticRegression\Results.mat','Res','thr','thrTPR','maxTPR','N','M','D','maxInd','tEst','EnData','conjVal')


figure;
p = plot(Res(maxInd(1),maxInd(2),maxInd(3)).FPR,Res(maxInd(1),maxInd(2),maxInd(3)).TPR); xlim([0 1]); ylim([0 1]);
row = dataTipTextRow('Thr',thr);
p.DataTipTemplate.DataTipRows(end+1) = row;
ylabel('True Positive Rate TP/(TP+FN)');
xlabel('False Positive Rate FP/(FP+TN)');