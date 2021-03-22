clear all; close all; clc;

fDavg = "D:\Documentos\Amaciamento\Ferramentas\Arquivos Gerados\doubleAvg_parameters201020_1212\Results.mat";
fLogr = "D:\Documentos\Amaciamento\Ferramentas\Arquivos Gerados\logR_parameters201020_1314\Results.mat";
fLinr = "D:\Documentos\Amaciamento\Ferramentas\Arquivos Gerados\linRegression_parameters201020_1213\Results.mat";
fSpcd = "D:\Documentos\Amaciamento\Ferramentas\Arquivos Gerados\spacedDif_parameters201020_1307\Results.mat";
fRstt = "D:\Documentos\Amaciamento\Ferramentas\Arquivos Gerados\rStatisticsH_parameters201020_1301\Results.mat";

maxFPR = 0.04;

%% Smallest norm
% % 
% Double Average

rDavg = load(fDavg);
[ind,thrInd,TPRMax,FPRMin] = bestByFPR(rDavg.Res,maxFPR);

if ~isnan(ind)
    [mInd(1), mInd(2)] = ind2sub(size(rDavg.Res),ind);

    davgMin.W1 = rDavg.W1(mInd(1));
    davgMin.W2 = rDavg.W2(mInd(2));
    davgMin.S = rDavg.S(thrInd);
    davgMin.TPR = TPRMax; davgMin.FPR = FPRMin;
else
    davgMin.W1 = NaN;
    davgMin.W2 = NaN;
    davgMin.S = NaN;
    davgMin.TPR = NaN; davgMin.FPR = NaN;
end

clear rDavg;
%% 
% % 
% Logistic Regression

rLogr = load(fLogr);
[ind,thrInd,TPRMax,FPRMin] = bestByFPR(rLogr.Res,maxFPR);

if ~isnan(ind)
    [mInd(1), mInd(2), mInd(3)] = ind2sub(size(rLogr.Res),ind);

    logrMin.N = rLogr.N(mInd(1));
    logrMin.M = rLogr.M(mInd(2));
    logrMin.D = rLogr.D(mInd(3));
    logrMin.thr = rLogr.thr(thrInd);
    logrMin.TPR = TPRMax; logrMin.FPR = FPRMin;
else
    logrMin.N = NaN;
    logrMin.M = NaN;
    logrMin.D = NaN;
    logrMin.thr = NaN;
    logrMin.TPR = NaN; logrMin.FPR = NaN;
end

clear rLogr;
%% 
% % 
% Linear regression

rLinr = load(fLinr);
[ind,thrInd,TPRMax,FPRMin] = bestByFPR(rLinr.Res,maxFPR);

[mInd(1), mInd(2), mInd(3)] = ind2sub(size(rLinr.Res),ind);

if ~isnan(ind)
    linrMin.N = rLinr.N(mInd(1));
    linrMin.M = rLinr.M(mInd(2));
    linrMin.D = rLinr.D(mInd(3));
    linrMin.ALPHA = rLinr.ALPHA(thrInd);
    linrMin.TPR = TPRMax; linrMin.FPR = FPRMin;
else
    linrMin.N = NaN;
    linrMin.M = NaN;
    linrMin.D = NaN;
    linrMin.ALPHA = NaN;
    linrMin.TPR = NaN; linrMin.FPR = NaN;
end

clear rLinr;
%% 
% % 
% Spaced Difference

rSpcd = load(fSpcd);
[ind,thrInd,TPRMax,FPRMin] = bestByFPR(rSpcd.Res,maxFPR);

if ~isnan(ind)
    [mInd(1), mInd(2), mInd(3)] = ind2sub(size(rSpcd.Res),ind);

    spcdMin.W1 = rSpcd.W1(mInd(1));
    spcdMin.N = rSpcd.N(mInd(2));
    spcdMin.W2 = rSpcd.W2(mInd(3));
    spcdMin.S = rSpcd.S(thrInd);
    spcdMin.TPR = TPRMax; spcdMin.FPR = FPRMin;
else
    spcdMin.W1 = NaN;
    spcdMin.N = NaN;
    spcdMin.W2 = NaN;
    spcdMin.S = NaN;
    spcdMin.TPR = NaN; spcdMin.FPR = NaN;
end

