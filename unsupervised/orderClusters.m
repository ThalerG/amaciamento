function [reordered,changeMatrix] = orderClusters(clusterTable,timeWindow)

reordered = clusterTable;

for k1 = 1:height(clusterTable) % Para cada configuração na tabela
    cluster = clusterTable.Cluster(k1); cluster = cluster{1};
    uncluster = unique(cluster); % Nome das clusters
    imax = length(uncluster);
    
    ensaio = clusterTable.Ensaio(k1); ensaio = ensaio{1};
    
    changeMatrix = [uncluster,nan(imax,1)]; % Array para troca de valores: changeMatrix(1,k)->changeMatrix(2,k)
    tempo = clusterTable.Tempo(k1); tempo = tempo{1};
    i = 1;

    
    for k2 = 1:length(unique(ensaio)) % Para cada ensaio
        tempoTemp = tempo(ensaio==k2);
        clusterTemp = cluster(ensaio==k2);
        
        tmax= tempoTemp(1)+timeWindow;
        
        prop = nan(1,imax);
        
        while (tmax<=tempoTemp(end)) && (i<=imax) % Percorre o ensaio até terminar ou completar as clusters
            cl = clusterTemp((tempoTemp<tmax)&(tempoTemp>=(tmax-timeWindow)));
            
            for k = 1:length(uncluster) % Para cada cluster
                prop(k) = nnz(cl==uncluster(k))/length(cl);
            end
            
            [~,ind] = max(prop);
            
            if ~any(changeMatrix(:,2) == uncluster(ind))
                changeMatrix(i,2) = uncluster(ind);
                i = i+1;
            end
            
            tmax = tmax+timeWindow;
        end
        
        for k = 1:imax
            if isnan(changeMatrix(k,2))
                changeMatrix(k,2) = i;
                i = i+1;
            end
        end
        
        newCluster = nan(size(cluster));
        for k = 1:size(changeMatrix,1)
            newCluster(cluster==changeMatrix(k,1)) = changeMatrix(k,2);
        end
    end
    
    reordered.Cluster(k1) = {newCluster};
end