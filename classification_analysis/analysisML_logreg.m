% Regressão logística

analysisMLAn.ROC_AUC_Train = NaN; analysisMLAn.fselBeta_Train = NaN; analysisMLAn.MMC_Train = NaN; analysisMLAn.time_Train = NaN;
analysisMLAn.ROC_AUC_Test = NaN; analysisMLAn.fselBeta_Test = NaN; analysisMLAn.MMC_Test = NaN;

[Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,varsSel,paramOvers,standardize);

[trainedClassifier,predictTrain,scoreTrain,timeTrain] = train_ML(Ttrain, methodML, kFold, paramML);

analysisMLAn.time_Train = timeTrain;

[predictTest,scoreTest] = trainedClassifier.predict(Xtest);

[analysisMLAn.ROC_AUC_Train, analysisMLAn.fselBeta_Train, analysisMLAn.MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
[analysisMLAn.ROC_AUC_Test, analysisMLAn.fselBeta_Test, analysisMLAn.MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);