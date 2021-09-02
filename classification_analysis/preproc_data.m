function [Ttrain,Xtrain,Ytrain,Xtest,Ytest,varargout] = preproc_data(EnData,tEst,conjVal,N,M,D,minT,varNames,paramOvers,standardize)
%PREPROC_DATA Realiza pré-processamento dos dados para machine learning
%   Se conjVal tem apenas um elemento, é a porcentagem de dados do conjunto
%   reservada para teste.
%   Se conjVal tem apenas uma coluna, são os índices das linhas utilizadas
%   como conjunto de teste.

if nargin < 9
    standardize = false;
    paramOvers{1} = 'none';
end

if standardize
     EnData = standardizeEnData(EnData,varNames);
end

if size(conjVal,2)==1
    [X,Y] = preTrain(EnData,tEst,N,M,D,minT,varNames);
    if numel(conjVal) == 1
        indA = find(Y==true);
        indN = find(Y==false);
        idA = randperm(length(indA), floor(conjVal*1e-2*length(indA)));
        idN = randperm(length(indN), floor(conjVal*1e-2*length(indN)));
        indTest = [indA(idA);indN(idN)];
        varargout{1} = indTest;
    else
        indTest = conjVal;
    end
    Xtest = X(indTest,:);
    Ytest = Y(indTest);
    Xtrain = X; Xtrain(indTest,:) = [];
    Ytrain = Y; Ytrain(indTest) = [];
else
    for k1 = 1:size(conjVal,1) % Separa conjunto de treino e de teste
        tEstTest{1}(k1) = tEst{conjVal(k1,1)}(conjVal(k1,2));
        EnDataTest{1}(k1) = EnData{conjVal(k1,1)}(conjVal(k1,2));
        tEst{conjVal(k1,1)}(conjVal(k1,2)) = [];
        EnData{conjVal(k1,1)}(conjVal(k1,2)) = [];
    end

    [Xtrain,Ytrain] = preTrain(EnData,tEst,N,M,D,minT,varNames);
    [Xtest,Ytest] = preTrain(EnDataTest,tEstTest,N,M,D,minT,varNames);
    varargout = {};
end

num = cellstr(num2str(((0:(N-1))*D)')); % Número para variáveis que "pulam" amostras (X = x(n),x(n-1*D), x(n-2*D)...)
num = strrep(num,' ',''); % Tira espaço vazio dos nomes

varnames = append(varNames,num); varnames = reshape(varnames,[],1); % Gera array com nomes
varnames = [varnames; 'Amaciado']; % Prepara array com nomes de todos os preditores + classe
Ttrain = array2table([Xtrain,Ytrain],'VariableNames',varnames); % Transforma array em tabela

if paramOvers{2} == 0
    num = nnz(Ttrain.Amaciado==1)-nnz(Ttrain.Amaciado==0);
else
    num = floor(nnz(Ttrain.Amaciado==0)*paramOvers{2}/100);
end
    
OversOptions.NumNeighbors = paramOvers{3};
OversOptions.Standardize = paramOvers{4};

% Oversampling
switch paramOvers{1}
     case "SMOTE"
         Ttrain.Amaciado = cellstr((num2str(Ttrain.Amaciado)));
         [newdata,~] = mySMOTE(Ttrain, "0", num, OversOptions);
         Ttrain = [Ttrain;newdata];
         Ttrain.Amaciado = str2double(Ttrain.Amaciado);
     case "ADASYN"
         Ttrain.Amaciado = cellstr((num2str(Ttrain.Amaciado)));
         [newdata,~] = myADASYN(Ttrain, "0", num, OversOptions);
         Ttrain = [Ttrain;newdata];
         Ttrain.Amaciado = str2double(Ttrain.Amaciado);
     case "Borderline SMOTE"
         Ttrain.Amaciado = cellstr((num2str(Ttrain.Amaciado)));
         [newdata,~] = myBorderlineSMOTE(Ttrain, "0", num, OversOptions);
         Ttrain = [Ttrain;newdata];
         Ttrain.Amaciado = str2double(Ttrain.Amaciado);
     case "Safe-level SMOTE"
         Ttrain.Amaciado = cellstr((num2str(Ttrain.Amaciado)));
         [newdata,~] = mySafeLevelSMOTE(Ttrain, "0", num, OversOptions);
         Ttrain = [Ttrain;newdata];
         Ttrain.Amaciado = str2double(Ttrain.Amaciado);
end

Xtrain = Ttrain{:,1:(end-1)};
Ytrain = Ttrain{:,end}==1;

end

