am = t.Amostra{1};

if isequal(am,{'A3','A4','A5'})
    flag = 1;
else
    flag = 0;
end

temp = t((t.Pass == true),:);

if flag == 1
    tEst = [12, 5, 12];
    tN = nan(height(temp),length(t.TimeDetect(1)));
end

tAmac = nan(height(temp),length(t.TimeDetect(1)));
tJaAmac = nan(height(temp),length(t.TimeDetect(1)));

for k1 = 1:height(temp)
    TDec = temp.TimeDetect(k1,:);
    for k2 = 1:length(TDec)
        TimeAmac = TDec{k2};
        tAmac(k1,k2) = TimeAmac(1);
        tJaAmac(k1,k2) = max(TimeAmac(2:end));
    end
    if flag == 1
        tN(k1) = norm(tAmac(k1,:)-tEst);
    end
end

if flag == 1
    tN = table(tN,'VariableNames',{'NormaDif'});
    temp = [temp,tN];
end

ggGr = temp((min(tAmac,[],2)>=4)&(max(tJaAmac,[],2)<5),:);
tAmacGr = tAmac((min(tAmac,[],2)>=4)&(max(tJaAmac,[],2)<5),:);
ggGr = [ggGr,table(tAmacGr,'VariableNames',{'TempoAmac'})];

if flag == 1
    analise = unique(ggGr(:,[1:5,8,11,13,14]));
else
    analise = unique(ggGr(:,[1:5,8,11,13]));
end

param = cell(height(analise),1);

for k = 1:height(analise)
    ex = ggGr(strcmp(ggGr.Grandeza,analise.Grandeza(k))&(ggGr.N==analise.N(k))&...
              (ggGr.M==analise.M(k))&(ggGr.D==analise.D(k))&...
              (ggGr.Window==analise.Window(k))&strcmp(ggGr.Method,analise.Method(k))&...
              (ggGr.Cluster==analise.Cluster(k))&(prod(ggGr.TempoAmac==analise.TempoAmac(k,:),2)),:);
    param{k} = [ex.Param{:}];
end

if flag == 1
    ggGr = sortrows([analise,table(param,'VariableNames',"Param")],'NormaDif');
end

ggAll = ggGr;
ggGr = ggGr((ggGr.TempoAmac(:,1)>=10)&(ggGr.TempoAmac(:,3)>=10)&~strcmp(ggGr.Method,'GThr'),:);
tAmacGr = ggGr.TempoAmac;


sv = 'D:\Documentos\Amaciamento\Ferramentas\ProjetoMatlab\unsupervised\VNew\AmA\';

%% All Methods

figure;

for k1 = 1:length(am)
    if am{k1}(1) == 'A'
        tend = 20;
    else
        tend = 40;
    end
    subplot(length(am)/3,3,k1)
    histogram(tAmacGr(:,k1),4:tend); xlabel('Instante de transição [h]'); ylabel('Frequência'); title(['Amostra ',am{k1}]);
end

export_fig([sv,'hist_all'],'-png','-m5','-transparent');
savefig([sv,'hist_all']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%% Grandeza %%%%%%%%%%

un = unique(ggGr.Grandeza);
countNum = zeros(length(un),1);

for k = 1:length(un)
    idx = strfind(ggGr.Grandeza,un{k});
    countNum(k) = nnz(not(cellfun('isempty',idx)));
end

countGran = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];

for k1 = 1:length(am)
    if am{k1}(1) == 'A'
        tend = 20;
    else
        tend = 40;
    end
    subplot(length(am)/3,3,k1)
    for k = 1:length(un)
        histogram(tAmacGr(ggGr.Grandeza==convertCharsToStrings(un{k}),k1),4:tend,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{k1}]);
        hold on
    end
    hold off
    legend(un,'location','best');
end

legend(un,'location','best');
sgtitle('Grandeza');

export_fig([sv,'hist_grandeza'],'-png','-m5','-transparent');
savefig([sv,'hist_grandeza']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%% N %%%%%%%%%%

un = unique(ggGr.N);
countNum = zeros(length(un),1);

for k = 1:length(un)
    countNum(k) = nnz(ggGr.N == un(k));
end

countN = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];
for k1 = 1:length(am)
    if am{k1}(1) == 'A'
        tend = 20;
    else
        tend = 40;
    end
    subplot(length(am)/3,3,k1)
    for k = 1:length(un)
        histogram(tAmacGr(ggGr.N==un(k),k1),4:tend,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{k1}]);
        hold on
    end
    hold off
    legend(strcat('N=',num2str(un)),'location','best');
end

sgtitle('N (Número de Features)');

export_fig([sv,'hist_N'],'-png','-m5','-transparent');
savefig([sv,'hist_N']);
%% %%%%%%%%%%%%%%%%%%%%%%%%%% M %%%%%%%%%%

un = unique(ggGr.M);
countNum = zeros(length(un),1);

