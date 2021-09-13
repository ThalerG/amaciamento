function [trainedClassifier, prediction, score, time] = train_ML_KNN(trainingData,numNeighbors,distance,weight,folds)
%  TRAIN_ML_KNN Treina um classificador K-Nearest Neighbors
%  Input:
%      trainingData: tabela com preditores e resposta. A resposta deve ser
%      a última coluna à direita.
%
%      numNeighbors: Número de neighbors para o modelo KNN (padrão é 10)
%
%      distance: métrica de distância. Valores válidos (padrão é 'euclidean'):
%           'cityblock'     City block distance.
%           'chebychev'     Chebychev distance (maximum coordinate difference).
%           'correlation'	One minus the sample linear correlation between observations (treated as sequences of values).
%           'cosine'        One minus the cosine of the included angle between observations (treated as vectors).
%           'euclidean'     Euclidean distance.
%           'hamming'   	Hamming distance, percentage of coordinates that differ.
%           'jaccard'   	One minus the Jaccard coefficient, the percentage of nonzero coordinates that differ.
%           'mahalanobis'	Mahalanobis distance, computed using a positive definite covariance matrix C. The default value of C is the sample covariance matrix of X, as computed by cov(X,'omitrows'). To specify a different value for C, use the 'Cov' name-value pair argument.
%           'minkowski' 	Minkowski distance. The default exponent is 2. To specify a different exponent, use the 'Exponent' name-value pair argument.
%           'seuclidean'	Standardized Euclidean distance. Each coordinate difference between X and a query point is scaled, meaning divided by a scale value S. The default value of S is the standard deviation computed from X, S = std(X,'omitnan'). To specify another value for S, use the Scale name-value pair argument.
%           'spearman'      One minus the sample Spearman's rank correlation between observations (treated as sequences of values
%       
%      weight: função de peso da distância. Valores válidos (padrão é 'equal'):
%           'equal'             No weighting
%           'inverse'           Weight is 1/distance
%           'squaredinverse'	Weight is 1/distance2
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
    numNeighbors = 10;
end

if nargin < 4
    distance = 'Euclidean';
    weight = 'equal';
end

if nargin < 5
    folds = 5;
end


if nargin < 2
    folds = 5;
end

predictors = trainingData(:, 1:(end-1));
response = double(trainingData{:, end});

c1 = clock;
% Configura e treina o KNN
classificationKNN = fitcknn(...
    predictors, ...
    response, ...
    'Distance', distance, ...
    'Exponent', [], ...
    'NumNeighbors', numNeighbors, ...
    'DistanceWeight', weight, ...
    'Standardize', true, ...
    'ClassNames', [0; 1], ...
    'ResponseName', 'Amaciado');
c2 = clock;
time = etime(c2,c1);

trainedClassifier.model = classificationKNN;
trainedClassifier.method = 'KNN';

trainedClassifier.predict = @(x) predictFromModel(classificationKNN, x);

predictors = trainingData{:, 1:(end-1)};

[prediction,score] = trainedClassifier.predict(predictors);

if folds>1
    cvp = cvpartition(height(trainingData),'KFold',folds);
    score = nan(size(score));
    prediction = nan(size(prediction));
    for k=1:folds
        [partitionedClassifier,~,~] = train_ML_KNN(trainingData(cvp.training(k), :),numNeighbors,distance,weight, 1);
        [predictionTemp,scoreTemp] = partitionedClassifier.predict(predictors);
        score(cvp.test(k)) = scoreTemp(cvp.test(k));
        prediction(cvp.test(k)) = predictionTemp(cvp.test(k),:);
    end
end

end

function [prediction,score] = predictFromModel(classificationKNN, x)

[prediction,score,~] = predict(classificationKNN, x);
score = score(:,2); % Score apenas para a classe "1" (amaciado)

end