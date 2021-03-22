function [prediction, score] = kFoldOvers(trainedClassifier, folds, paramOvers)
%KFOLDOVERS Realiza validação cruzada por k-fold
%   [PREDICTION, SCORE] = KFOLDOVERS(TRAINEDCLASSIFIER) faz validação 
%   cruzada com 10 folds para o conjunto utilizado para treinar o
%   modelo TRAINEDCLASSIFIER.model, do método TRAINEDCLASSIFIER.method.
%
%   [PREDICTION, SCORE] = KFOLDOVERS(TRAINEDCLASSIFIER, FOLDS) faz  
%   validação cruzada com FOLDS folds para o conjunto utilizado para 
%   treinar o modelo TRAINEDCLASSIFIER.model, do método 
%   TRAINEDCLASSIFIER.method.
%
%   [PREDICTION, SCORE] = KFOLDOVERS(TRAINEDCLASSIFIER, FOLDS, PARAMOVERS)
%   faz validação cruzada com FOLDS folds para o conjunto utilizado para 
%   treinar o modelo TRAINEDCLASSIFIER.model, do método 
%   TRAINEDCLASSIFIER.method.
%
%   Métodos disponíveis para TRAINEDCLASSIFIER.method:
%         'logReg' Regressão logística
%         'tree'   Árvore
%         'SVM'    SVM cúbica
%         'KNN'    K-Nearest Neighbors
%
%   Métodos disponíveis para PARAMOVERS{1}:
%         "none"
%         "SMOTE"
%         "ADASYN"
%         "Borderline SMOTE"
%         "Safe-level SMOTE"
%
%    Se PARAMOVERS{1} ~= "none", então
%         PARAMOVERS{2}   porcentagem de novas amostras geradas no
%         oversampling [%]
%         PARAMOVERS{3}   Número de k-neighbors
%         PARAMOVERS{4}   standardize? [logical]

if PARAMOVERS{1} == 'none'
    
else
    Xtrain = 
    C = cvpartition(
end