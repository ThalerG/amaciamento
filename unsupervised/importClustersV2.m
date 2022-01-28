function [results] = importClustersV2(filenameClusters,filenameScore,unidade,N)
%IMPORTTCLUSTERSV2 Importa clusters e dados de performance de tabelas
%   RESULTS = IMPORTTCLUSTERSV2(FILENAMECLUSTERS,FILENAMESCORE,UNIDADE, N)
%   extrai os dados de clusterização do arquivo .csv FILENAMECLUSTERS e de
%   performance do arquivo .csv FILENAMESCORE, para a unidade de compressor
%   de nome UNIDADE (str), com análise de N (int) features. Os resultados
%   são retornados na tabela RESULTS.

% Importa os dados de clusterização
tbl = readtable(filenameClusters);

% Com base na coluna de tempo, atribui a ordem dos ensaios para cada ponto
n = 1;
Ensaio = nan(length(tbl.Tempo),1);
Ensaio(1) = 1;
tbl.Tempo = tbl.Tempo(~isnan(tbl.Tempo));
for k = 2:length(tbl.Tempo)
    if tbl.Tempo(k)<tbl.Tempo(k-1)
        n=n+1;
    end
    Ensaio(k) = n;
end

% Descarta as colunas de index e tempo da tabela
Tempo = tbl.Tempo;
tbl = tbl(:,3:end);

results = table();

for k = 1:length(tbl.Properties.VariableNames)
    % Extrai o nome da grandeza
    gran = regexp(tbl.Properties.VariableNames{k},'.*M\d','match');
    gran = gran{1}(1:(end-2));
    
    if (strcmp(unidade,'B5'))&&(strcmp(gran(1:5),'Vazao')) % Amostra B5 tem problema na vazão
        continue
    elseif (strcmp(unidade,'B7'))&&(strcmp(gran,'CorrenteRMS')) % Amostra B7 tem problema na corrente RMS
        continue
    elseif (strcmp(unidade,'B8'))&&(strcmp(gran(1:5),'Vibra')) % Amostra B8 tem problema nas vibrações
        continue
    end
    
    % Converte o nome da grandeza
    switch gran
        case 'CorrenteRMS'
            name = 'cRMS';
        case 'CorrenteVariancia'
            name = 'cVar';
        case 'CorrenteCurtose'
            name = 'cKur';
        case 'VibracaoCalotaInferiorRMS'
            name = 'vibInfRMS';
        case 'VibracaoCalotaSuperiorRMS'
            name = 'vibSupRMS';
        case 'VibracaoCalotaInferiorCurtose'
            name = 'vibInfKur';
        case 'VibracaoCalotaSuperiorCurtose'
            name = 'vibSupKur';
        case 'VibracaoCalotaInferiorVariancia'
            name = 'vibInfVar';
        case 'VibracaoCalotaSuperiorVariancia'
            name = 'vibSupVar';
        case 'Vazao'
            name = 'vazao';
        otherwise
            error('Coluna desconhecida');
    end
    
    % Extrai os valores M e D do nome da coluna
    M = regexp(tbl.Properties.VariableNames{k},'M\d*_','match');
    M = str2double(M{1}(2:end-1));
    D = regexp(tbl.Properties.VariableNames{k},'\d*$','match');
    D = str2double(D);
    
    clus = tbl{:,k};
    in = ~isnan(clus);
    
    if ~((N==1)&&(D~=1)) % Quando N=1, os valores são iguais para todos D, então só 1 é necessário
        results = [results;{unidade,name,{Tempo(in)},{Ensaio(in)},N,M,D,{clus(in)}}];
    end
end

results.Properties.VariableNames = {'Unidade','Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

%%%%%%%%%%%%%%%%%%%%% Performance das clusterizações %%%%%%%%%%%%%%%%%%%%%

% Extrai em forma de texto as informações do arquivo de score
text = fileread(filenameScore);

% Corrige as quebras de linha da matriz em formato ASCII
text = regexprep(convertCharsToStrings(text),'\n','');
text = regexprep(convertCharsToStrings(text),'\]\"','\]\"\n');

% Conta a quantidade de colunas no arquivo e separa as colunas em células
tmp = textscan(text, '%s ', 'delimiter', '\n', 'MultipleDelimsAsOne', 1);
n_colunas = count(tmp{1}{1},',')+1;
data = textscan(text, repmat('%s ', [1, n_colunas]),'Delimiter',',');

% Para cada coluna exceto a primeira, que é index
for k = 2:length(data)
    % Monta um array de struct com todas as coluans
    if strcmp('Grandeza',data{k}{1})
        for k2 = 2:length(data{k})
            % Na coluna de grandezas, converte o formato dos nomes
            switch data{k}{k2}
                case 'CorrenteRMS'
                    struct_data(k2-1).(data{k}{1}) = 'cRMS';
                case 'CorrenteVariancia'
                    struct_data(k2-1).(data{k}{1}) = 'cVar';
                case 'CorrenteCurtose'
                    struct_data(k2-1).(data{k}{1}) = 'cKur';
                case 'VibracaoCalotaInferiorRMS'
                    struct_data(k2-1).(data{k}{1}) = 'vibInfRMS';
                case 'VibracaoCalotaSuperiorRMS'
                    struct_data(k2-1).(data{k}{1}) = 'vibSupRMS';
                case 'VibracaoCalotaInferiorCurtose'
                    struct_data(k2-1).(data{k}{1}) = 'vibInfKur';
                case 'VibracaoCalotaSuperiorCurtose'
                    struct_data(k2-1).(data{k}{1}) = 'vibSupKur';
                case 'VibracaoCalotaInferiorVariancia'
                    struct_data(k2-1).(data{k}{1}) = 'vibInfVar';
                case 'VibracaoCalotaSuperiorVariancia'
                    struct_data(k2-1).(data{k}{1}) = 'vibSupVar';
                case 'Vazao'
                    struct_data(k2-1).(data{k}{1}) = 'vazao';
                otherwise
                    error('Coluna desconhecida');
            end
        end
    elseif strcmp('Centroides',data{k}{1})
        array_centr = NaN;
        for k2 = 2:length(data{k})
            % Na coluna de centroides, converte a matriz ASCII em matriz numérica
            array_text = regexprep(data{k}{k2},'\] \[','\n');
            array_text = regexprep(array_text,'[\[\]\"]','');
            struct_data(k2-1).(data{k}{1}) = str2num(array_text);
        end
    else
        for k2 = 2:length(data{k})
            % Nas outras colunas, converte p/ valor numérico
            struct_data(k2-1).(data{k}{1}) = str2double(data{k}{k2});
        end
    end
end

table_score = struct2table(struct_data);

% Mescla as tabelas de clusterizações e de performance com base nas colunas em comum (Grandeza, N, M, D)
results = join(results, table_score);

end