% An�lise automatizada de m�todos n�o-supervisionados

clear; close all;

% O nome dos arquivos deve estar no formato XYY_Nn, com X sendo o modelo do
% compressor, YY o n�mero da unidade, e n o par�metro N utilizado na 
% clusteriza��o

% Pasta com os dados de clusters. 
fold = 'D:\Documentos\Amaciamento\Clusteriza��es\Dissertacao - Modelo B\';
fold = dir(fold); fold = fold(3:end);

% Identifica as amostras contidas na pasta
am = regexp({fold.name},'.\d*_','match'); am = unique([am{:}]);

results = cell(length(am),1); % Inicializa��o de c�lulas para armazenar as clusteriz��es RAW

for k1 = 1:length(am)
    
    names = regexp({fold.name},strcat(am(k1),'.*'),'match');
    am{k1} = upper(am{k1}(1:(end-1)));
    names = [names{:}];
    
    for k2 = 1:length(names) % Para cada amostra
        if ~isempty(names(k2))
            % Reconhece e converte o par�metro N de cada arquivo
            N = regexp(names{k2},'_N.*.csv','match');
            N = str2double(N{1}(3:(end-4))); 
            
            %Importa��o:
            F = strcat(fold(1).folder,'\',names{k2}); % Endere�o do arquivo
            r = importClustersV2(F,am{k1},N); % Organiza e importa os clusters
            results{k1} = [results{k1};r]; % Monta um array de cells para cada amostra
        end
    end
end

clear r N F r names fold;

% N�mero de clusters
nClus = 3;

% Janela p/ propor��o
windows = [0.5,1,1.5,2];

% M�todos de detec��o
methods = {'GThr','LThr','Dom','First'};  

% Par�metros de busca para cada m�todo
paramMethod = [{0.1:0.1:1},{0:0.1:0.9},{NaN},{0:0.1:0.9}];

% Inicializa��o vazia da tabela com resultados:
resultadosBase.Grandeza = ''; % Grandeza analisada
resultadosBase.N = NaN; % Par�metro N
resultadosBase.M = NaN; % Par�metro M
resultadosBase.D = NaN; % Par�metro D
resultadosBase.Amostra = {}; % Nome das amostras analisadas em cada m�todo
resultadosBase.Window = NaN; % Tamanho da janela para detec��o
resultadosBase.Cluster = NaN; % N�mero do cluster analisado para detec��o
resultadosBase.Method = ''; % M�todo de detec��o
resultadosBase.Param = []; % Quando o m�todo de detec��o depende de par�metros, eles entram aqui
resultadosBase.TimeDetect = {}; % Tempo de amaciamento detectado para cada amostra
resultadosBase.Obs = {}; % Observa��es sobre a detec��o de cada amsotra (Exemplo: n�o encontrou amaciamento, n�o foi conclusivo)
resultadosBase.Pass = false; % Combina��o aprovada ou n�o pelos crit�rios de base (ver artigo de detec��o n�o supervisionada)

% Converte a struct em uma tabela vazia
resultadosTotal = struct2table(resultadosBase,'AsArray',true); resultadosTotal(1,:) = [];

% Calcula o n�mero de itera��es necess�rias
numIt = 1;
for k = 1:length(methods)
    numIt = numIt + length(paramMethod{k});
end
numIt = numIt*height(results{1})*length(windows)*nClus;

% Inicializa a waitbar
it = 0; f = waitbar(0);

% Encontra todas as combina��es �nicas de Grandeza, N, M, e D
un = [];
for kam = 1:length(results)
    for kgr = 1:height(results{kam})
        un = [un;results{kam}(kgr,["Grandeza","N","M","D"])];
    end
end
un = unique(un); % Tabela com as combina��es �nicas

for kgr = 1:height(un) % Para cada combina��o
    
    rOr = [];
    
    % Busca por amostras que tenham sido analisadas naquela combina��o.
    % Amostras sem dados de uma dada grandeza s�o desconsideradas.
    for kam = 1:length(results)
        rOr = [rOr;table2struct(results{kam}(strcmp(results{kam}.Grandeza,un.Grandeza{kgr})&(results{kam}.N==un.N(kgr))&...
                 (results{kam}.M==un.M(kgr))&(results{kam}.D==un.D(kgr)),:))];
    end
    
    for kw = 1:length(windows) % Para cada janelamento
        w = windows(kw);
        
        for km = 1:length(methods) % Para cada m�todo
            for kp = 1:length(paramMethod{km}) % Para cada par�metro de detec��o
                for kc = 1:nClus % Para cada cluster
                    for kam = 1:length(rOr) % Para cada amostra
                        
                        % Calcula as propor��es de clusters por janela
                        [~,~,prop] = orderClusters(rOr(kam),w);
                        
                        % Roda a detec��o pelo m�todo escolhido
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
                                error('M�todo desconhecido')
                        end
                        r.TimeDetect{1}{kam} = resP(kam).TimeDetect; % Tempos de amaciamento detectados
                        r.Obs{1}{kam} = resP(kam).Obs; % Observa��es do m�todo
                    end
                    
                    % Passa todos os dados para uma �nica struct
                    r.Pass = all([resP.Pass]); % O m�todo s� � aprovado quando todas as detec��es atendem aos crit�rios
                    r.Amostra = {{rOr.Amostra}}; r.Grandeza = rOr.Grandeza;   
                    r.Method = methods{km}; r.Param = paramMethod{km}(kp);
                    r.Window = w; r.N = rOr(1).N; r.M = rOr(1).M; r.D = rOr(1).D;
                    r.Cluster = kc;
                    
                    r = struct2table(r);
                    
                    % Transfere o resultado da an�lise como uma linha da
                    % tabela com todas as an�lises
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

% Tabela de resultados aprovados em todos as condi��es
resultadosAprovados = resultadosTotal(resultadosTotal.Pass == true,:);

amostras = resultadosAprovados.Amostra{1};
for k = 2:height(resultadosAprovados)
    amostras = unique([amostras, resultadosAprovados.Amostra{k}]);
end

% Ordena as amostras corretamente (Ex.: {"B1", "B2", "B10"..} ao inv�s de {"B1", "B10", "B2"..})
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