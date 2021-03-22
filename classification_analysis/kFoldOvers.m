function [prediction, score] = kFoldOvers(trainedClassifier, folds, paramOvers)
%KFOLDOVERS Realiza valida��o cruzada por k-fold
%   [PREDICTION, SCORE] = KFOLDOVERS(TRAINEDCLASSIFIER) faz valida��o 
%   cruzada com 10 folds para o conjunto utilizado para treinar o
%   modelo TRAINEDCLASSIFIER.model, do m�todo TRAINEDCLASSIFIER.method.
%
%   [PREDICTION, SCORE] = KFOLDOVERS(TRAINEDCLASSIFIER, FOLDS) faz  
%   valida��o cruzada com FOLDS folds para o conjunto utilizado para 
%   treinar o modelo TRAINEDCLASSIFIER.model, do m�todo 
%   TRAINEDCLASSIFIER.method.
%
%   [PREDICTION, SCORE] = KFOLDOVERS(TRAINEDCLASSIFIER, FOLDS, PARAMOVERS)
%   faz valida��o cruzada com FOLDS folds para o conjunto utilizado para 
%   treinar o modelo TRAINEDCLASSIFIER.model, do m�todo 
%   TRAINEDCLASSIFIER.method.
%
%   M�todos dispon�veis para TRAINEDCLASSIFIER.method:
%         'logReg' Regress�o log�stica
%         'tree'   �rvore
%         'SVM'    SVM c�bica
%         'KNN'    K-Nearest Neighbors
%
%   M�todos dispon�veis para PARAMOVERS{1}:
%         "none"
%         "SMOTE"
%         "ADASYN"
%         "Borderline SMOTE"
%         "Safe-level SMOTE"
%
%    Se PARAMOVERS{1} ~= "none", ent�o
%         PARAMOVERS{2}   porcentagem de novas amostras geradas no
%         oversampling [%]
%         PARAMOVERS{3}   N�mero de k-neighbors
%         PARAMOVERS{4}   standardize? [logical]

if PARAMOVERS{1} == 'none'
    
else
    Xtrain = 
    C = cvpartition(
end