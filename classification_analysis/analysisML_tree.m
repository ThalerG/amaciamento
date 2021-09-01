% Análise de hiperparâmetros - Árvore

paramMLBusca = {maxSplitsBusca};
analysisML.maxSplits = NaN;
analysisML.ROC_AUC_Train = NaN; analysisML.fselBeta_Train = NaN; analysisML.MMC_Train = NaN; analysisML.time_Train = NaN;
analysisML.ROC_AUC_Test = NaN; analysisML.fselBeta_Test = NaN; analysisML.MMC_Test = NaN;

len1 = length(paramMLBusca{1});
analysisMLAn = repmat(analysisML,len1,1);

numIt = len1;

ppm = ParforProgressbar(numIt, 'progressBarUpdatePeriod', 5);

parfor k1 = 1:len1
    paramMLTemp = {paramMLBusca{1}(k1)};
    analysisMLAn(k1).maxSplits = paramMLBusca{1}(k1);
    
    [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,varsSel,paramOvers,standardize);

    [trainedClassifier,predictTrain,scoreTrain,timeTrain] = train_ML(Ttrain, methodML, kFold, paramMLTemp);

    analysisMLAn(k1).time_Train = timeTrain;

    [predictTest,scoreTest] = trainedClassifier.predict(Xtest);

    [analysisMLAn(k1).ROC_AUC_Train, analysisMLAn(k1).fselBeta_Train, analysisMLAn(k1).MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
    [analysisMLAn(k1).ROC_AUC_Test, analysisMLAn(k1).fselBeta_Test, analysisMLAn(k1).MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);

    ppm.increment();
end
    
delete(ppm);