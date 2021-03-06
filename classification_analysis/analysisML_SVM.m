% Análise de hiperparâmetros - SVM

analysisML.kernelFunction = NaN; analysisML.kernelScale = NaN;
analysisML.ROC_AUC_Train = NaN; analysisML.fselBeta_Train = NaN; analysisML.MMC_Train = NaN; analysisML.time_Train = NaN;
analysisML.ROC_AUC_Test = NaN; analysisML.fselBeta_Test = NaN; analysisML.MMC_Test = NaN;

len1 = length(paramMLBusca{1});
len2 = length(paramMLBusca{2});
analysisMLAn = repmat(analysisML,len1,len2);

numIt = len1*len2;

ppm = ParforProgressbar(numIt, 'progressBarUpdatePeriod', 5);

parfor k1 = 1:len1
    for k2 = 1:len2
        paramMLTemp = {paramMLBusca{1}(k1),paramMLBusca{2}(k2)};
        analysisMLAn(k1,k2).kernelFunction = paramMLBusca{1}(k1);
        analysisMLAn(k1,k2).kernelScale = paramMLBusca{2}(k2);
        
        [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,varsSel);

        [trainedClassifier,predictTrain,scoreTrain,timeTrain] = train_ML(Ttrain, methodML, kFold, paramMLTemp);

        analysisMLAn(k1,k2).time_Train = timeTrain;

        [predictTest,scoreTest] = trainedClassifier.predict(Xtest);

        [analysisMLAn(k1,k2).ROC_AUC_Train, analysisMLAn(k1,k2).fselBeta_Train, analysisMLAn(k1,k2).MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
        [analysisMLAn(k1,k2).ROC_AUC_Test, analysisMLAn(k1,k2).fselBeta_Test, analysisMLAn(k1,k2).MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);

        ppm.increment();
    end
end

delete(ppm);