% Poda extensiva

featSel.Vars = {};
featSel.ROC_AUC_Train = NaN; featSel.fselBeta_Train = NaN; featSel.MMC_Train = NaN; featSel.time_Train = NaN;
featSel.ROC_AUC_Test = NaN; featSel.fselBeta_Test = NaN; featSel.MMC_Test = NaN;

allVars = {''};
for k = 1:length(vars)
    allVars = appendCell(allVars,{'',vars{k}});
end

lenVars = length(allVars);

for k = lenVars:-1:1
    if isempty(allVars{k})
        allVars(k) = [];
    end
end

lenVars = length(allVars);
ppm = ParforProgressbar(lenVars, 'progressBarUpdatePeriod', 5);

featSelAn = repmat(featSel,length(allVars),1);

clear featSel;

parfor v = 1:lenVars
     featSelAn(v).Vars = allVars{v};

     [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,featSelAn(v).Vars);
     [trainedClassifier,predictTrain,scoreTrain,timeTrain] = train_ML(Ttrain, methodML, kFold, paramML);
     
     featSelAn(v).time_Train = timeTrain;

     [predictTest,scoreTest] = trainedClassifier.predict(Xtest);

     [featSelAn(v).ROC_AUC_Train, featSelAn(v).fselBeta_Train, featSelAn(v).MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
     [featSelAn(v).ROC_AUC_Test, featSelAn(v).fselBeta_Test, featSelAn(v).MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);
     
     ppm.increment();
end

delete(ppm);