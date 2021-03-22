clear; close all;

load('EnDataA.mat');

EnData = EnDataA;
%% Preparação do conjunto de treino

conjVal = [1,1;4,2;5,3]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]
% conjVal = [];

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
    tEstTest{1}(k1) = tEst{conjVal(k1,1)}(conjVal(k1,2));
    EnDataTest{1}(k1) = EnData{conjVal(k1,1)}(conjVal(k1,2));
    tEst{conjVal(k1,1)}(conjVal(k1,2)) = [];
    EnData{conjVal(k1,1)}(conjVal(k1,2)) = [];
end
       
N = 39; % Janela (número de amostras) da regressão
M = 100; % Janela da média móvel
D = 3; % Distância entre amostras da regressão
minT = 20; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)
wMax = 3; % Duração máxima da janela [h];

vars = {'cRMS','cKur','vInfRMS', 'vInfKur','vSupRMS','vSupKur','vaz'}; % Nomes das variáveis
for kint = 1:(length(vars)+1)

    vartemp = vars;
    
    if kint ~= 1
        vartemp(kint-1) = [];
    end
    
    [Xobs,Yres] = preTrain(EnData,tEst,N,M,D,minT,vartemp);
    [Xtest,Ytest] = preTrain(EnDataTest,tEstTest,N,M,D,minT,vartemp);
    
    num = cellstr(num2str(((0:(N-1))*D)')); % Número para variáveis que "pulam" amostras (X = x(n),x(n-1*D), x(n-2*D)...)
    num = strrep(num,' ',''); % Tira espaço vazio dos nomes
    
    if kint ~= (length(vars)+1) % Vazão não foi excluída
        if kint == 1 % Todas as variáveis
            varnames = append(strcat(vartemp(1:6),'_'),num);
        else % Uma variável excluída
            varnames = append(strcat(vartemp(1:5),'_'),num);
        end
         varnames = reshape(varnames,[],1); % Gera array com nomes

        num = cellstr(num2str((0:(N-1))')); num = strrep(num,' ',''); % Número para variáveis que não "pulam" amostras (X = x(n),x(n-1), x(n-2)...)
        varnames = [varnames; append('vaz_',num)]; % Prepara array com nomes de todos os preditores + classe
    else % Vazão foi excluída
        varnames = append(strcat(vartemp,'_'),num); varnames = reshape(varnames,[],1); % Gera array com nomes
    end
    varnames = [varnames; 'Class']; % Prepara array com nomes de todos os preditores + classe
    TTrain = array2table([Xobs,Yres],'VariableNames',varnames); % Transforma array em tabela
    
    % Feature selection

    YrFS = double(Yres);
    YrFS(YrFS==0) = -1;
    alpha = 0.5; sup = 1;
    numF = size(Xobs,2);

    % mRMR
    ranking = mRMR(Xobs,YrFS,numF);

    rankedVar = varnames(ranking);
    ROC_AUC_Train = [];
    
    ppm = ParforProgressbar(min([(length(varnames)-1),300]));
    parfor k = 1:min([(length(varnames)-1),300])
        ppm.increment();
        [trainedClassifier, ROC_AUC_Train(k)] = trainFineTree([TTrain(:,ranking(1:k)),TTrain(:,end)],rankedVar(1:k));
        partitionedModel = crossval(trainedClassifier.ClassificationTree, 'KFold', 5);
        loss = kfoldLoss(partitionedModel);
        [testLabel,testScore,~] = predict(trainedClassifier.ClassificationTree,Xtest(:,ranking(1:k)));
        [~,~,~,ROC_AUC_Test(k)] = perfcurve(Ytest,testScore(:,2),1);
    end
    delete(ppm);
    
    AUC_train{kint} = ROC_AUC_Train;
    AUC_test{kint} = ROC_AUC_Test;
end

figure;
for kvar = 1:8
    plot(AUC_train{kvar}); hold on;
    AUC_Max_Train(kvar) = max(AUC_train{kvar});
    AUC_Max_Test(kvar) = max(AUC_test{kvar});
end
hold off;

xlabel('Número de Features'); ylabel('ROC AUC');
legend(['Todos' append('Sem ',vars)]);

figure;
bar([AUC_Max_Train;AUC_Max_Test]'); xticks(1:8); xticklabels(['Todos' vars]); legend('Train AUC','Test AUC');