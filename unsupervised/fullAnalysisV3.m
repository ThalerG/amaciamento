% An�lise automatizada de m�todos n�o-supervisionados

clear; close all;

% O nome dos arquivos deve estar no formato XYY_Nn, com X sendo o modelo do
% compressor, YY o n�mero da unidade, e n o par�metro N utilizado na 
% clusteriza��o

% Pasta com os dados de clusters. 
% fold = 'C:\Users\FEESC\Desktop\Amaciamento\Clusteriza��es\Dissertacao - Modelo B\';
fold = 'C:\Users\FEESC\Desktop\Amaciamento\DeteccaoNaoSupervisionado\Extra\B_Cluster\';
% fold = 'D:\Documentos\Amaciamento\Clusteriza��es\Codigo_Nicolas\Clusters\A_Cluster\';
fold = dir(fold); fold = fold(3:end);
% foldScore = 'D:\Documentos\Amaciamento\Clusteriza��es\Codigo_Nicolas\Clusters\A_Score';
foldScore = 'C:\Users\FEESC\Desktop\Amaciamento\DeteccaoNaoSupervisionado\Extra\B_Score\';
foldScore = dir(foldScore); foldScore = foldScore(3:end);

% Identifica as Unidades contidas na pasta
un = regexp({fold.name},'.\d*_','match'); un = unique([un{:}]);

tInicMax = 180; % Tempo inicial ((N-1)*D) m�ximo para busca

results = cell(length(un),1); % Inicializa��o de c�lulas para armazenar as clusteriz��es RAW

