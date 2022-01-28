% geraArquivoCluster.m

% Extrai as clusterizações e performances de múltiplos arquivos para uma
% única tabela

clear; clc;

fold = 'D:\Documentos\Amaciamento\Clusterizações\Codigo_Nicolas\Clusters\B_Cluster';
fold = dir(fold); fold = fold(3:end);
foldScore = 'D:\Documentos\Amaciamento\Clusterizações\Codigo_Nicolas\Clusters\B_Score';
foldScore = dir(foldScore); foldScore = foldScore(3:end);

% Extrai o nome das unidades de compressores da pasta
un = regexp({fold.name},'.\d*_','match'); un = unique([un{:}]);

clusters = [];

% Seleciona apenas as clusterizações da combinação desejada
for k1 = 1:length(un)
    
    names = regexp({fold.name},strcat(un(k1),'.*'),'match');
    un{k1} = upper(un{k1}(1:(end-1)));
    names = [names{:}];
    
    for k2 = 1:length(names) % Para cada amostra
        if ~isempty(names(k2))
            % Reconhece e converte o parâmetro N de cada arquivo
            N = regexp(names{k2},'_N.*.csv','match');
            N = str2double(N{1}(3:(end-4))); 
            
            F_clusters = strcat(fold(1).folder,'\',names{k2}); % Endereço do arquivo de clusterizações
            F_score = strcat(foldScore(1).folder,'\score_',names{k2}); % Endereço do arquivo de scores
            r = importClustersV2(F_clusters,F_score,un{k1},N); % Organiza e importa os clusters
            clusters = [clusters;r]; % Monta um array de cells para cada amostra
        end
    end
end