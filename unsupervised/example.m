clear; close all;

tWind = 1; 

[result] = importClusters('amostra3_clusters.csv',3);


[cRMS,~] = orderClusters(cRMS,tWind);
[cKur,~] = orderClusters(cKur,tWind);
[cVar,~] = orderClusters(cVar,tWind);

[vibInfRMS,~] = orderClusters(vibInfRMS,tWind);
[vibInfKur,~] = orderClusters(vibInfKur,tWind);
[vibInfVar,~] = orderClusters(vibInfVar,tWind);

[vibSupRMS,~] = orderClusters(vibSupRMS,tWind);
[vibSupKur,~] = orderClusters(vibSupKur,tWind);
[vibSupVar,~] = orderClusters(vibSupVar,tWind);

[vaz,~] = orderClusters(vibSupRMS,tWind);
[vaz,~] = orderClusters(vibSupKur,tWind);
[vaz,~] = orderClusters(vibSupVar,tWind);

en=1;

ensaio = cRMS.Ensaio{1};
allClusters = sort(unique(cRMS.Cluster{1}));
cluster = cRMS.Cluster{1}(cRMS.Ensaio{1}==en);

tempo = cRMS.Tempo{1}(cRMS.Ensaio{1}==en);
tmax = tempo(1)+tWind;

i = 1;

while tmax<tempo(end)
    x(i) = tmax;
    cTemp = cluster((tempo<tmax)&(tempo>=(tmax-tWind)));
    for p = 1:length(allClusters)
        temp(p) = nnz(cTemp==p)/length(cTemp);
    end
    y(i,:) = temp;
    tmax = tmax+tWind;
    i = i+1;
end

figure; bar(x,y);