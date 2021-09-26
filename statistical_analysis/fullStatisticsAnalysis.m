clear; close all;

% rt = 'D:\Documentos\Amaciamento\'; % Root folder
rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

loadA = 0;
testeEnsaio = 1;

% Tempo mínimo e máximo para avaliação dos ensaios
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
        conjVal = [4,1]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]
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
        conjVal = [7,1]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]
        descarte = [7,3;7,2];
        txt = [txt,'TestePorEnsaio_'];
    else
        conjVal = 20;
        descarte = [];
        txt = [txt,'Teste8020_'];
    end
end


%% Preparação dos conjuntos

if ~isempty(descarte)
    for k = 1:length(descarte(:,1))
        EnData{descarte(k,1)}(descarte(k,2)) = [];
    end
end

%% Parâmetros de busca
% Opções de métrica de desempenho:
% ROC_AUC -> Área abaixo da curva ROC 
% FselBeta -> F-score para dado valor de selBeta Bx,Ax] = ndgrid(1:numel(A),1:numel(A));
% MCC - > Coeficiente de correlação de Matthews

selMethod = 'MCC';

selBeta = 1; % Valor de selBeta caso o método seja F-selBeta

wMax = 3.02; % Duração máxima da janela [h]

% vars = {'cRMS', 'cKur', 'cVar', 'vInfRMS', 'vInfKur', 'vInfVar', 'vSupRMS', 'vSupKur', 'vSupVar', 'vaz'}; % Variáveis utilizadas
vars = {'cRMS', 'cKur', 'cVar', 'vaz'}; % Variáveis utilizadas
standardize = false;

%%%%%%%%%%%%%%% Teste T: %%%%%%%%%%%%%%


N = 5:5:100; % Sample window for linear regression
M = [1, 5, 10:10:90, 100:20:180]; % Janela da média móvel
D = [1:2:5, 10:10:90, 100:20:180]; % Distância entre amostras da regressão
ALPHA = [0:0.01:0.89, 0.9:0.001:1];

% N = 5:5:10; % Sample window for linear regression
% M = 10:10:30; % Janela da média móvel
% D = 10:10:30; % Distância entre amostras da regressão
% ALPHA = 0:0.01:1;

%%%%%%%%%%%%%%% Oversampling: %%%%%%%%%%%%%%

% "none"
% "SMOTE"
% "ADASYN"
% "Borderline SMOTE"
% "Safe-level SMOTE"
% "RandomUndersampling"

% paramOvers = {method,% of new samples,k neighbors, standardize}
paramOvers = {'none', 200, 5, false};

%% Pasta e arquivos

c = clock;

