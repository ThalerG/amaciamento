load('EnDataA.mat');

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
       
minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)

FitCL = 0;

[Xobs,Yres] = preTrain(EnData,tEst,N,M,D,minT);

rng(10); % Fixed random seed generator


gtest = yPred>=thr;

figure;
cMat = confusionmat(Yres,gtest);
cm = confusionchart(cMat,{'Não Amaciado','Amaciado'});
cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';