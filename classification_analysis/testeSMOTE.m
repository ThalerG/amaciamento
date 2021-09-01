clear; close all;

load('EnDataA_Dissertacao.mat');

EnData = EnDataA; 

clear EnDataA;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
% rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

% Create new folder for generated files
c = clock;

%% Preparação dos conjuntos

% conjVal = [1,1;4,2;5,3]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]
% conjVal = 20;
% conjVal = [];
conjVal = [4,1]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]

% Tempos de amaciamento esperados:

loadTempoAmacADissert;

%% Parâmetros de busca
% Opções de métrica de desempenho:
% ROC_AUC -> Área abaixo da curva ROC 
% FselBeta -> F-score para dado valor de selBeta Bx,Ax] = ndgrid(1:numel(A),1:numel(A));
% MCC - > Coeficiente de correlação de Matthews

selMethod = 'MCC';

selBeta = 0.5; % Valor de selBeta caso o método seja F-selBeta

%%%%%%%%%%%%%%% Pré-processamento: %%%%%%%%%%%%%%

N = 5; % Janela (número de amostras) da regressão
M = 5; % Janela da média móvel
D = 3; % Distância entre amostras da regressão

wMax = 3; % Duração máxima da janela [h]

vars = {'cRMS'}; % Variáveis utilizadas

%%%%%%%%%%%%%%% Classificador: %%%%%%%%%%%%%%

% logReg -> Regressão logística
% tree -> Árvore
% SVM -> SVM cúbica
% KNN -> K-Nearest Neighbors

kFold = 5; % Número de kFold para classificação
methodML = 'KNN'; % Método para classificação

% Parâmetros para análise de pré-processamento e feature selection
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


% hex_XXXX -> Método "híbrido" de seleção de grandezas extensiva e o filtro de variáveis XXXX
% hgr_XXXX -> Método "híbrido" de seleção de grandezas greedy e o filtro de variáveis XXXX
% none -> Sem filtro de variáveis
% mRMR -> Score por mínima redundância, máxima relevância

maxFeatures = 200; % Número máximo de features selecionadas
FSmethod = 'hex_none'; % Método para feature selection

%%%%%%%%%%%%%%% Oversampling: %%%%%%%%%%%%%%

% "none"
% "SMOTE"
% "ADASYN"
% "Borderline SMOTE"
% "Safe-level SMOTE"

% paramOvers = {method,% of new samples,k neighbors, standardize}
paramOvers = {'SMOTE', 200, 10, false};

%% Pasta e arquivos

% Cria pasta para análise

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