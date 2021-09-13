function [trainedClassifier, prediction, score, time] = train_ML_RegLog(trainingData, folds)
%  TRAIN_ML_REGLOG Treina um classificador por regressão logística
%  Input:
%      trainingData: tabela com preditores e resposta. A resposta deve ser
%      a última coluna à direita.
%
%      folds: número de folds da validação cruzada (k-fold)
%           
%
%  Output:
%      trainedClassifier: estrutura com o modelo treinado.
%           trainedClassifier.model:      modelo de classificador
%           trainedClassifier.method:     método ('logReg')
%           trainedClassifier.predict:    função para predições
%           
%      prediction: predição para o conjunto de treino na validação cruzada.
%
%      score: score da classificação "1" (amaciado) na validação cruzada 
%        (quando folds > 1), ou score de predição com o conjunto de treino 
%        (quando folds ==1).
%
%      time: tempo decorrido para treinamento do modelo [s].
% 
%     Gabriel Thaler, 2021
%   thalergabriel@gmail.com

if nargin < 2
    folds = 5;
end


predictorNames = trainingData.Properties.VariableNames(1:end-1);

predictors = trainingData{:, 1:(end-1)};
response = double(categorical(trainingData{:, end}));

c1 = clock;
[B,~,trainedClassifier.model] = mnrfit(predictors,response); % Treina o modelo
c2 = clock;
time = etime(c2,c1);

trainedClassifier.model.X = trainingData(:, 1:(end-1));
trainedClassifier.model.beta = B;
trainedClassifier.model.Y = response;
trainedClassifier.model.PredictorNames = predictorNames;
trainedClassifier.model.ClassNames = [0;1];
trainedClassifier.method = 'logReg';

trainedClassifier.predict = @(x) predictFromModel(trainedClassifier.model.beta,x);

predictors = trainingData{:, 1:(end-1)};

[prediction,score] = trainedClassifier.predict(predictors);

if folds>1
    cvp = cvpartition(height(trainingData),'KFold',folds);
    score = nan(size(score));
    prediction = nan(size(prediction));
    for k=1:folds
        [partitionedClassifier,~,~] = train_ML_RegLog(trainingData(cvp.training(k), :), 1);
        [predictionTemp,scoreTemp] = partitionedClassifier.predict(predictors);
        score(cvp.test(k)) = scoreTemp(cvp.test(k));
        prediction(cvp.test(k)) = predictionTemp(cvp.test(k));
    end
end

end
    
function [prediction,score] = predictFromModel(B, x)

score = mnrval(B,x);
score = score(:,2);
prediction = score>0.5;
prediction = double(prediction);

end
