clear; close all;

load('EnDataA.mat');

EnData = EnDataA; 

clear EnDataA;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
% rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

%% Prepara��o dos conjuntos

% conjVal = [1,1;4,2;5,3]; % Ensaios reservados para conjunto de valida��o [Amostra, ensaio]
conjVal = 20;
% conjVal = [];
% conjVal = [1,1]; % Ensaios reservados para conjunto de valida��o [Amostra, ensaio]

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

selBeta = 0.5; % Valor de selBeta caso o m�todo seja F-selBeta

%%%%%%%%%%%%%%% Pr�-processamento: %%%%%%%%%%%%%%

N = 3; % Janela (n�mero de amostras) da regress�o
M = 170; % Janela da m�dia m�vel
D = 30; % Dist�ncia entre amostras da regress�o

vars = {'cRMS', 'cKur', 'vInfRMS', 'vInfKur', 'vSupRMS', 'vSupKur', 'vaz'}; % Vari�veis utilizadas

%%%%%%%%%%%%%%% Classificador: %%%%%%%%%%%%%%

% logReg -> Regress�o log�stica
% tree -> �rvore
% SVM -> SVM c�bica
% KNN -> K-Nearest Neighbors

kFold = 5; % N�mero de kFold para classifica��o
methodML = 'SVM'; % M�todo para classifica��o

% Par�metros para an�lise de pr�-processamento e feature selection
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
