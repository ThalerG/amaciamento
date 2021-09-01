clear; close all;

load('EnDataA_Dissertacao.mat');

EnData = EnDataA; 

clear EnDataA;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
% rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

% Create new folder for generated files
c = clock;

%% Prepara��o dos conjuntos

% conjVal = [1,1;4,2;5,3]; % Ensaios reservados para conjunto de valida��o [Amostra, ensaio]
% conjVal = 20;
% conjVal = [];
conjVal = [4,1]; % Ensaios reservados para conjunto de valida��o [Amostra, ensaio]

% Tempos de amaciamento esperados:

loadTempoAmacADissert;

%% Par�metros de busca
% Op��es de m�trica de desempenho:
% ROC_AUC -> �rea abaixo da curva ROC 
% FselBeta -> F-score para dado valor de selBeta Bx,Ax] = ndgrid(1:numel(A),1:numel(A));
% MCC - > Coeficiente de correla��o de Matthews

selMethod = 'MCC';

selBeta = 0.5; % Valor de selBeta caso o m�todo seja F-selBeta

%%%%%%%%%%%%%%% Pr�-processamento: %%%%%%%%%%%%%%

N = 5; % Janela (n�mero de amostras) da regress�o
M = 5; % Janela da m�dia m�vel
D = 3; % Dist�ncia entre amostras da regress�o

wMax = 3; % Dura��o m�xima da janela [h]

vars = {'cRMS'}; % Vari�veis utilizadas

%%%%%%%%%%%%%%% Classificador: %%%%%%%%%%%%%%

% logReg -> Regress�o log�stica
% tree -> �rvore
% SVM -> SVM c�bica
% KNN -> K-Nearest Neighbors

kFold = 5; % N�mero de kFold para classifica��o
methodML = 'KNN'; % M�todo para classifica��o

% Par�metros para an�lise de pr�-processamento e feature selection
switch methodML
    case 'tree'
        maxSplits = 20;
        paramML = {maxSplits};
        
        maxSplitsBusca = 5:5:80;
        paramMLBusca = {maxSplitsBusca};
    case 'SVM'
        kernelFunction = 'quadratic';
        kernelScale = 'auto';
        paramML = {kernelFunction,kernelScale};
        
        kernelFunctionBusca = {'linear','quadratic','cubic'};
        kernelScaleBusca = {'auto'};
        paramMLBusca = {kernelFunctionBusca,kernelScaleBusca};
    case 'KNN'
        numNeighbors = 10;
        distance = 'Euclidean';
        weight = 'equal';
        paramML = {numNeighbors, distance, weight};
        
        numNeighborsBusca = [1, 5:5:100];
        distanceBusca = {'Euclidean'};
        weightBusca = {'equal'};
        paramMLBusca = {numNeighborsBusca, distanceBusca, weightBusca};
    case 'logReg'
        paramML = {};
        
        paramMLBusca = {};
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

% paramOvers = {method,% of new samples,k neighbors, standardize}
paramOvers = {'SMOTE', 200, 10, false};

%% Pasta e arquivos

% Cria pasta para an�lise

numIt = nnz(((N-1)'.*D/60)<=wMax)*length(M);

preProc.N = NaN; preProc.M = NaN; preProc.D = NaN;
preProc.ROC_AUC_Train = NaN; preProc.fselBeta_Train = NaN; preProc.MMC_Train = NaN; preProc.time_Train = NaN;
preProc.ROC_AUC_Test = NaN; preProc.fselBeta_Test = NaN; preProc.MMC_Test = NaN;

lenN = length(N); lenM = length(M); lenD = length(D);

preProcAn = repmat(preProc, lenN, lenM, lenD);

if numel(conjVal) == 1
    indTest = cell(lenN,lenM,lenD);
end

clear preProc;

for n = 1:lenN
    for m = 1:lenM
        for d = 1:lenD
             preProcAn(n,m,d).N = N(n);
             preProcAn(n,m,d).M = M(m);
             preProcAn(n,m,d).D = D(d);
             
             if ((N(n)-1)*D(d)/60)>wMax
                 continue
             end
             
             if numel(conjVal) == 1
                [Ttrain,Xtrain,Ytrain,Xtest,Ytest,indTest{n,m,d}] = preproc_data(EnData,tEst,conjVal,N(n),M(m),D(d),Inf,vars);
             else
                [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N(n),M(m),D(d),Inf,vars);
             end
             
             switch paramOvers{1}
                 case "SMOTE"
                     Ttrain.Amaciado = cellstr((num2str(Ttrain.Amaciado)));
                     options.NumNeighbors = paramOvers{3};
                     options.Standardize = paramOvers{4};
                     [newdata,visdata] = mySMOTE(Ttrain, "0", paramOvers{2}, options);
                 case "ADASYN"
                     
                 case "Borderline SMOTE"
                     
                 case "Safe-level SMOTE"
                     
             end
             
             [trainedClassifier,predictTrain,scoreTrain,timeTrain] = train_ML(Ttrain, methodML, kFold, paramML);
             preProcAn(n,m,d).time_Train = timeTrain;
             
             [predictTest,scoreTest] = trainedClassifier.predict(Xtest);
             
             [preProcAn(n,m,d).ROC_AUC_Train, preProcAn(n,m,d).fselBeta_Train, preProcAn(n,m,d).MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
             [preProcAn(n,m,d).ROC_AUC_Test, preProcAn(n,m,d).fselBeta_Test, preProcAn(n,m,d).MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);
             
        end
    end
end