clear rSpcd;
%% 
% % 
% R-statistics

rRstt = load(fRstt);
[ind,thrInd,TPRMax,FPRMin] = bestByFPR(rRstt.Res,maxFPR);

if ~isnan(ind)
    [mInd(1), mInd(2), mInd(3)] = ind2sub(size(rRstt.Res),ind);

    rsttMin.L1 = rRstt.L1(mInd(1));
    rsttMin.L2 = rRstt.L2(mInd(2));
    rsttMin.L3 = rRstt.L3(mInd(3));
    rsttMin.Rc = rRstt.Rc(thrInd);
    rsttMin.TPR = TPRMax; rsttMin.FPR = FPRMin;
else
    rsttMin.L1 = NaN;
    rsttMin.L2 = NaN;
    rsttMin.L3 = NaN;
    rsttMin.Rc = NaN;
    rsttMin.TPR = NaN; rsttMin.FPR = NaN;
end

clear rRstt;
%% 
% % 
% Compare table

meth = {'Double Average', 'Linear Regression (p-value)', 'Logistic Regression', 'Spaced Difference', 'R-statistics'}';
MTPR = [davgMin.TPR, linrMin.TPR, logrMin.TPR, spcdMin.TPR, rsttMin.TPR]';
MFPR = [davgMin.FPR, linrMin.FPR, logrMin.FPR, spcdMin.FPR, rsttMin.FPR]';
T_FPR = table(meth,MTPR, MFPR, 'VariableNames', {'Method','MaxTPR','MinFPR'});

%% Test data

rDavg = load(fDavg);
conjVal = rDavg.conjVal;
clear rDavg;

load("EnDataA.mat");
load("tEstA.mat");

for k1 = 1:size(conjVal,1) % Apaga os valores dos conjuntos de validação
    tEstTest{k1} = tEst{conjVal(k1,1)}(conjVal(k1,2));
    EnDataTest{k1} = EnData{conjVal(k1,1)}(conjVal(k1,2));
end

%% 
% % 
% Double Average

if ~isnan(davgMin.FPR)
    classReal = [];
    classPred = [];

    minT = 10;

    for k1 = 1:length(EnDataTest)
        tempData = EnDataTest{k1}.cRMS((EnDataTest{k1}.tempo<max([minT,2*tEstTest{k1}])) & (EnDataTest{k1}.tempo>0));
        tempTempo = EnDataTest{k1}.tempo((EnDataTest{k1}.tempo<max([minT,2*tEstTest{k1}])) & (EnDataTest{k1}.tempo>0));

        [amaciadoTemp,tempTempo] = dAvg_detect_ensaio(tempData,davgMin.W1,davgMin.W2,davgMin.S,tempTempo);
        classReal = [classReal;tempTempo>=tEstTest{k1}];
        classPred = [classPred;amaciadoTemp];
    end

    cMat = confusionmat(classReal,classPred);
    davgMin.testTPR = cMat(1,1)/sum(cMat(:,1));
    davgMin.testFPR = cMat(1,2)/sum(cMat(:,2));
else
    davgMin.testTPR = NaN;
    davgMin.testFPR = NaN;
end

%% 
% % 
% Logistic Regression

if ~isnan(logrMin.FPR)
    load('EnDataA.mat');
    load('tEstA.mat')


    for k1 = 1:size(conjVal,1) % Apaga os valores dos conjuntos de validação
        tEst{conjVal(k1,1)}(conjVal(k1,2)) = [];
        EnData{conjVal(k1,1)}(conjVal(k1,2)) = [];
    end

    minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)

    [Xobs,Yres] = preTrain(EnData,tEst,logrMin.N,logrMin.M,logrMin.D,minT);

    B = treinaMnrfit(Xobs,Yres);


    [Xtest,classReal] = preTrain(EnDataTest,tEstTest,logrMin.N,logrMin.M,logrMin.D,minT);
    clear EnData tEst minT

    prob = mnrval(B,Xtest);
    prob = prob(:,2);

    classPred = prob>=logrMin.thr;

    cMat = confusionmat(classReal,classPred);
    logrMin.testTPR = cMat(1,1)/sum(cMat(:,1));
    logrMin.testFPR = cMat(1,2)/sum(cMat(:,2));

    clear classPred classReal cMat prob B Xtest Yres Xobs;
