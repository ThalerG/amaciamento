clear; close all;

load('EnDataA.mat');

EnData = EnDataA;

conjVal = [1,1;4,2;5,3]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]
% conjVal = [];

% Tempos de amaciamento esperados:

tEst{1} = 4.4;

tEst{2} = [7.5;
           2.5;
           2.5;
           2.5];
       
tEst{3} = [11.8;
           2.5;
           2.5];
         
tEst{4} = [6;
           2.5;
           2.5;
           2.1];

tEst{5} = [12.5;
           2.5;
           2.5];

       
for k1 = 1:size(conjVal,1) % Apaga os valores dos conjuntos de validação
    tEstTest{1}(k1) = tEst{conjVal(k1,1)}(conjVal(k1,2));
    EnDataTest{1}(k1) = EnData{conjVal(k1,1)}(conjVal(k1,2));
    tEst{conjVal(k1,1)}(conjVal(k1,2)) = [];
    EnData{conjVal(k1,1)}(conjVal(k1,2)) = [];
end
       
N = 3; % Janela (número de amostras) da regressão
M = 100; % Janela da média móvel
D = 40; % Distância entre amostras da regressão
thr = 0.576;
extra = 0; % Valor adicionado ao tempo de amaciamento para deixar mais conservador [h]
minT = 20; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)
wMax = 3; % Duração máxima da janela [h];

FitCL = 0;

[Xobs,Yres] = preTrain(EnData,tEst,N,M,D,minT);
[Xtest,Ytest] = preTrain(EnDataTest,tEstTest,N,M,D,minT);


num = cellstr(num2str(((0:(N-1))*D)')); % Número para variáveis que "pulam" amostras (X = x(n),x(n-1*D), x(n-2*D)...)
num = strrep(num,' ',''); % Tira espaço vazio dos nomes
vars = {'cRMS','cKur','vInfRMS', 'vInfKur','vSupRMS','vSupKur'}; % Nomes das variáveis
varnames = append(strcat(vars,'_'),num); varnames = reshape(varnames,[],1); % Gera array com nomes

num = cellstr(num2str((0:(N-1))')); num = strrep(num,' ',''); % Número para variáveis que não "pulam" amostras (X = x(n),x(n-1), x(n-2)...)
varnames = [varnames; append('vaz_',num); 'Class']; % Prepara array com nomes de todos os preditores + classe
TTrain = array2table([Xobs,Yres],'VariableNames',varnames); % Transforma array em tabela
TTest = array2table([Xtest],'VariableNames',varnames(1:end-1)); % Transforma array em tabela