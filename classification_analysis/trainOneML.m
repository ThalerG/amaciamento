clear; close all;

load('EnDataA.mat');

EnData = EnDataA; 

clear EnDataA;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
% rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

%% Preparação dos conjuntos

% conjVal = [1,1;4,2;5,3]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]
conjVal = 20;
% conjVal = [];
% conjVal = [1,1]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]

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

selBeta = 0.5; % Valor de selBeta caso o método seja F-selBeta

%%%%%%%%%%%%%%% Pré-processamento: %%%%%%%%%%%%%%

N = 3; % Janela (número de amostras) da regressão
M = 170; % Janela da média móvel
D = 30; % Distância entre amostras da regressão

vars = {'cRMS', 'cKur', 'vInfRMS', 'vInfKur', 'vSupRMS', 'vSupKur', 'vaz'}; % Variáveis utilizadas

%%%%%%%%%%%%%%% Classificador: %%%%%%%%%%%%%%

% logReg -> Regressão logística
% tree -> Árvore
% SVM -> SVM cúbica
% KNN -> K-Nearest Neighbors

kFold = 5; % Número de kFold para classificação
methodML = 'SVM'; % Método para classificação

% Parâmetros para análise de pré-processamento e feature selection
switch methodML
    case 'tree'
        maxSplits = 20;
        paramML = {maxSplits};
    case 'SVM'
        kernelFunction = 'linear';
        kernelScale = 'auto';
        paramML = {kernelFunction,kernelScale};
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

%%%%%%%%%%%%%%% Oversampling: %%%%%%%%%%%%%%

% "none"
% "SMOTE"
% "ADASYN"
% "Borderline SMOTE"
% "Safe-level SMOTE"

% paramOvers = {method,% of new samples,k neighbors, standardize}
paramOvers = {'none', 200, 10, false};

%% Pasta e arquivos


 if numel(conjVal) == 1
    [Ttrain,Xtrain,Ytrain,Xtest,Ytest,indTest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,vars);
 else
    [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,vars);
 end

 c1 = clock;
 [trainedClassifier,predictTrain,scoreTrain] = train_ML(Ttrain, methodML, kFold, paramML);
 c2 = clock;
 cd = etime(c2,c1);
 time_Train = cd;

 [predictTest,scoreTest] = trainedClassifier.predict(Xtest);
 [ROC_AUC_Train, fselBeta_Train, MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
 [ROC_AUC_Test, fselBeta_Test, MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);
