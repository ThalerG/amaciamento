function [trainedClassifier, prediction, score, time] = train_ML_SVM(trainingData, kernelFunction, kernelScale, folds)
%  TRAIN_ML_KNN Treina um classificador K-Nearest Neighbors
%  Input:
%      trainingData: tabela com preditores e resposta. A resposta deve ser
%      a última coluna à direita.
%
%      numNeighbors: Número de neighbors para o modelo KNN (padrão é 10)
%
%      kernelFunction: 
%       
%      kernelScale: 
%      
%      folds: número de folds da validação cruzada (k-fold)
%           
%           
%  Output:
%      trainedClassifier: estrutura com o modelo treinado.
%           trainedClassifier.model:      modelo de classificador
%           trainedClassifier.method:     método ('KNN')
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
    kernelFunction = 'linear';
    folds = 5;
end

if nargin < 3
    kernelScale = 'auto';
end

if nargin < 4
    folds = 5;
end


switch kernelFunction
    case 'linear'
        kFun = 'linear';
        fOrder = [];
    case 'quadratic'
        kFun = 'polynomial';
        fOrder = 2;
    case 'cubic'
        kFun = 'polynomial';
        fOrder = 3;
    case 'gaussian'
        kFun = 'gaussian';
        fOrder = [];
    otherwise
        error(['SVM kernel function "',kernelFunction,'" not recognized'])
end

predictors = trainingData(:, 1:(end-1));
response = double(trainingData{:, end});

c1 = clock;
% Configura e treina o SVM
classificationSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', kFun, ...
    'PolynomialOrder', fOrder, ...
    'KernelScale', kernelScale, ...
    'BoxConstraint', 1, ...
    'CacheSize', 4000, ...
    'Standardize', true, ...
    'ClassNames', [0; 1]);
c2 = clock;
time = etime(c2,c1);

trainedClassifier.model = classificationSVM;
trainedClassifier.method = 'SVM';

trainedClassifier.predict = @(x) predictFromModel(classificationSVM, x);

predictors = trainingData{:, 1:(end-1)};

[prediction,score] = trainedClassifier.predict(predictors);

if folds>1
    cvp = cvpartition(height(trainingData),'KFold',folds);
    score = nan(size(score));
    prediction = nan(size(prediction));
    for k=1:folds
        [partitionedClassifier,~,~] = train_ML_SVM(trainingData(cvp.training(k), :), kernelFunction, kernelScale, 1);
        [predictionTemp,scoreTemp] = partitionedClassifier.predict(predictors);
        score(cvp.test(k)) = scoreTemp(cvp.test(k));
        prediction(cvp.test(k)) = predictionTemp(cvp.test(k),:);
    end
end

end

function [prediction,score] = predictFromModel(classificationSVM, x)

[prediction,score,~] = predict(classificationSVM, x);
score = score(:,2); % Score apenas para a classe "1" (amaciado)

end