else
    logrMin.testTPR = NaN;
    logrMin.testFPR = NaN;
end
%% 
% % 
% Linear regression

if ~isnan(linrMin.FPR)
    classReal = [];
    classPred = [];
    minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)
    [Xtest,classReal] = preTrain(EnDataTest,tEstTest,linrMin.N,linrMin.M,linrMin.D,minT);

    for k = 1:size(Xtest,1)
        p(k) = lrPValue(Xtest(k,:));
    end

    classPred = p>=linrMin.ALPHA;

    cMat = confusionmat(classReal,classPred);
    linrMin.testTPR = cMat(1,1)/sum(cMat(:,1));
    linrMin.testFPR = cMat(1,2)/sum(cMat(:,2));

    clear Xtest classReal cMat classPred p;
else
    linrMin.testTPR = NaN;
    linrMin.testFPR = NaN;
end

%% 
% % 
% Spaced Difference

if ~isnan(spcdMin.FPR)
    classReal = [];
    classPred = [];

    minT = 10;

    for k1 = 1:length(EnDataTest)
        tempData = EnDataTest{k1}.cRMS(EnDataTest{k1}.tempo>0);
        tempTempo = EnDataTest{k1}.tempo(EnDataTest{k1}.tempo>0);

        [d2, tempTempo] = spacedDiff(tempData,spcdMin.W1,spcdMin.N,spcdMin.W2,tempTempo, tEstTest{k1}, minT);
        classReal = [classReal;tempTempo>=tEstTest{k1}];
        classPred = [classPred;d2<=spcdMin.S];
    end

    cMat = confusionmat(classReal,classPred);
    spcdMin.testTPR = cMat(1,1)/sum(cMat(:,1));
    spcdMin.testFPR = cMat(1,2)/sum(cMat(:,2));

    clear cMat minT tempData tempTempo classReal classPred d2 tempo;
else
    spcdMin.testTPR = NaN;
    spcdMin.testFPR = NaN;
end
%% 
% R-statistics

if ~isnan(rsttMin.FPR)
    classReal = [];
    classPred = [];

    minT = 10;

    for k1 = 1:length(EnDataTest)
        tempData = EnDataTest{k1}.cRMS(EnDataTest{k1}.tempo>0);
        tempTempo = EnDataTest{k1}.tempo(EnDataTest{k1}.tempo>0);
        [Ren,tempTempo] = Rstats_ratio_gridSearch(tempData,rsttMin.L1,rsttMin.L2,rsttMin.L3,tEstTest{k1}, minT,tempTempo); % R-stats per instant   
        classReal = [classReal;tempTempo>=tEstTest{k1}];
        classPred = [classPred;(Ren<=rsttMin.Rc)'];
    end


    cMat = confusionmat(classReal,classPred);
    rsttMin.testTPR = cMat(1,1)/sum(cMat(:,1));
    rsttMin.testFPR = cMat(1,2)/sum(cMat(:,2));

    clear cMat minT tempData tempTempo classReal classPred Ren tempTempo
else
    rsttMin.testTPR = NaN;
    rsttMin.testFPR = NaN;
end

%% 
% % 
% Compare table

meth = {'Double Average', 'Linear Regression (p-value)', 'Logistic Regression', 'Spaced Difference', 'R-statistics'}';
TestTPR = [davgMin.testTPR, linrMin.testTPR, logrMin.testTPR, spcdMin.testTPR, rsttMin.testTPR]';
TestFPR = [davgMin.testFPR, linrMin.testFPR, logrMin.testFPR, spcdMin.testFPR, rsttMin.testFPR]';
T_FPR= table(meth,MTPR, MFPR, TestTPR, TestFPR, 'VariableNames', {'Method','MaxTPR','MinFPR','TestTPR','TestFPR'});

%% Save comparison

rt = 'D:\Documentos\Amaciamento\'; % Root folder
% rt = 'C:\Users\FEESC\Desktop\Amaciamento\'; % Root folder

% Create new folder for generated files
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\compara_resultados_FPR' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
% fsave = [rt 'Resultados\logR_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;
save([fsave 'var.mat'], 'T_FPR', 'rsttMin', 'spcdMin', 'linrMin', 'logrMin', 'davgMin');