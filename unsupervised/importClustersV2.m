function [results] = importClustersV2(filename,amostra,N)

% Import the data
tbl = readtable(filename);

%% Convert to output type

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
Tempo = tbl.Tempo;
tbl = tbl(:,3:end);

results = table();

for k = 1:length(tbl.Properties.VariableNames)
    gran = regexp(tbl.Properties.VariableNames{k},'.*M\d','match');
    gran = gran{1}(1:(end-2));
    if (strcmp(amostra,'B5'))&&(strcmp(gran,'CorrenteRMS'))
        continue
    elseif (strcmp(amostra,'B7'))&&(strcmp(gran(1:5),'Vazao'))
        continue
    elseif (strcmp(amostra,'B8'))&&(strcmp(gran(1:5),'Vibra'))
        continue
    end
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
    
    M = regexp(tbl.Properties.VariableNames{k},'M\d*_','match');
    M = str2double(M{1}(2:end-1));
    D = regexp(tbl.Properties.VariableNames{k},'\d*$','match');
    D = str2double(D);
    
    clus = tbl{:,k};
    in = ~isnan(clus);
    
    if ~((N==1)&&(D~=1)) % Quando N=1, os valores s�o iguais para todos D, ent�o s� 1 � necess�rio
        results = [results;{amostra,name,{Tempo(in)},{Ensaio(in)},N,M,D,{clus(in)}}];
    end
end
results.Properties.VariableNames = {'Amostra','Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

end