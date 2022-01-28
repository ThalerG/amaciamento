function [trainedClassifier,predictTrain, scoreTrain, timeTrain] = train_ML(Ttrain,methodML, folds, paramML)
%TRAIN_ML Treina um modelo para os dados do amaciamento
%   Detailed explanation goes here

rng(10)

switch methodML
    case 'logReg'
        [trainedClassifier, predictTrain, scoreTrain, timeTrain] = train_ML_RegLog(Ttrain, folds);
    case 'tree'
        [trainedClassifier, predictTrain, scoreTrain, timeTrain] = train_ML_Tree(Ttrain, paramML{1}, folds);
    case 'SVM'
        if length(paramML)<3
            paramML{3} = 1;
        end
        [trainedClassifier, predictTrain, scoreTrain, timeTrain] = train_ML_SVM(Ttrain, paramML{1}, paramML{2}, folds, paramML{3});
    case 'KNN'
        [trainedClassifier, predictTrain, scoreTrain, timeTrain] = train_ML_KNN(Ttrain,paramML{1}, paramML{2}, paramML{3}, folds);
    otherwise
        error(['Model "',methodML,'" not recognized'])
end

end