for k = 1:length(un)
    countNum(k) = nnz(ggGr.M == un(k));
end

countM = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];
for k1 = 1:length(am)
    if am{k1}(1) == 'A'
        tend = 20;
    else
        tend = 40;
    end
    subplot(length(am)/3,3,k1)
    for k = 1:length(un)
        histogram(tAmacGr(ggGr.M==un(k),k1),4:tend,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{k1}]);
        hold on
    end
    hold off
    legend(strcat('M=',num2str(un)),'location','best');
end
sgtitle('M (Janela do filtro) [amostras]');

export_fig([sv,'hist_M'],'-png','-m5','-transparent');
savefig([sv,'hist_M']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%% D %%%%%%%%%%

un = unique(ggGr.D);
countNum = zeros(length(un),1);

for k = 1:length(un)
    countNum(k) = nnz(ggGr.D == un(k));
end

countD = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];
for k1 = 1:length(am)
    if am{k1}(1) == 'A'
        tend = 20;
    else
        tend = 40;
    end
    subplot(length(am)/3,3,k1)
    for k = 1:length(un)
        histogram(tAmacGr(ggGr.D==un(k),k1),4:tend,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{k1}]);
        hold on
    end
    hold off
    legend(strcat('D=',num2str(un)),'location','best');
end
sgtitle('D (Lag entre features) [amostras]');

export_fig([sv,'hist_D'],'-png','-m5','-transparent');
savefig([sv,'hist_D']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%% W %%%%%%%%%%

un = unique(ggGr.Window);
countNum = zeros(length(un),1);

for k = 1:length(un)
    countNum(k) = nnz(ggGr.Window == un(k));
end

countW = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];
for k1 = 1:length(am)
    if am{k1}(1) == 'A'
        tend = 20;
    else
        tend = 40;
    end
    subplot(length(am)/3,3,k1)
    for k = 1:length(un)
        histogram(tAmacGr(ggGr.Window==un(k),k1),4:tend,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{k1}]);
        hold on
    end
    hold off
    legend(strcat('W=',num2str(un)),'location','best');
end
sgtitle('W (Janela do método) [h]');

export_fig([sv,'hist_W'],'-png','-m5','-transparent');
savefig([sv,'hist_W']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%% Method %%%%%%%%%%

un = unique(ggGr.Method);
countNum = zeros(length(un),1);

for k = 1:length(un)
    idx = strfind(ggGr.Method,un{k});
    countNum(k) = nnz(not(cellfun('isempty',idx)));
end

countMeth = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];

for k1 = 1:length(am)
    if am{k1}(1) == 'A'
        tend = 20;
    else
        tend = 40;
    end
    subplot(length(am)/3,3,k1)
    for k = 1:length(un)
        histogram(tAmacGr(ggGr.Method==convertCharsToStrings(un{k}),k1),4:tend,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{k1}]);
        hold on
    end
    hold off
    legend(un,'location','best');
end

legend(un,'location','best');
sgtitle('Método');

export_fig([sv,'hist_method'],'-png','-m5','-transparent');
savefig([sv,'hist_method']);
%%

un = unique(table(ggGr.Grandeza,ggGr.Method),'rows');
for k = 1:height(un)
    idx = strcmp(ggGr.Method,un{k,2})& strcmp(ggGr.Grandeza,un{k,1});
    countNum(k) = nnz(idx);
end

countGranMeth = table(un,countNum)

%%

figure;

cl = distinguishable_colors(10);

for k = 1:6
    subplot(2,3,k)
    switch k
        case 1
            tt = 'M';
            x = [countM.countNum; 0];
            leg = ["1:  ","5:  ","10: ","30: "];
        case 2
            tt = 'N';
            x = countN.countNum;
            leg = ["1: ","3: ","5: "];
        case 3
            tt = 'D';
            x = countD.countNum;
            leg = ["1:  ","10: ","30: "];
        case 4
            tt = 'Grandeza';
            x = [countGran.countNum; 0;0;0;0;0;0];
            leg = ["Corrente - curtose: ","Corrente - eficaz: ","Corrente - variância: ",...
                   "Vibração sup. - curtose: ","Vibração sup. - eficaz: ","Vibração sup. - variância: ",...
                   "Vibração inf. - curtose: ","Vibração inf. - eficaz: ","Vibração inf. - variância: ",...
                   "Vazão: "];
        case 5
            tt = 'Método';
            x = [0;countMeth.countNum];
            leg = ["\bf \rm I:   ","\bf \rm II:  ","\bf \rm III: "];
        case 6
            tt = 'W';
            x = [countW.countNum;0];
            leg = ["0,5: ","1:  ","1,5: ","2:  "];
    end
    leg = strcat(leg',num2str(x));
    x(x==0) = eps;
    pie(x,repmat("",length(x),1));
    ax = gca;
    legend(leg,'location','eastoutside');
    ax.Colormap = cl(1:length(x),:);
    title(tt)
end