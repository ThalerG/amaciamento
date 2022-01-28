clear; close all;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
% rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder
rng(10)

loadA = 0;
testeEnsaio = 1;

% Tempo m�nimo e m�ximo para avalia��o dos ensaios
tempoMin = 1;
tempoMaxA = 20;
tempoMaxB = 40;

if loadA
    load('EnDataA_Dissertacao.mat');
    cortaEnsaios;
    EnData = EnDataA;
    clear EnDataA;
    
    % Tempos de amaciamento esperados:
    loadTempoAmacAPopular;
    % loadTempoAmacAConservador; txt = 'ModeloACon_';
    CombinacoesSVMGaussA;
    
    if testeEnsaio
        conjVal = [4,1]; % Ensaios reservados para conjunto de valida��o [Amostra, ensaio]
        descarte = [4,3;4,2];
    else
        conjVal = 20;
        descarte = [];
    end

else
    load('EnDataB_DissertacaoA.mat');
    cortaEnsaios;
    EnData = EnDataB; 
    clear EnDataB;
    
    % Tempos de amaciamento esperados:
    loadTempoAmacBPopular;
    % loadTempoAmacBConservador; txt = 'ModeloBCon_';
    CombinacoesSVMGaussB;
    
    if testeEnsaio
        conjVal = [7,1]; % Ensaios reservados para conjunto de valida��o [Amostra, ensaio]
        descarte = [7,3;7,2];
    else
        conjVal = 20;
        descarte = [];
    end
end

%% Prepara��o dos conjuntos

% conjVal = [1,1;4,2;5,3]; % Ensaios reservados para conjunto de valida��o [Amostra, ensaio]

if ~isempty(descarte)
    for k = 1:length(descarte(:,1))
        EnData{descarte(k,1)}(descarte(k,2)) = [];
    end
end

%% Par�metros de busca
% Op��es de m�trica de desempenho:
% ROC_AUC -> �rea abaixo da curva ROC 
% FselBeta -> F-score para dado valor de selBeta Bx,Ax] = ndgrid(1:numel(A),1:numel(A));
% MCC - > Coeficiente de correla��o de Matthews

selMethod = 'MCC';

selBeta = 1; % Valor de selBeta caso o m�todo seja F-selBeta

%%%%%%%%%%%%%%% Pr�-processamento: %%%%%%%%%%%%%%



wMax = 3.02; % Dura��o m�xima da janela [h]

standardize = true;

%%%%%%%%%%%%%%% Classificador: %%%%%%%%%%%%%%

% logReg -> Regress�o log�stica
% tree -> �rvore
% SVM -> SVM
% KNN -> K-Nearest Neighbors

kFold = 5; % N�mero de kFold para classifica��o
methodML = 'SVM'; % M�todo para classifica��o

% Par�metros para an�lise de pr�-processamento e feature selection
switch methodML
    case 'tree'
        maxSplits = 20;
        paramML = {maxSplits};

    case 'SVM'
%         kernelFunction = 'linear';
%         kernelScale = 'auto';
        kernelFunction = 'gaussian';
        kernelScale = 1;
        paramML = {kernelFunction,kernelScale};
        paramReg = logspace(-7,10,100);
    case 'KNN'
        numNeighbors = 10;
        distance = 'Euclidean';
        weight = 'equal';
        paramML = {numNeighbors, distance, weight};
        
    case 'logReg'
        paramML = {};
        
    otherwise
        str = ['Model "',methodML,'" not recognized'];
        error(str)
end

%%%%%%%%%%%%%%% Feature selection: %%%%%%%%%%%%%%


% hex_XXXX -> M�todo "h�brido" de sele��o de grandezas extensiva e o filtro de vari�veis XXXX
% hgr_XXXX -> M�todo "h�brido" de sele��o de grandezas greedy e o filtro de vari�veis XXXX
% none -> Sem filtro de vari�veis
% mRMR -> Score por m�nima redund�ncia, m�xima relev�ncia

maxFeatures = 200; % N�mero m�ximo de features selecionadas
FSmethod = 'hex_none'; % M�todo para feature selection

%%%%%%%%%%%%%%% Oversampling: %%%%%%%%%%%%%%

% "none"
% "SMOTE"
% "ADASYN"
% "Borderline SMOTE"
% "Safe-level SMOTE"
% "RandomUndersampling"

% paramOvers = {method,% of new samples,k neighbors, standardize}
paramOvers = {'SMOTE+RU', 200, 5, false};


%% Treino ML    

results.N = NaN; results.M = NaN; results.D = NaN; results.vars = {}; results.BoxConst = NaN;
results.ROC_AUC_Train = NaN; results.fselBeta_Train = NaN; results.MMC_Train = NaN; results.time_Train = NaN;
results.ROC_AUC_Test = NaN; results.fselBeta_Test = NaN; results.MMC_Test = NaN;

Comb = Comb(1);
results = repmat(results,length(Comb),length(paramReg));
lenC = length(Comb);
lenM = length(paramReg);
numIt = lenC*lenM;
ppm = ParforProgressbar(numIt, 'progressBarUpdatePeriod', 5);

parfor kc = 1:lenC
    for km = 1:lenM
        results(kc,km).N = Comb(kc).N;
        results(kc,km).M = Comb(kc).M;
        results(kc,km).D = Comb(kc).D;
        results(kc,km).BoxConst = paramReg(km);
        results(kc,km).vars = Comb(kc).vars;
        
        if numel(conjVal) == 1
            [Ttrain,Xtrain,Ytrain,Xtest,Ytest,indTest] = preproc_data(EnData,tEst,conjVal,Comb(kc).N,Comb(kc).M,Comb(kc).D,Inf,Comb(kc).vars,paramOvers,standardize);
        else
            [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,Comb(kc).N,Comb(kc).M,Comb(kc).D,Inf,Comb(kc).vars,paramOvers,standardize);
        end
        
        paramMLtemp = [paramML,{paramReg(km)}];
        [trainedClassifier,predictTrain,scoreTrain,timeTrain] = train_ML(Ttrain, methodML, kFold, paramMLtemp);
        results(kc,km).time_Train = timeTrain;

        [predictTest,scoreTest] = trainedClassifier.predict(Xtest);

        [results(kc,km).ROC_AUC_Train, results(kc,km).fselBeta_Train, results(kc,km).MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
        [results(kc,km).ROC_AUC_Test, results(kc,km).fselBeta_Test, results(kc,km).MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);
        ppm.increment();
    end
end

delete(ppm)

resultsTable = reshape(results,[],1);
resultsTable = struct2table(resultsTable);