for k1 = 1:length(un)
    
    names = regexp({fold.name},strcat(un(k1),'.*'),'match');
    un{k1} = upper(un{k1}(1:(end-1)));
    names = [names{:}];
    tabelaEnsaio = [];

    for k2 = 1:length(names) % Para cada Unidade
        if ~isempty(names(k2))
            % Reconhece e converte o par�metro N de cada arquivo
            N = regexp(names{k2},'_N.*.csv','match');
            N = str2double(N{1}(3:(end-4))); 
            
            %Importa��o:
            F_clusters = strcat(fold(1).folder,'\',names{k2}); % Endere�o do arquivo
            F_score = strcat(foldScore(1).folder,'\score_',names{k2}); % Endere�o do arquivo de scores
            
            r = importClustersV2(F_clusters,F_score,un{k1},N); % Organiza e importa os clusters
            results{k1} = [results{k1};r]; % Monta um array de cells para cada Unidade
        end
    end
end

clear r N F_clusters F_score r names fold;

% N�mero de clusters
nClus = 3;

% Janela p/ propor��o
windows = [0.5,1,1.5,2];

% M�todos de detec��o
methods = {'LThr','GThr','Dom','FirstL','FirstG'};  

% Par�metros de busca para cada m�todo
paramMethod = [{0.1:0.1:1},{0:0.1:0.9},{NaN},{0.1:0.1:1},{0:0.1:0.9}];

% Inicializa��o vazia da tabela com resultados:
resultadosBase.Grandeza = ''; % Grandeza analisada
resultadosBase.N = NaN; % Par�metro N
resultadosBase.M = NaN; % Par�metro M
resultadosBase.D = NaN; % Par�metro D
resultadosBase.Unidade = {}; % Nome das Unidades analisadas em cada m�todo
resultadosBase.Window = NaN; % Tamanho da janela para detec��o
resultadosBase.Cluster = NaN; % N�mero do cluster analisado para detec��o
resultadosBase.Method = ''; % M�todo de detec��o
resultadosBase.Param = []; % Quando o m�todo de detec��o depende de par�metros, eles entram aqui
resultadosBase.TimeDetect = {}; % Tempo de amaciamento detectado para cada Unidade
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
it = 0;

% Encontra todas as combina��es �nicas de Grandeza, N, M, e D
un = [];
for kam = 1:length(results)
    for kgr = 1:height(results{kam})
        un = [un;results{kam}(kgr,["Grandeza","N","M","D"])];
    end
end
un = unique(un); % Tabela com as combina��es �nicas

f = waitbar(0);

for kgr = 1:height(un) % Para cada combina��o
    
    rOr = [];
    
    % Busca por Unidades que tenham sido analisadas naquela combina��o.
    % Unidades sem dados de uma dada grandeza s�o desconsideradas.
    for kam = 1:length(results)
        rOr = [rOr;table2struct(results{kam}(strcmp(results{kam}.Grandeza,un.Grandeza{kgr})&(results{kam}.N==un.N(kgr))&...
                 (results{kam}.M==un.M(kgr))&(results{kam}.D==un.D(kgr)),:))];
    end
    
    if ((rOr(1).N-1)*rOr(1).D) <= tInicMax % S� executa a an�lise se a combina��o est� dentro dos tempo inicial m�ximo da busca
        resultadosParcial = struct2table(resultadosBase,'AsArray',true); resultadosParcial(1,:) = [];

        for kw = 1:length(windows) % Para cada janelamento
            for km = 1:length(methods) % Para cada m�todo
                for kp = 1:length(paramMethod{km}) % Para cada par�metro de detec��o
                    for kc = 1:nClus % Para cada cluster
                        r = struct();
                        TimeDetect = {repmat({[]},1,length(rOr))};
                        Obs = {repmat({''},1,length(rOr))};
                        r.TimeDetect{1} = TimeDetect;
                        r.Obs{1} = Obs;
                        % Passa todos os dados para uma �nica struct
                        r.Pass = false;
                        r.Unidade = {{rOr.Unidade}}; r.Grandeza = rOr.Grandeza;   
                        r.Method = methods{km}; r.Param = paramMethod{km}(kp);
                        r.Window = windows(kw); r.N = rOr(1).N; r.M = rOr(1).M; r.D = rOr(1).D;
                        r.Cluster = kc;
                        r = struct2table(r);
                        resultadosParcial = [resultadosParcial;r];
                    end
                end
            end
        end

        parfor kRes = 1:height(resultadosParcial) % Para cada janelamento
            TimeDetect = repmat({[]},1,length(rOr));
            Obs = repmat({''},1,length(rOr));
            PassAll = false(1,length(rOr));

            r = resultadosParcial(kRes,:);

            for kam = 1:length(rOr) % Para cada Unidade
                % Calcula as propor��es de clusters por janela
                [~,~,prop] = orderClusters(rOr(kam),windows(kw));

                method = r{1,"Method"};
                param = r{1,"Param"};
                cluster = r{1,"Cluster"};
                % Roda a detec��o pelo m�todo escolhido
                switch method{1}
                    case 'GThr'
                        res = detect_GThr(prop.Proportion,prop.Time,prop.Ensaio,cluster,param{1});
                    case 'LThr'
                        res = detect_LThr(prop.Proportion,prop.Time,prop.Ensaio,cluster,param{1});
                    case 'Dom'
                        res = detect_Dom(prop.Proportion,prop.Time,prop.Ensaio,cluster);
                    case 'FirstG'
                        res = detect_FirstG(prop.Proportion,prop.Time,prop.Ensaio,cluster,param{1});
                    case 'FirstL'
                        res = detect_FirstL(prop.Proportion,prop.Time,prop.Ensaio,cluster,param{1});
                    otherwise
                        error('M�todo desconhecido')
                end
                TimeDetect{kam} = res.TimeDetect; % Tempos de amaciamento detectados
                Obs{kam} = res.Obs; % Observa��es do m�todo
                PassAll(kam) = res.Pass;
            end

            r{1,"TimeDetect"} = {TimeDetect};
            r{1,"Obs"} = {Obs};
            % Passa todos os dados para uma �nica struct
            r{1,"Pass"} = all(PassAll); % O m�todo s� � aprovado quando todas as detec��es atendem aos crit�rios
            r{1,"Unidade"} = {{rOr.Unidade}}; r{1,"Grandeza"} = {rOr(1).Grandeza};


            % Transfere o resultado da an�lise como uma linha da
            % tabela com todas as an�lises
            resultadosParcial(kRes,:) = r;
        end
        resultadosTotal = [resultadosTotal;resultadosParcial];
    end
    
    waitbar(kgr/height(un),f);
end

% Tabela de resultados aprovados em todos as condi��es
resultadosAprovados = resultadosTotal(resultadosTotal.Pass == true,:);

Unidades = resultadosAprovados.Unidade{1};
for k = 2:height(resultadosAprovados)
    Unidades = unique([Unidades, resultadosAprovados.Unidade{k}]);
end

% Ordena as Unidades corretamente (Ex.: {"B1", "B2", "B10"..} ao inv�s de {"B1", "B10", "B2"..})
R = cell2mat(regexp(Unidades ,'(?<Name>\D+)(?<Nums>\d+)','names'));
tmp = sortrows([{R.Name}' num2cell(cellfun(@(x)str2double(x),{R.Nums}'))]);
Unidades = strcat(tmp(:,1) ,cellfun(@(x) num2str(x), tmp(:,2),'unif',0));

tDetec = nan(3,height(resultadosAprovados),length(Unidades));

% Monta a matriz com os tempos detectados
for k1 = 1:height(resultadosAprovados)
    for k2 = 1:length(Unidades)
        i = find(strcmp(resultadosAprovados.Unidade{k1},Unidades{k2}));
        if ~isempty(i)
            tDetec(:,k1,k2) = resultadosAprovados.TimeDetect{k1}{i};
        end
    end
end