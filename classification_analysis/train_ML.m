function [trainedClassifier,predictTrain, scoreTrain, timeTrain] = train_ML(Ttrain,methodML, folds, paramML,paramOvers)
%TRAIN_ML Treina um modelo para os dados do amaciamento
%   Detailed explanation goes here

if nargin<5
    paramOvers{1} = "none";
end

switch methodML
    case 'logReg'
        [trainedClassifier, predictTrain, scoreTrain, timeTrain] = train_ML_RegLog(Ttrain, folds, paramOvers);
    case 'tree'
        [trainedClassifier, predictTrain, scoreTrain, timeTrain] = train_ML_Tree(Ttrain, paramML{1}, folds, paramOvers);
    case 'SVM'
        [trainedClassifier, predictTrain, scoreTrain, timeTrain] = train_ML_SVM(Ttrain, paramML{1}, paramML{2}, folds, paramOvers);
    case 'KNN'
        [trainedClassifier, predictTrain, scoreTrain, timeTrain] = train_ML_KNN(Ttrain,paramML{1}, paramML{2}, paramML{3}, folds, paramOvers);
    otherwise
        error(['Model "',methodML,'" not recognized'])
end

end

