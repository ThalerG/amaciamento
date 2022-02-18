clear; close all;

%% Modelo A

% load('D:\Documentos\Amaciamento\Apresentações\00_Dissertacao\NaoSupervisionado\tabelaResultadosA.mat');
% sv = 'D:\Documentos\Amaciamento\Apresentações\00_Dissertacao\';

load('C:\Users\FEESC\Desktop\Amaciamento\DeteccaoNaoSupervisionado\tabelaResultadosA_expanded.mat');
sv = 'C:\Users\FEESC\Desktop\Amaciamento\Ferramentas\Arquivos Gerados\KMeansExpanded\';

unidades = resultadosTotal.Unidade{1};
for k = 2:height(resultadosTotal)
    unidades = unique([unidades, resultadosTotal.Unidade{k}]);
end

% Ordena as unidades corretamente (Ex.: {"B1", "B2", "B10"..} ao invés de {"B1", "B10", "B2"..})
R = cell2mat(regexp(unidades ,'(?<Name>\D+)(?<Nums>\d+)','names'));
tmp = sortrows([{R.Name}' num2cell(cellfun(@(x)str2double(x),{R.Nums}'))]);
unidades = strcat(tmp(:,1) ,cellfun(@(x) num2str(x), tmp(:,2),'unif',0));

% Tabela de resultados aprovados em todos as condições
resultadosAprovados = resultadosTotal((resultadosTotal.Pass == true),:);

%Matriz vazia para os tempos de detecção
tDetec = nan(3,height(resultadosAprovados),length(unidades));

% Monta a matriz com os tempos detectados
for k1 = 1:height(resultadosAprovados)
    for k2 = 1:length(unidades)
        i = find(strcmp(resultadosAprovados.Unidade{k1},unidades{k2}));
        if ~isempty(i)
            tDetec(:,k1,k2) = resultadosAprovados.TimeDetect{k1}{i};
        end
    end
end

tAmac = squeeze(tDetec(1,:,:));
tJaAmac = squeeze(max(tDetec(2:3,:,:),[],1));

ggGr = resultadosAprovados((min(tAmac,[],2)>=4)&(max(tJaAmac,[],2)<5),:);
tAmacGr = tAmac((min(tAmac,[],2)>=4)&(max(tJaAmac,[],2)<5),:);
ggGr = [ggGr,table(tAmacGr,'VariableNames',{'TempoAmac'})];

analise = unique(ggGr(:,["Grandeza","N","M","D","Window","Method","Cluster","TempoAmac"]));

param = cell(height(analise),1);

for k = 1:height(analise)
    ex = ggGr(strcmp(ggGr.Grandeza,analise.Grandeza(k))&(ggGr.N==analise.N(k))&...
              (ggGr.M==analise.M(k))&(ggGr.D==analise.D(k))&...
              (ggGr.Window==analise.Window(k))&strcmp(ggGr.Method,analise.Method(k))&...
              (ggGr.Cluster==analise.Cluster(k))&(prod(ggGr.TempoAmac==analise.TempoAmac(k,:),2)),:);
    param{k} = [ex.Param{:}];
end

ggAll = ggGr;
ggGr = ggGr((ggGr.TempoAmac(:,2)>=10)&(ggGr.TempoAmac(:,4)>=10),:);
tAmacGr = ggGr.TempoAmac;

figure;
ha = tightPlots(ceil(length(unidades)/2), 2, 16, [5 3], [0.6 1], [0.9 0.5], [0.8 0.6], 'centimeters');
tend = 20;

ylmax = -inf;
for k1 = 1:length(unidades)
    axes(ha(k1))
    histogram(tAmacGr(:,k1),4:tend); 
    if k1 < 3
        xticklabels("");
    else
        xlabel('Instante de transição [h]'); 
    end
    ylabel('Frequência'); title(['Unidade ',unidades{k1}]);
    ylmax = max([ylmax,ylim()]);
end

for k1 = 1:length(unidades)
    axes(ha(k1))
    ylim([0,ylmax]);
