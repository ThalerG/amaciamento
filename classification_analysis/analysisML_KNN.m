% Análise de hiperparâmetros - KNN

analysisML.numNeighbors = NaN; analysisML.distance = NaN; analysisML.weight = NaN;
analysisML.ROC_AUC_Train = NaN; analysisML.fselBeta_Train = NaN; analysisML.MMC_Train = NaN; analysisML.time_Train = NaN;
analysisML.ROC_AUC_Test = NaN; analysisML.fselBeta_Test = NaN; analysisML.MMC_Test = NaN;

len1 = length(paramMLBusca{1});
len2 = length(paramMLBusca{2});
len3 = length(paramMLBusca{3});
analysisMLAn = repmat(analysisML,len1,len2,len3);

numIt = len1*len2*len3;

ppm = ParforProgressbar(numIt, 'progressBarUpdatePeriod', 5);

parfor k1 = 1:len1
    for k2 = 1:len2
        for k3 = 1:len3
            paramMLTemp = {paramMLBusca{1}(k1),paramMLBusca{2}{k2},paramMLBusca{3}{k3}};
            analysisMLAn(k1,k2,k3).numNeighbors = paramMLBusca{1}(k1);
            analysisMLAn(k1,k2,k3).distance = paramMLBusca{2}{k2};
            analysisMLAn(k1,k2,k3).weight = paramMLBusca{3}{k3};

            [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,varsSel,paramOvers,standardize);

            [trainedClassifier,predictTrain,scoreTrain,timeTrain] = train_ML(Ttrain, methodML, kFold, paramMLTemp);

            analysisMLAn(k1,k2,k3).time_Train = timeTrain;

            [predictTest,scoreTest] = trainedClassifier.predict(Xtest);

            [analysisMLAn(k1,k2,k3).ROC_AUC_Train, analysisMLAn(k1,k2,k3).fselBeta_Train, analysisMLAn(k1,k2,k3).MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
            [analysisMLAn(k1,k2,k3).ROC_AUC_Test, analysisMLAn(k1,k2,k3).fselBeta_Test, analysisMLAn(k1,k2,k3).MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);

            ppm.increment();
        end
    end
end

delete(ppm);