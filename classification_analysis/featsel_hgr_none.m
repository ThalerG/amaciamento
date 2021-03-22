% Poda greedy

featSel.Vars = {};
featSel.ROC_AUC_Train = NaN; featSel.fselBeta_Train = NaN; featSel.MMC_Train = NaN; featSel.time_Train = NaN;
featSel.ROC_AUC_Test = NaN; featSel.fselBeta_Test = NaN; featSel.MMC_Test = NaN;

featSelAn(1) = featSel;

[Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,vars);
[trainedClassifier,predictTrain,scoreTrain,timeTrain] = train_ML(Ttrain, methodML, kFold, paramML);
featSelAn(ind).time_Train = timeTrain;

[predictTest,scoreTest] = trainedClassifier.predict(Xtest);

[featSelAn(ind).ROC_AUC_Train, featSelAn(ind).fselBeta_Train, featSelAn(ind).MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
[featSelAn(ind).ROC_AUC_Test, featSelAn(ind).fselBeta_Test, featSelAn(ind).MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);

varTemp = vars;

ind = 1;

switch selMethod % Referência é o primeiro valor
    case 'ROC_AUC'
        ref = featSelAn.ROC_AUC_Train;
    case 'Fbeta'
        ref = featSelAn.fselBeta_Train;
    case 'MCC'
        ref = featSelAn.MMC_Train;
    otherwise
        error(['Performance metric "', selMethod,'" not recognized'])
end

while true
     
     for k = 1:length(varTemp)
         ind = ind + 1;
         
         featSelAn(ind) = featSel;
         
         featSelAn(ind).Vars = varTemp;
         featSelAn(ind).Vars(k) = [];
         
         [Ttrain,Xtrain,Ytrain,Xtest,Ytest] = preproc_data(EnData,tEst,conjVal,N,M,D,Inf,featSelAn(ind).Vars(k));
         
         [trainedClassifier,predictTrain,scoreTrain,timeTrain] = train_ML(Ttrain, methodML, kFold, param);
         featSelAn(ind).time_Train = timeTrain;

         [predictTest,scoreTest] = trainedClassifier.predict(Xtest);

         [featSelAn(ind).ROC_AUC_Train, featSelAn(ind).fselBeta_Train, featSelAn(ind).MMC_Train] = performanceMetrics(double(Ytrain), predictTrain, scoreTrain, selBeta);
         [featSelAn(ind).ROC_AUC_Test, featSelAn(ind).fselBeta_Test, featSelAn(ind).MMC_Test] = performanceMetrics(double(Ytest), predictTest, scoreTest, selBeta);
         
     end
     lastTable = array2table(featSelAn((end-length(varTemp)):end));
     
     switch selMethod % Rankeia os resultados pela métrica selecionada
        case 'ROC_AUC'
            lastTable = sortrows(lastTable,'ROC_AUC_Train','descend');
            if lastTable(1).ROC_AUC_Train > ref
                ref = lastTable(1).ROC_AUC_Train;
                varTemp = lastTable(1).Vars;
            else
                break;
            end
        case 'Fbeta'
            lastTable = sortrows(lastTable,'fselBeta_Train','descend');
            if lastTable(1).fselBeta_Train > ref
                ref = lastTable(1).fselBeta_Train;
                varTemp = lastTable(1).Vars;
            else
                break;
            end
        case 'MCC'
            lastTable = sortrows(lastTable,'MMC_Train','descend');
            if lastTable(1).MMC_Train > ref
                ref = lastTable(1).MMC_Train;
                varTemp = lastTable(1).Vars;
            else
                break;
            end
        otherwise
            error(['Performance metric "', selMethod,'" not recognized'])
     end
end