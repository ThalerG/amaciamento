function [trainedClassifier, prediction, score, time] = train_ML_Tree(trainingData, maxSplits, folds, paramOvers)
%  TRAIN_ML_TREE Treina um classificador por árvore de decisão
%      trainingData: tabela com preditores e resposta. A resposta deve ser
%      a última coluna à direita.
%
%      maxsplits: Número máximo de splits da árvore de decisão
%
%      folds: número de folds da validação cruzada (k-fold)
%           
%      paramOvers: parâmetros para oversampling.
%           paramOvers{1}       Algoritmo para oversampling. Valores
%             válidos (padrão é 'none'):
%                "none"
%                "SMOTE"
%                "ADASYN"
%                "Borderline SMOTE"
%                "Safe-level SMOTE"
%           paramOvers{2}       porcentagem de novas amostras geradas no
%             oversampling [%]
%           paramOvers{3}       Número de k-neighbors
%           paramOvers{4}       standardize? [logical]
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

if nargin < 3
    maxSplits = 50;
    folds = 5;
end

if nargin < 4
    paramOvers{1} = 'none';
end

switch paramOvers{1} % Oversampling
    case "SMOTE"
        options.NumNeighbors =  paramOvers{3};
        options.Standardize =  paramOvers{4};
        NSamp = paramOvers{2}*length(Ytrain);
        [newdata,~] = mySMOTE(trainingData,0,NSamp,...
            options);
        trainingDataOvers = [trainingData;newdata];
    case "ADASYN"
        options.NumNeighbors =  paramOvers{3};
        options.Standardize =  paramOvers{4};
        NSamp = paramOvers{2}*length(Ytrain);
        [newdata,~]  = myADASYN(trainingData,0,NSamp,...
            options);
        trainingDataOvers = [trainingData;newdata];
    case "Borderline SMOTE"
        options.NumNeighbors =  paramOvers{3};
        options.Standardize =  paramOvers{4};
        NSamp = paramOvers{2}*length(Ytrain);
        [newdata,~] = myBorderlineSMOTE(trainingData,0,NSamp,...
            options);
        trainingDataOvers = [trainingData;newdata];
    case "Safe-level SMOTE"
        options.NumNeighbors =  paramOvers{3};
        options.Standardize =  paramOvers{4};
        NSamp = paramOvers{2}*length(Ytrain);
        [newdata,~] = mySafeLevelSMOTE(trainingData,0,NSamp,...
            options);
        trainingDataOvers = [trainingData;newdata];
    case "none"
        trainingDataOvers = trainingData;
end

predictorsOvers = trainingDataOvers(:, 1:(end-1));
responseOvers = double(trainingDataOvers{:, end});

c1 = clock;
% Configura e treina a árvore
classificationTree = fitctree(...
    predictorsOvers, ...
    responseOvers, ...
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
        [partitionedClassifier,~,~] = train_ML_Tree(trainingData(cvp.training(k), :), maxSplits, 1, paramOvers);
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