end

savefig(strcat(sv,'histA.fig'));
print(gcf,'-dpdf', [sv,'histA.pdf']);

ggGrA = ggGr;

clearvars -except ggGrA

%% Modelo B

% load('D:\Documentos\Amaciamento\Apresentações\00_Dissertacao\NaoSupervisionado\tabelaResultadosB.mat');
% sv = 'D:\Documentos\Amaciamento\Apresentações\00_Dissertacao\';

load('C:\Users\FEESC\Desktop\Amaciamento\DeteccaoNaoSupervisionado\tabelaResultadosB_expanded.mat');
sv = 'C:\Users\FEESC\Desktop\Amaciamento\Ferramentas\Arquivos Gerados\KMeansExpanded\';

unidades = resultadosTotal.Unidade{1};
for k = 2:height(resultadosTotal)
    unidades = unique([unidades, resultadosTotal.Unidade{k}]);
end

% Ordena as unidades corretamente (Ex.: {"B1", "B2", "B10"..} ao invés de {"B1", "B10", "B2"..})
R = cell2mat(regexp(unidades ,'(?<Name>\D+)(?<Nums>\d+)','names'));
tmp = sortrows([{R.Name}' num2cell(cellfun(@(x)str2double(x),{R.Nums}'))]);
unidades = strcat(tmp(:,1) ,cellfun(@(x) num2str(x), tmp(:,2),'unif',0));

% Tabela de resultados aprovados em todos as condições
resultadosAprovados = resultadosTotal((resultadosTotal.Pass == true),:);

%Matriz vazia para os tempos de detecção
tDetec = nan(3,height(resultadosAprovados),length(unidades));

% Monta a matriz com os tempos detectados
for k1 = 1:height(resultadosAprovados)
    for k2 = 1:length(unidades)
        i = find(strcmp(resultadosAprovados.Unidade{k1},unidades{k2}));
        if ~isempty(i)
            tDetec(:,k1,k2) = resultadosAprovados.TimeDetect{k1}{i};
        end
    end
end

tAmac = squeeze(tDetec(1,:,:));
tJaAmac = squeeze(max(tDetec(2:3,:,:),[],1));

ggGr = resultadosAprovados((min(tAmac,[],2)>=4)&(max(tJaAmac,[],2)<5),:);
tAmacGr = tAmac((min(tAmac,[],2)>=4)&(max(tJaAmac,[],2)<5),:);
ggGr = [ggGr,table(tAmacGr,'VariableNames',{'TempoAmac'})];

analise = unique(ggGr(:,["Grandeza","N","M","D","Window","Method","Cluster","TempoAmac"]));

param = cell(height(analise),1);

for k = 1:height(analise)
    ex = ggGr(strcmp(ggGr.Grandeza,analise.Grandeza(k))&(ggGr.N==analise.N(k))&...
              (ggGr.M==analise.M(k))&(ggGr.D==analise.D(k))&...
              (ggGr.Window==analise.Window(k))&strcmp(ggGr.Method,analise.Method(k))&...
              (ggGr.Cluster==analise.Cluster(k))&(prod(ggGr.TempoAmac==analise.TempoAmac(k,:),2)),:);
    param{k} = [ex.Param{:}];
end

figure;
ha = tightPlots(ceil(length(unidades)/2), 2, 16, [5 3], [0.9 1], [0.9 0.5], [0.8 0.6], 'centimeters');
tend = 40;

ylmax = -inf;
for k1 = 1:length(unidades)
    axes(ha(k1))
    histogram(tAmacGr(:,k1),4:tend); 
    ylabel('Frequência'); title(['Unidade ',unidades{k1}]);
    ylmax = max([ylmax,ylim()]);
end

for k1 = 1:length(unidades)
    axes(ha(k1))
    ylim([0,ylmax]);
end

savefig(strcat(sv,'histB.fig'));
print(gcf,'-dpdf', [sv,'histB.pdf']);

ggGrB = ggGr;