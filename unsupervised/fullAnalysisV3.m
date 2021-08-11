% Análise automatizada de métodos não-supervisionados

clear; close all;

% O nome dos arquivos deve estar no formato XYY_Nn, com X sendo o modelo do
% compressor, YY o número da unidade, e n o parâmetro N utilizado na 
% clusterização

% Pasta com os dados de clusters. 
fold = 'D:\Documentos\Amaciamento\Clusterizações\Dissertacao - Modelo B\';
fold = dir(fold); fold = fold(3:end);

% Identifica as amostras contidas na pasta
am = regexp({fold.name},'.\d*_','match'); am = unique([am{:}]);

results = cell(length(am),1); % Inicialização de células para armazenar as clusterizções RAW

for k1 = 1:length(am)
    
    names = regexp({fold.name},strcat(am(k1),'.*'),'match');
    am{k1} = upper(am{k1}(1:(end-1)));
    names = [names{:}];
    
    for k2 = 1:length(names) % Para cada amostra
        if ~isempty(names(k2))
            % Reconhece e converte o parâmetro N de cada arquivo
            N = regexp(names{k2},'_N.*.csv','match');
            N = str2double(N{1}(3:(end-4))); 
            
            %Importação:
            F = strcat(fold(1).folder,'\',names{k2}); % Endereço do arquivo
            r = importClustersV2(F,am{k1},N); % Organiza e importa os clusters
            results{k1} = [results{k1};r]; % Monta um array de cells para cada amostra
        end
    end
end

clear r N F r names fold;

% Número de clusters
nClus = 3;

% Janela p/ proporção
windows = [0.5,1,1.5,2];

% Métodos de detecção
methods = {'GThr','LThr','Dom','First'};  

% Parâmetros de busca para cada método
paramMethod = [{0.1:0.1:1},{0:0.1:0.9},{NaN},{0:0.1:0.9}];

% Inicialização vazia da tabela com resultados:
resultadosBase.Grandeza = ''; % Grandeza analisada
resultadosBase.N = NaN; % Parâmetro N
resultadosBase.M = NaN; % Parâmetro M
resultadosBase.D = NaN; % Parâmetro D
resultadosBase.Amostra = {}; % Nome das amostras analisadas em cada método
resultadosBase.Window = NaN; % Tamanho da janela para detecção
resultadosBase.Cluster = NaN; % Número do cluster analisado para detecção
resultadosBase.Method = ''; % Método de detecção
resultadosBase.Param = []; % Quando o método de detecção depende de parâmetros, eles entram aqui
resultadosBase.TimeDetect = {}; % Tempo de amaciamento detectado para cada amostra
resultadosBase.Obs = {}; % Observações sobre a detecção de cada amsotra (Exemplo: não encontrou amaciamento, não foi conclusivo)
resultadosBase.Pass = false; % Combinação aprovada ou não pelos critérios de base (ver artigo de detecção não supervisionada)

% Converte a struct em uma tabela vazia
resultadosTotal = struct2table(resultadosBase,'AsArray',true); resultadosTotal(1,:) = [];

% Calcula o número de iterações necessárias
numIt = 1;
for k = 1:length(methods)
    numIt = numIt + length(paramMethod{k});
end
numIt = numIt*height(results{1})*length(windows)*nClus;

% Inicializa a waitbar
it = 0; f = waitbar(0);

% Encontra todas as combinações únicas de Grandeza, N, M, e D
un = [];
for kam = 1:length(results)
    for kgr = 1:height(results{kam})
        un = [un;results{kam}(kgr,["Grandeza","N","M","D"])];
    end
end
un = unique(un); % Tabela com as combinações únicas

for kgr = 1:height(un) % Para cada combinação
    
    rOr = [];
    
    % Busca por amostras que tenham sido analisadas naquela combinação.
    % Amostras sem dados de uma dada grandeza são desconsideradas.
    for kam = 1:length(results)
        rOr = [rOr;table2struct(results{kam}(strcmp(results{kam}.Grandeza,un.Grandeza{kgr})&(results{kam}.N==un.N(kgr))&...
                 (results{kam}.M==un.M(kgr))&(results{kam}.D==un.D(kgr)),:))];
    end
    
    for kw = 1:length(windows) % Para cada janelamento
        w = windows(kw);
        
        for km = 1:length(methods) % Para cada método
            for kp = 1:length(paramMethod{km}) % Para cada parâmetro de detecção
                for kc = 1:nClus % Para cada cluster
                    for kam = 1:length(rOr) % Para cada amostra
                        
                        % Calcula as proporções de clusters por janela
                        [~,~,prop] = orderClusters(rOr(kam),w);
                        
                        % Roda a detecção pelo método escolhido
                        switch methods{km}
                            case 'GThr'
                                resP(kam) = detect_GThr(prop.Proportion,prop.Time,prop.Ensaio,kc,paramMethod{km}(kp));
                            case 'LThr'
                                resP(kam) = detect_LThr(prop.Proportion,prop.Time,prop.Ensaio,kc,paramMethod{km}(kp));
                            case 'Dom'
                                resP(kam) = detect_Dom(prop.Proportion,prop.Time,prop.Ensaio,kc);
                            case 'First'
                                resP(kam) = detect_First(prop.Proportion,prop.Time,prop.Ensaio,kc,paramMethod{km}(kp));
                            otherwise
                                error('Método desconhecido')
                        end
                        r.TimeDetect{1}{kam} = resP(kam).TimeDetect; % Tempos de amaciamento detectados
                        r.Obs{1}{kam} = resP(kam).Obs; % Observações do método
                    end
                    
                    % Passa todos os dados para uma única struct
                    r.Pass = all([resP.Pass]); % O método só é aprovado quando todas as detecções atendem aos critérios
                    r.Amostra = {{rOr.Amostra}}; r.Grandeza = rOr.Grandeza;   
                    r.Method = methods{km}; r.Param = paramMethod{km}(kp);
                    r.Window = w; r.N = rOr(1).N; r.M = rOr(1).M; r.D = rOr(1).D;
                    r.Cluster = kc;
                    
                    r = struct2table(r);
                    
                    % Transfere o resultado da análise como uma linha da
                    % tabela com todas as análises
                    resultadosTotal = [resultadosTotal;r];
                    clear r resp;
                    
                    % Atualiza a waitbar
                    it = it + 1;
                    waitbar(it/numIt);
                end
            end
        end
    end
end

% Tabela de resultados aprovados em todos as condições
resultadosAprovados = resultadosTotal(resultadosTotal.Pass == true,:);

amostras = resultadosAprovados.Amostra{1};
for k = 2:height(resultadosAprovados)
    amostras = unique([amostras, resultadosAprovados.Amostra{k}]);
end

% Ordena as amostras corretamente (Ex.: {"B1", "B2", "B10"..} ao invés de {"B1", "B10", "B2"..})
R = cell2mat(regexp(amostras ,'(?<Name>\D+)(?<Nums>\d+)','names'));
tmp = sortrows([{R.Name}' num2cell(cellfun(@(x)str2double(x),{R.Nums}'))]);
amostras = strcat(tmp(:,1) ,cellfun(@(x) num2str(x), tmp(:,2),'unif',0));

tDetec = nan(3,height(resultadosAprovados),length(amostras));

% Monta a matriz com os tempos detectados
for k1 = 1:height(resultadosAprovados)
    for k2 = 1:length(amostras)
        i = find(strcmp(resultadosAprovados.Amostra{k1}{k2},amostras));
        tDetec(:,k1,i) = resultadosAprovados.TimeDetect{k1}{k2};
    end
end