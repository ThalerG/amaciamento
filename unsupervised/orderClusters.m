function [reordered,varargout] = orderClusters(clusterStruct,timeWindow)

reordered = clusterStruct;

% Matriz com colunas: Tempo, ordem do ensaio, cluster classificado
EnTemTot = [clusterStruct.Ensaio,clusterStruct.Tempo,clusterStruct.Cluster];
EnTemTot = sortrows(EnTemTot);

uncluster = unique(EnTemTot(:,3)); % Nome das clusters antigas
unensaio = unique(EnTemTot(:,1)); % "Nome" dos ensaios

imax = length(uncluster); % Total de clusters

changeMatrix = [uncluster,nan(imax,1)]; % Array para troca de valores: changeMatrix(1,k)->changeMatrix(2,k)

propTot = [];
propTime = [];
propEnsaio = [];
ord = [];
for k = 1:length(unensaio)
    tempo = EnTemTot(EnTemTot(:,1)==unensaio(k),2);
    cluster = EnTemTot(EnTemTot(:,1)==unensaio(k),3);
    
    tmax = tempo(1)+timeWindow;
    
    y = [];
    x = [];
    prop = [];
    k2 = 1;
    
    while tmax<=tempo(end)
        cTemp = cluster((tempo<tmax)&(tempo>=(tmax-timeWindow)));
        
        for p = 1:length(uncluster)
            temp(p) = nnz(cTemp==uncluster(p))/length(cTemp);
        end
        
        prop(k2,:) = temp;
        [~,sort] = sortrows(temp','descend'); % Rankeia por proporção
        [~,sort] = sortrows(sort);
        sort(temp == 0) = length(uncluster); % Valores 0 vão por último na ordem
        y(k2,:) = sort';
        x(k2) = tmax;
        tmax = tempo(k2)+timeWindow; % Atualiza a janela
        k2 = k2+1;
    end
        
    [~,temp] = max(y,[],1);
    propEnsaio = [propEnsaio;repmat(unensaio(k),length(x),1)];
    ord = [ord;y];
    propTot = [propTot;prop];
    propTime = [propTime;x'];
end

for k = 1:length(uncluster)
    [val,ind] = min(ord(:,k));
    changeMatrix(k,2) = (val-1)*size(ord,1)+ind; % "Rank" do cluster (esquema olímpico, primeiro procura por 1o lugar, depois 2o...)
end

[~,i] = sortrows(changeMatrix(:,2));
[~,i] = sortrows(i);

changeMatrix(:,2) = i;

for k = 1:size(changeMatrix,1)
    reordered.Cluster(clusterStruct.Cluster==changeMatrix(k,1)) = changeMatrix(k,2);
    proportions.Proportion(:,changeMatrix(k,2)) = propTot(:,k); % Ordena as colunas das proporções
end

proportions.Time = propTime;
proportions.Ensaio = propEnsaio;

switch nargout
    case 1
        varargout = {};
    case 2
        varargout = {changeMatrix};
    case 3
        varargout = {changeMatrix,proportions};
    otherwise
        error('Wrong number of output arguments');
end