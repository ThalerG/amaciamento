clear; close all;

load('EnDataA_Dissertacao.mat');

EnData = EnDataA; 

clear EnDataA;

% rt = 'D:\Documentos\Amaciamento\'; % Root folder
rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

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

N = 1:5; % Janela (n�mero de amostras) da regress�o
M = [1, 5:5:25, 30:10:180]; % Janela da m�dia m�vel
D = [1:10,15:5:25, 30:10:90 100:20:180]; % Dist�ncia entre amostras da regress�o

wMax = 3.02; % Dura��o m�xima da janela [h]

% vars = {'cRMS', 'cKur', 'cVar', 'vInfRMS', 'vInfKur', 'vInfVar', 'vSupRMS', 'vSupKur', 'vSupVar', 'vaz'}; % Vari�veis utilizadas
vars = {'cRMS', 'cKur', 'cVar', 'vaz'}; % Vari�veis utilizadas

standardize = true;

%%%%%%%%%%%%%%% Classificador: %%%%%%%%%%%%%%

% logReg -> Regress�o log�stica
% tree -> �rvore
% SVM -> SVM
% KNN -> K-Nearest Neighbors

kFold = 5; % N�mero de kFold para classifica��o
methodML = 'logReg'; % M�todo para classifica��o

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
fsave = [rt 'Ferramentas\Arquivos Gerados\Dissertacao_ModeloA_TestePorEnsaio_SMOTE\classification_' methodML '_' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;

% Cria arquivo de log
fid = fopen([fsave, 'log.txt'], 'w');
print_logIntro;

%% An�lise de pr�-processamento    

fsave_preProc = [fsave,'analise_preProcessamento\'];

mkdir(fsave_preProc);

numIt = nnz(((N-1)'.*D/60)<=wMax)*length(M);

cstart = clock;

% preproc_printStart;

ppm = ParforProgressbar(numIt, 'progressBarUpdatePeriod', 5);

preProc.N = NaN; preProc.M = NaN; preProc.D = NaN;
preProc.ROC_AUC_Train = NaN; preProc.fselBeta_Train = NaN; preProc.MMC_Train = NaN; preProc.time_Train = NaN;
preProc.ROC_AUC_Test = NaN; preProc.fselBeta_Test = NaN; preProc.MMC_Test = NaN;

lenN = length(N); lenM = length(M); lenD = length(D);

preProcAn = repmat(preProc, lenN, lenM, lenD);

if numel(conjVal) == 1
    indTest = cell(lenN,lenM,lenD);
end

clear preProc;

parfor n = 1:lenN
% for n = 1:lenN
    for m = 1:lenM
        for d = 1:lenD
             preProcAn(n,m,d).N = N(n);
             preProcAn(n,m,d).M = M(m);
             preProcAn(n,m,d).D = D(d);
             
             if ((N(n)-1)*D(d)/60)>wMax
                 continue
             end
             
             if numel(conjVal) == 1
                [Ttrain,Xtrain,Ytrain,Xtest,Ytest,indTest{n,m,d}] = preproc_data(EnData,tEst,conjVal,N(n),M(m),D(d),Inf,vars,paramOvers,standardize);
             else
                [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N(n),M(m),D(d),Inf,vars,paramOvers,standardize);
             end
             
             [trainedClassifier,predictTrain,scoreTrain,timeTrain] = train_ML(Ttrain, methodML, kFold, paramML);
             preProcAn(n,m,d).time_Train = timeTrain;
             
             [predictTest,scoreTest] = trainedClassifier.predict(Xtest);
             
             [preProcAn(n,m,d).ROC_AUC_Train, preProcAn(n,m,d).fselBeta_Train, preProcAn(n,m,d).MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
             [preProcAn(n,m,d).ROC_AUC_Test, preProcAn(n,m,d).fselBeta_Test, preProcAn(n,m,d).MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);
             
             ppm.increment();
        end
    end
end

delete(ppm);

cend = clock;
cel = etime(cend,cstart); cdur(1) = floor(cel/(3600)); cdur(2) = floor(rem(cel,(3600))/60); cdur(3) = rem(cel,60);

preproc_graph;

preProcAn = reshape(preProcAn,[],1);
preProcAn(isnan([preProcAn(:).ROC_AUC_Train]')) = [];
preProcAnTable = struct2table(preProcAn);

save([fsave_preProc 'results_rawMatrix'],'preProcAn');

switch selMethod % Rankeia os resultados pela m�trica selecionada
    case 'ROC_AUC'
        preProcAnTable = sortrows(preProcAnTable,'ROC_AUC_Train','descend');
    case 'Fbeta'
        preProcAnTable = sortrows(preProcAnTable,'fselBeta_Train','descend');
    case 'MCC'
        preProcAnTable = sortrows(preProcAnTable,'MMC_Train','descend');
    otherwise
        error(['Performance metric "', selMethod,'" not recognized'])
end

save([fsave_preProc 'parameters'],'D','N','M','selMethod','selBeta');
save([fsave_preProc 'results_rankedTable'],'preProcAnTable');


if numel(conjVal) == 1
    conjVal = indTest{N == preProcAnTable.N(1),M == preProcAnTable.M(1), D == preProcAnTable.D(1)};
end

N = preProcAnTable.N(1);
M = preProcAnTable.M(1);
D = preProcAnTable.D(1);

preproc_printEnd;

clear preProcAnTable preProcAn cel cend cstart numIt

%% An�lise de features

fsave_featSel = [fsave,'analise_featureSelection\'];

mkdir(fsave_featSel);

cstart = clock;

featsel_printStart;

switch FSmethod
    case 'hex_none'
        featsel_hex_none; % Poda extensiva de grandezas
    case 'hgr_none'
        featsel_hgr_none; % Poda greedy de grandezas
    case 'none'
        % N�o faz nada
    otherwise
        switch FSmethod(1:4)
            case 'hex_'
                featsel_hex_ranked; % Poda extensiva de grandezas com features filtradas
            case 'hgr_'
                featsel_hgr_ranked; % Poda greedy de grandezas com features filtradas
            otherwise
                featsel_ranked; % Features filtradas
        end
end

cend = clock;
cel = etime(cend,cstart); cdur(1) = floor(cel/(3600)); cdur(2) = floor(rem(cel,(3600))/60); cdur(3) = rem(cel,60);

featSelAn = reshape(featSelAn,[],1);
featSelAn(isnan([featSelAn(:).ROC_AUC_Train]')) = [];
featSelAnTable = struct2table(featSelAn);

save([fsave_featSel 'results_rawMatrix'],'featSelAn');

switch selMethod % Rankeia os resultados pela m�trica selecionada
    case 'ROC_AUC'
        featSelAnTable = sortrows(featSelAnTable,'ROC_AUC_Train','descend');
    case 'Fbeta'
        featSelAnTable = sortrows(featSelAnTable,'fselBeta_Train','descend');
    case 'MCC'
        featSelAnTable = sortrows(featSelAnTable,'MMC_Train','descend');
    otherwise
        error(['Performance metric "', selMethod,'" not recognized'])
end

featsel_graph;

save([fsave_featSel 'parameters'],'vars','selMethod','selBeta','maxFeatures');
save([fsave_featSel 'results_rankedTable'],'featSelAnTable');

varsSel = featSelAnTable{1,1}; varsSel = varsSel{1};

featSelAnTable = varsTable2charTable(featSelAnTable);

featsel_printEnd;

clear featSelAnTable featSelAn cel cend cstart

%% An�lise de hiperpar�metros

fsave_analysisML = [fsave,'analise_hyperparameterML\'];

mkdir(fsave_analysisML);

cstart = clock;

analysisML_printStart;

switch methodML
    case 'logReg'
        analysisML_logreg;
    case 'tree'
        analysisML_tree;
    case 'SVM'
        analysisML_SVM;
    case 'KNN'
        analysisML_KNN;
end

cend = clock;
cel = etime(cend,cstart); cdur(1) = floor(cel/(3600)); cdur(2) = floor(rem(cel,(3600))/60); cdur(3) = rem(cel,60);

analysisMLAn = reshape(analysisMLAn,[],1);
analysisMLAn(isnan([analysisMLAn(:).ROC_AUC_Train]')) = [];
analysisMLAnTable = struct2table(analysisMLAn);

save([fsave_analysisML 'results_rawMatrix'],'analysisMLAn');

analysisML_graph;

switch selMethod % Rankeia os resultados pela m�trica selecionada
    case 'ROC_AUC'
        analysisMLAnTable = sortrows(analysisMLAnTable,'ROC_AUC_Train','descend');
    case 'Fbeta'
        analysisMLAnTable = sortrows(analysisMLAnTable,'fselBeta_Train','descend');
    case 'MCC'
        analysisMLAnTable = sortrows(analysisMLAnTable,'MMC_Train','descend');
    otherwise
        error(['Performance metric "', selMethod,'" not recognized'])
end

save([fsave_analysisML 'parameters'],'selMethod','selBeta','methodML','paramMLBusca');
save([fsave_analysisML 'results_rankedTable'],'analysisMLAnTable');

analysisML_printEnd;

clear featSelAnTable featSelAn cel cend cstart

fclose(fid);