% Cria pasta para análise
fsave = [rt 'Ferramentas\Arquivos Gerados\Dissertacao_' txt 'RU+SMOTE\classification_Statistics_' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;

% Cria arquivo de log
fid = fopen([fsave, 'log.txt'], 'w');
print_logIntroSt;

%% Teste t

fsave_tTest = [fsave,'teste_t\'];

mkdir(fsave_tTest);

numIt = nnz(((N-1)'.*D/60)<=wMax)*length(M);

ppm = ParforProgressbar(numIt, 'progressBarUpdatePeriod', 5);

tTest.N = NaN; tTest.M = NaN; tTest.D = NaN; tTest.Alpha = NaN; tTest.Var = ""; 
tTest.ROC_AUC_Train = NaN; tTest.fselBeta_Train = NaN; tTest.MMC_Train = NaN;
tTest.ROC_AUC_Test = NaN; tTest.fselBeta_Test = NaN; tTest.MMC_Test = NaN;

lenN = length(N); lenM = length(M); lenD = length(D); lenV = length(vars); lenALPHA = length(ALPHA);

tTestAn = repmat(tTest, lenN, lenM, lenD, lenV, lenALPHA);

if numel(conjVal) == 1
    indTest = cell(lenN,lenM,lenD, lenV);
end

cstart = clock;
tTest_printStart;

clear tTest;

tTst = []
parfor n = 1:lenN
% for n = 1:lenN
    for m = 1:lenM
        for d = 1:lenD
            
            if ((N(n)-1)*D(d)/60)>wMax
                continue
            end
            for v = 1:lenV
                 if numel(conjVal) == 1
                    [Ttrain,Xtrain,Ytrain,Xtest,Ytest,indTest{n,m,d,v}] = preproc_data(EnData,tEst,conjVal,N(n),M(m),D(d),Inf,vars(v),paramOvers,standardize);
                 else
                    [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N(n),M(m),D(d),Inf,vars(v),paramOvers,standardize);
                 end

                 scoreTrain = arrayfun(@(ROWIDX) lrPValue(Xtrain(ROWIDX,:)), (1:size(Xtrain,1)).');
                 scoreTest = arrayfun(@(ROWIDX) lrPValue(Xtest(ROWIDX,:)), (1:size(Xtest,1)).');


                 for a = 1:lenALPHA
                     tTestAn(n,m,d,v,a).N = N(n);
                     tTestAn(n,m,d,v,a).M = M(m);
                     tTestAn(n,m,d,v,a).D = D(d);
                     tTestAn(n,m,d,v,a).Var = vars(v);
                     tTestAn(n,m,d,v,a).Alpha = ALPHA(a);
                     predictTest = scoreTest>ALPHA(a);
                     predictTrain = scoreTrain>ALPHA(a);
                     [tTestAn(n,m,d,v,a).ROC_AUC_Train, tTestAn(n,m,d,v,a).fselBeta_Train, tTestAn(n,m,d,v,a).MMC_Train] = performanceMetrics(double(Ytrain), double(predictTrain), scoreTrain, selBeta);
                     [tTestAn(n,m,d,v,a).ROC_AUC_Test, tTestAn(n,m,d,v,a).fselBeta_Test, tTestAn(n,m,d,v,a).MMC_Test] = performanceMetrics(double(Ytest), double(predictTest), scoreTest, selBeta);
                 end
                 clear Ttrain Xtrain Xtest Ytes
             end
             ppm.increment();
        end
    end
end

delete(ppm);

cend = clock;
cel = etime(cend,cstart); cdur(1) = floor(cel/(3600)); cdur(2) = floor(rem(cel,(3600))/60); cdur(3) = rem(cel,60);

tTest_graph;

tTestAn = reshape(tTestAn,[],1);
tTestAn(isnan([tTestAn(:).ROC_AUC_Train]')) = [];
tTestAnTable = struct2table(tTestAn);

save([fsave_tTest 'results_rawMatrix'],'tTestAn');

switch selMethod % Rankeia os resultados pela métrica selecionada
    case 'ROC_AUC'
        tTestAnTable = sortrows(tTestAnTable,'ROC_AUC_Train','descend','MissingPlacement','last');
    case 'Fbeta'
        tTestAnTable = sortrows(tTestAnTable,'fselBeta_Train','descend','MissingPlacement','last');
    case 'MCC'
        tTestAnTable = sortrows(tTestAnTable,'MMC_Train','descend','MissingPlacement','last');
    otherwise
        error(['Performance metric "', selMethod,'" not recognized'])
end

save([fsave_tTest 'parameters'],'D','N','M','vars','ALPHA','selMethod','selBeta');
save([fsave_tTest 'results_rankedTable'],'tTestAnTable');

tTest_printEnd;

clear ALPHA tTestAnTable tTestAn

%%
%%%%%%%%%%%%%%% Diferença espaçada: %%%%%%%%%%%%%%

N = 2;
dMax = logspace(-10,1,41); % Maximum tolerated difference

fsave_spcDif = [fsave,'dif\'];

mkdir(fsave_spcDif);

numIt = nnz(((N-1)'.*D/60)<=wMax)*length(M);

ppm = ParforProgressbar(numIt, 'progressBarUpdatePeriod', 5);

spcDif.M = NaN; spcDif.D = NaN; spcDif.dMax = NaN; spcDif.Var = ""; 
spcDif.ROC_AUC_Train = NaN; spcDif.fselBeta_Train = NaN; spcDif.MMC_Train = NaN;
spcDif.ROC_AUC_Test = NaN; spcDif.fselBeta_Test = NaN; spcDif.MMC_Test = NaN;

lenM = length(M); lenD = length(D); lenV = length(vars); lenDmax = length(dMax);

spcDifAn = repmat(spcDif, lenM, lenD, lenV, lenDmax);

if numel(conjVal) == 1
    indTest = cell(lenM,lenD,lenV);
end

cstart = clock;
spcDif_printStart;

clear spcDif;

ds =[]

parfor m = 1:lenM
% for m = 1:lenM
    for d = 1:lenD
         if ((N-1)*D(d)/60)>wMax
             continue
         end
        for v = 1:lenV
             

             if numel(conjVal) == 1
                [Ttrain,Xtrain,Ytrain,Xtest,Ytest,indTest{m,d,v}] = preproc_data(EnData,tEst,conjVal,N,M(m),D(d),Inf,vars(v),paramOvers,standardize);
             else
                [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N,M(m),D(d),Inf,vars(v),paramOvers,standardize);
             end

              dTrain = abs(Xtrain(:,2)-Xtrain(:,1));
              dTest = abs(Xtest(:,2)-Xtest(:,1));
              scoreTrain = rescale([-Inf;Inf;dTrain],'InputMin',min(dMax),'InputMax',max(dMax)); scoreTrain = scoreTrain(3:end);
              scoreTest = rescale([-Inf;Inf;dTest],'InputMin',min(dMax),'InputMax',max(dMax)); scoreTest = scoreTest(3:end);

              for dm = 1:lenDmax
                  spcDifAn(m,d,v,dm).M = M(m);
                  spcDifAn(m,d,v,dm).D = D(d);
                  spcDifAn(m,d,v,dm).Var = vars(v);
                  spcDifAn(m,d,v,dm).dMax = dMax(dm);
                  predictTrain = dTrain<dMax(dm);
                  predictTest = dTest<dMax(dm);
                  [spcDifAn(m,d,v,dm).ROC_AUC_Train, spcDifAn(m,d,v,dm).fselBeta_Train, spcDifAn(m,d,v,dm).MMC_Train] = performanceMetrics(double(Ytrain), double(predictTrain), scoreTrain, selBeta);
                  [spcDifAn(m,d,v,dm).ROC_AUC_Test, spcDifAn(m,d,v,dm).fselBeta_Test, spcDifAn(m,d,v,dm).MMC_Test] = performanceMetrics(double(Ytest), double(predictTest), scoreTest, selBeta);
              end

         end
         ppm.increment();
    end
end

delete(ppm);

cend = clock;
cel = etime(cend,cstart); cdur(1) = floor(cel/(3600)); cdur(2) = floor(rem(cel,(3600))/60); cdur(3) = rem(cel,60);

spcDif_graph;

spcDifAn = reshape(spcDifAn,[],1);
spcDifAn(isnan([spcDifAn(:).ROC_AUC_Train]')) = [];
spcDifAnTable = struct2table(spcDifAn);

save([fsave_spcDif 'results_rawMatrix'],'spcDifAn','-v7.3');

switch selMethod % Rankeia os resultados pela métrica selecionada
    case 'ROC_AUC'
        spcDifAnTable = sortrows(spcDifAnTable,'ROC_AUC_Train','descend','MissingPlacement','last');
    case 'Fbeta'
        spcDifAnTable = sortrows(spcDifAnTable,'fselBeta_Train','descend','MissingPlacement','last');
    case 'MCC'
        spcDifAnTable = sortrows(spcDifAnTable,'MMC_Train','descend','MissingPlacement','last');
    otherwise
        error(['Performance metric "', selMethod,'" not recognized'])
end

save([fsave_spcDif 'parameters'],'D','M','vars','dMax','selMethod','selBeta');
save([fsave_spcDif 'results_rankedTable'],'spcDifAnTable');

spcDif_printEnd;

clear dMax spcDifAnTable spcDifAn

%%
%%%%%%%%%%%%%%% Estatística R (heurística): %%%%%%%%%%%%%%

L1 = 0.02:0.04:0.8; % lambda1 values (Exponential average weight for data)
L2 = 0.05:0.05:0.8; % lambda2 values (Exponential average weight for variance numerator)
L3 = 0.01:0.02:0.8; % lambda3 values (Exponential average weight for variance denominator)
Rc = [1:0.01:3, 3.2:0.2:5]; % Critical R value

% L1 = 0.02:0.5:0.82; % lambda1 values (Exponential average weight for data)
% L2 = 0.05:0.5:0.85; % lambda2 values (Exponential average weight for variance numerator)
% L3 = 0.01:0.5:0.81; % lambda3 values (Exponential average weight for variance denominator)
% Rc = 1:0.5:4; % Critical R value

lenL1 = length(L1);
lenL2 = length(L2);
lenL3 = length(L3);
lenRc = length(Rc);

fsave_rStH = [fsave,'rStH\'];

mkdir(fsave_rStH);

numIt = lenL1*lenL2*lenL3*lenV;

ppm = ParforProgressbar(numIt, 'progressBarUpdatePeriod', 5);

rStH.L1 = NaN; rStH.L2 = NaN; rStH.L3 = NaN; rStH.Rc = NaN; spcDif.Var = ""; 
rStH.ROC_AUC_Train = NaN; rStH.fselBeta_Train = NaN; rStH.MMC_Train = NaN;
rStH.ROC_AUC_Test = NaN; rStH.fselBeta_Test = NaN; rStH.MMC_Test = NaN;

rStHAn = repmat(rStH, lenV, lenL1, lenL2, lenL3, lenRc);

if numel(conjVal) == 1
    indTest = cell(lenV, lenL1, lenL2, lenL3);
end

cstart = clock;
rStH_printStart;

clear rStH;

Rh = []
% for v = 1:lenV
parfor v = 1:lenV
    for l1 = 1:lenL1
        for l2 = 1:lenL2
            for l3 = 1:lenL3
                [Rtrain,Ytrain,Rtest,Ytest] = rStats_preproc_data(EnData,tEst,L1(l1),L2(l2),L3(l3),conjVal,vars(v));
                
                scoreTrain = rescale([-Inf;Inf;Rtrain],'InputMin',min(Rc),'InputMax',max(Rc)); scoreTrain = scoreTrain(3:end);
                scoreTest = rescale([-Inf;Inf;Rtest],'InputMin',min(Rc),'InputMax',max(Rc)); scoreTest = scoreTest(3:end);
                
                for r = 1:lenRc
                    rStHAn(v,l1,l2,l3,r).Rc = Rc(r);
                    rStHAn(v,l1,l2,l3,r).L1 = L1(l1);
                    rStHAn(v,l1,l2,l3,r).L2 = L2(l2);
                    rStHAn(v,l1,l2,l3,r).L3 = L3(l3);
                    rStHAn(v,l1,l2,l3,r).Var = vars(v);
                    predictTrain = Rtrain<Rc(r);
                    predictTest = Rtest<Rc(r);
                    [rStHAn(v,l1,l2,l3,r).ROC_AUC_Train, rStHAn(v,l1,l2,l3,r).fselBeta_Train, rStHAn(v,l1,l2,l3,r).MMC_Train] = performanceMetrics(double(Ytrain), double(predictTrain), scoreTrain, selBeta);
                    [rStHAn(v,l1,l2,l3,r).ROC_AUC_Test, rStHAn(v,l1,l2,l3,r).fselBeta_Test, rStHAn(v,l1,l2,l3,r).MMC_Test] = performanceMetrics(double(Ytest), double(predictTest), scoreTest, selBeta);
                end
                ppm.increment();
            end
        end
    end
end

delete(ppm);

cend = clock;
cel = etime(cend,cstart); cdur(1) = floor(cel/(3600)); cdur(2) = floor(rem(cel,(3600))/60); cdur(3) = rem(cel,60);

rStH_graph;

rStHAn = reshape(rStHAn,[],1);
rStHAn(isnan([rStHAn(:).ROC_AUC_Train]')) = [];
rStHAnTable = struct2table(rStHAn);

save([fsave_rStH 'results_rawMatrix'],'rStHAn','-v7.3');

switch selMethod % Rankeia os resultados pela métrica selecionada
    case 'ROC_AUC'
        rStHAnTable = sortrows(rStHAnTable,'ROC_AUC_Train','descend','MissingPlacement','last');
    case 'Fbeta'
        rStHAnTable = sortrows(rStHAnTable,'fselBeta_Train','descend','MissingPlacement','last');
    case 'MCC'
        rStHAnTable = sortrows(rStHAnTable,'MMC_Train','descend','MissingPlacement','last');
    otherwise
        error(['Performance metric "', selMethod,'" not recognized'])
end

save([fsave_rStH 'parameters'],'L1','L2','L3','Rc','vars','selMethod','selBeta');
save([fsave_rStH 'results_rankedTable'],'rStHAnTable');

rStH_printEnd;

clear L1 L2 L3 Rc rStHAnTable rStHAn

%%
%%%%%%%%%%%%%%% Estatística R (tabela): %%%%%%%%%%%%%%

L1 = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5]; % lambda1 values (Exponential average weight for data)
L23 = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5]; % lambda2 and lambda3 values (Exponential average weights for variance)
ALPHA = [0.01 0.05 0.1 0.25 0.5]; % Significance level

lenL1 = length(L1);
lenL23 = length(L23);
lenALPHA = length(ALPHA);

fsave_rStTb = [fsave,'rStTb\'];

mkdir(fsave_rStTb);

numIt = lenL1*lenL23*lenV;

T = load('criticalR.mat','T'); % Loads the critical R values table (T);
T = T.T;

ppm = ParforProgressbar(numIt, 'progressBarUpdatePeriod', 5);

rStTb.L1 = NaN; rStTb.L23 = NaN; rStTb.Alpha = NaN; spcDif.Var = ""; 
rStTb.ROC_AUC_Train = NaN; rStTb.fselBeta_Train = NaN; rStTb.MMC_Train = NaN;
rStTb.ROC_AUC_Test = NaN; rStTb.fselBeta_Test = NaN; rStTb.MMC_Test = NaN;

rStTbAn = repmat(rStTb, lenV, lenL1, lenL23, lenALPHA);

if numel(conjVal) == 1
    indTest = cell(lenV, lenL1, lenL23);
end

cstart = clock;
rStTb_printStart;

clear rStTb;
Rtb = []
parfor v = 1:lenV
% for v = 1:lenV
    for l1 = 1:lenL1
        for l23 = 1:lenL23
            [Rtrain,Ytrain,Rtest,Ytest] = rStats_preproc_data(EnData,tEst,L1(l1),L23(l23),L23(l23),conjVal,vars(v));

            scoreTrain = rescale([-Inf;Inf;Rtrain],'InputMin',min(T(:,5)),'InputMax',max(T(:,5))); scoreTrain = scoreTrain(3:end);
            scoreTest = rescale([-Inf;Inf;Rtest],'InputMin',min(T(:,5)),'InputMax',max(T(:,5))); scoreTest = scoreTest(3:end);

            for a = 1:lenALPHA
                Rc = T(T(:,1)==L1(l1) & T(:,2)==L23(l23) & T(:,3)==L23(l23) & T(:,4)==ALPHA(a),5);
                rStTbAn(v,l1,l23,a).Alpha = ALPHA(a);
                rStTbAn(v,l1,l23,a).L1 = L1(l1);
                rStTbAn(v,l1,l23,a).L23 = L23(l23);
                rStTbAn(v,l1,l23,a).Var = vars(v);
                predictTrain = Rtrain<Rc;
                predictTest = Rtest<Rc;
                [rStTbAn(v,l1,l23,a).ROC_AUC_Train, rStTbAn(v,l1,l23,a).fselBeta_Train, rStTbAn(v,l1,l23,a).MMC_Train] = performanceMetrics(double(Ytrain), double(predictTrain), scoreTrain, selBeta);
                [rStTbAn(v,l1,l23,a).ROC_AUC_Test, rStTbAn(v,l1,l23,a).fselBeta_Test, rStTbAn(v,l1,l23,a).MMC_Test] = performanceMetrics(double(Ytest), double(predictTest), scoreTest, selBeta);
            end
            ppm.increment();
        end
    end
end

delete(ppm);

cend = clock;
cel = etime(cend,cstart); cdur(1) = floor(cel/(3600)); cdur(2) = floor(rem(cel,(3600))/60); cdur(3) = rem(cel,60);

rStTb_graph;

rStTbAn = reshape(rStTbAn,[],1);
rStTbAn(isnan([rStTbAn(:).ROC_AUC_Train]')) = [];
rStTbAnTable = struct2table(rStTbAn);

save([fsave_rStTb 'results_rawMatrix'],'rStTbAn','-v7.3');

switch selMethod % Rankeia os resultados pela métrica selecionada
    case 'ROC_AUC'
        rStTbAnTable = sortrows(rStTbAnTable,'ROC_AUC_Train','descend','MissingPlacement','last');
    case 'Fbeta'
        rStTbAnTable = sortrows(rStTbAnTable,'fselBeta_Train','descend','MissingPlacement','last');
    case 'MCC'
        rStTbAnTable = sortrows(rStTbAnTable,'MMC_Train','descend','MissingPlacement','last');
    otherwise
        error(['Performance metric "', selMethod,'" not recognized'])
end

save([fsave_rStTb 'parameters'],'L1','L23','ALPHA','vars','selMethod','selBeta');
save([fsave_rStTb 'results_rankedTable'],'rStTbAnTable');

rStTb_printEnd;

clear L1 L23 ALPHA rStTbAnTable rStTbAn

fclose(fid);