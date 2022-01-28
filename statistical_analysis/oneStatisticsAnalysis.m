clear; close all;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
% rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

loadA = 1;
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
    loadTempoAmacAPopular; txt = 'ModeloAPop_';
    % loadTempoAmacAConservador; txt = 'ModeloACon_';
    
    if testeEnsaio
        conjVal = [4,1]; % Ensaios reservados para conjunto de valida��o [Amostra, ensaio]
        descarte = [4,3;4,2];
        txt = [txt,'TestePorEnsaio_'];
    else
        conjVal = 20;
        descarte = [];
        txt = [txt,'Teste8020_'];
    end

else
    load('EnDataB_DissertacaoA.mat');
    cortaEnsaios;
    EnData = EnDataB; 
    clear EnDataB;
    
    % Tempos de amaciamento esperados:
    loadTempoAmacBPopular; txt = 'ModeloBPop_';
    % loadTempoAmacBConservador; txt = 'ModeloBCon_';
    
    if testeEnsaio
        conjVal = [7,1]; % Ensaios reservados para conjunto de valida��o [Amostra, ensaio]
        descarte = [7,3;7,2];
        txt = [txt,'TestePorEnsaio_'];
    else
        conjVal = 20;
        descarte = [];
        txt = [txt,'Teste8020_'];
    end
end


%% Prepara��o dos conjuntos

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

wMax = 3.02; % Dura��o m�xima da janela [h]

% vars = {'cRMS', 'cKur', 'cVar', 'vInfRMS', 'vInfKur', 'vInfVar', 'vSupRMS', 'vSupKur', 'vSupVar', 'vaz'}; % Vari�veis utilizadas

standardize = false;

%%%%%%%%%%%%%%% Teste T: %%%%%%%%%%%%%%

method = 'RstatsH';

%  Opcoes:
% testT
% spcDif
% RstatsH
% RstatsTb

switch method
    case 'testT'
        if loadA
            N = 10; % Sample window for linear regression
            M = 5; % Janela da m�dia m�vel
            D = 5; % Dist�ncia entre amostras da regress�o
            ALPHA = 0.01;
            vars = {'cRMS'}; % Vari�veis utilizadas
        else
            N = 10; % Sample window for linear regression
            M = 5; % Janela da m�dia m�vel
            D = 5; % Dist�ncia entre amostras da regress�o
            ALPHA = 0.01;
            vars = {'vaz'}; % Vari�veis utilizadas
        end
        param = {N,M,D,ALPHA};
        
%         vars = {'cRMS', 'cKur', 'cVar', 'vaz'}; % Vari�veis utilizadas
        
    case 'spcDif'
        if loadA
            M = 100;
            D = 10;
            dMax = 2.1e-4; % Maximum tolerated difference
            vars = {'cKur'}; % Vari�veis utilizadas
        else
            M = 180;
            D = 50;
            dMax = 4e-4; % Maximum tolerated difference
            vars = {'cKur'}; % Vari�veis utilizadas
        end
        param = {M,D,dMax};
        
%         vars = {'cRMS', 'cKur', 'cVar', 'vaz'}; % Vari�veis utilizadas
    case 'RstatsH'
        if loadA
            L1 = 0.02;
            L2 = 0.2;
            L3 = 0.03;
            Rc = 5;
            vars = {'cRMS'}; % Vari�veis utilizadas
        else
            L1 = 0.02;
            L2 = 0.05;
            L3 = 0.03;
            Rc = 1.75;
            vars = {'cRMS'}; % Vari�veis utilizadas
        end
        param = {L1, L2, L3, Rc};
        
%         vars = {'cRMS', 'cKur', 'cVar', 'vaz'}; % Vari�veis utilizadas
    case 'RstatsTb'
        if loadA
            L1 = 0.02;
            L23 = 0.5;
            ALPHA = 0.01;
            vars = {'cRMS'}; % Vari�veis utilizadas
        else
            L1 = 0.1;
            L23 = 0.02;
            ALPHA = 0.01;
            vars = {'cKur'}; % Vari�veis utilizadas
        end
        param = {L1, L23, ALPHA};
        
%         vars = {'cRMS', 'cKur', 'cVar', 'vaz'}; % Vari�veis utilizadas
end

%%%%%%%%%%%%%%% Oversampling: %%%%%%%%%%%%%%

% "none"
% "SMOTE"
% "ADASYN"
% "Borderline SMOTE"
% "Safe-level SMOTE"
% "RandomUndersampling"

% paramOvers = {method,% of new samples,k neighbors, standardize}
paramOvers = {'none', 200, 5, false};


switch method
    case 'RstatsH'
        [Xtrain,Ytrain,Xtest,Ytest, tTrain, tTest] = rStats_preproc_data(EnData,tEst,param{1},param{2},param{3},conjVal,vars);
    case 'RstatsTb'
        [Xtrain,Ytrain,Xtest,Ytest, tTrain, tTest] = rStats_preproc_data(EnData,tEst,param{1},param{2},param{2},conjVal,vars);
    case 'spcDif'
        N = 2;
        M = param{1};
        D = param{2};
        if numel(conjVal) == 1
            [Ttrain,Xtrain,Ytrain,Xtest,Ytest,indTest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,vars,paramOvers,standardize);
        else
            [Ttrain,Xtrain,Ytrain,Xtest,Ytest, tTrain, tTest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,vars,paramOvers,standardize);
        end
    case 'testT'
        N = param{1};
        M = param{2};
        D = param{3};
        if numel(conjVal) == 1
            [Ttrain,Xtrain,Ytrain,Xtest,Ytest,indTest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,vars,paramOvers,standardize);
        else
            [Ttrain,Xtrain,Ytrain,Xtest,Ytest, tTrain, tTest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,vars,paramOvers,standardize);
        end
end

[predictTrain,scoreTrain] = predict_stats(Xtrain, method, param);
[predictTest,scoreTest] = predict_stats(Xtest, method, param);

[ROC_AUC_Train, tTestAn.fselBeta_Train, tTestAn.MMC_Train] = performanceMetrics(double(Ytrain), double(predictTrain), scoreTrain, selBeta);
[ROC_AUC_Test, tTestAn.fselBeta_Test, tTestAn.MMC_Test] = performanceMetrics(double(Ytest), double(predictTest), scoreTest, selBeta);