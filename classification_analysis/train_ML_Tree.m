function [trainedClassifier, prediction, score, time] = train_ML_Tree(trainingData, maxSplits, folds)
%  TRAIN_ML_TREE Treina um classificador por �rvore de decis�o
%      trainingData: tabela com preditores e resposta. A resposta deve ser
%      a �ltima coluna � direita.
%
%      maxsplits: N�mero m�ximo de splits da �rvore de decis�o
%
%      folds: n�mero de folds da valida��o cruzada (k-fold)
%           
%
%  Output:
%      trainedClassifier: estrutura com o modelo treinado.
%           trainedClassifier.model:      modelo de classificador
%           trainedClassifier.method:     m�todo ('logReg')
%           trainedClassifier.predict:    fun��o para predi��es
%           
%      prediction: predi��o para o conjunto de treino na valida��o cruzada.
%
%      score: score da classifica��o "1" (amaciado) na valida��o cruzada 
%        (quando folds > 1), ou score de predi��o com o conjunto de treino 
%        (quando folds ==1).
%
%      time: tempo decorrido para treinamento do modelo [s].
%
%     Gabriel Thaler, 2021
%   thalergabriel@gmail.com

if nargin < 3
    maxSplits = 50;
    folds = 5;
end


predictors = trainingData(:, 1:(end-1));
response = double(trainingData{:, end});

c1 = clock;
% Configura e treina a �rvore
classificationTree = fitctree(...
    predictors, ...
    response, ...
    'SplitCriterion', 'gdi', ...
    'MaxNumSplits', maxSplits, ...
    'Surrogate', 'off', ...
    'ClassNames', [0; 1]);
c2 = clock;
time = etime(c2,c1);

trainedClassifier.model = classificationTree;
trainedClassifier.method = 'tree';

trainedClassifier.predict = @(x) predictFromModel(classificationTree, x);

predictors = trainingData{:, 1:(end-1)};

[prediction,score] = trainedClassifier.predict(predictors);

if folds>1
    cvp = cvpartition(height(trainingData),'KFold',folds);
    score = nan(size(score));
    prediction = nan(size(prediction));
    for k=1:folds
        [partitionedClassifier,~,~] = train_ML_Tree(trainingData(cvp.training(k), :), maxSplits, 1);
        [predictionTemp,scoreTemp] = partitionedClassifier.predict(predictors);
        score(cvp.test(k)) = scoreTemp(cvp.test(k));
        prediction(cvp.test(k)) = predictionTemp(cvp.test(k),:);
    end
end

end

function [prediction,score] = predictFromModel(classificationTree, x)

[prediction,score,~] = predict(classificationTree, x);
score = score(:,2); % Score apenas para a classe "1" (amaciado)

end
