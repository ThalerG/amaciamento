am = t.Amostra{1};

temp = t((t.Pass == true),:);

tAmac = nan(height(temp),length(t.TimeDetect(1)));
tJaAmac = nan(height(temp),length(t.TimeDetect(1)));

for k1 = 1:height(temp)
    TDec = temp.TimeDetect(k1,:);
    for k2 = 1:length(TDec)
        TimeAmac = TDec{k2};
        tAmac(k1,k2) = TimeAmac(1);
        tJaAmac(k1,k2) = max(TimeAmac(2:3));
    end    
end

ggGr = temp((min(tAmac,[],2)>=4)&(max(tJaAmac,[],2)<5),:);
tAmacGr = tAmac((min(tAmac,[],2)>=4)&(max(tJaAmac,[],2)<5),:);

sv = 'D:\Documentos\Amaciamento\Ferramentas\ProjetoMatlab\unsupervised\AmAll\';

%% %%%%%%%%%%%%%%%%%%%%%%%%%% Grandeza %%%%%%%%%%

un = unique(ggGr.Grandeza);
countNum = zeros(length(un),1);

for k = 1:length(un)
    idx = strfind(ggGr.Grandeza,un{k});
    countNum(k) = nnz(not(cellfun('isempty',idx)));
end

count = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];
subplot(2,3,1)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.Grandeza==convertCharsToStrings(un{k}),1),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{1}]);
    hold on
end
hold off
legend(un,'location','best');

subplot(2,3,2)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.Grandeza==convertCharsToStrings(un{k}),2),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{2}]);
    hold on
end
hold off
legend(un,'location','best');

subplot(2,3,3)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.Grandeza==convertCharsToStrings(un{k}),3),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{3}]);
    hold on
end
hold off
legend(un,'location','best');

subplot(2,3,4)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.Grandeza==convertCharsToStrings(un{k}),4),4:40,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{4}]);
    hold on
end
hold off
legend(un,'location','best');

subplot(2,3,5)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.Grandeza==convertCharsToStrings(un{k}),5),4:40,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{5}]);
    hold on
end
hold off
legend(un,'location','best');

subplot(2,3,6)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.Grandeza==convertCharsToStrings(un{k}),6),4:40,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{6}]);
    hold on
end
hold off
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

count = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];
subplot(2,3,1)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.N==un(k),1),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{1}]);
    hold on
end
hold off
legend(strcat('N=',num2str(un)),'location','best');

subplot(2,3,2)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.N==un(k),2),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{2}]);
    hold on
end
hold off
legend(strcat('N=',num2str(un)),'location','best');

subplot(2,3,3)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.N==un(k),3),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{3}]);
    hold on
end
hold off
legend(strcat('N=',num2str(un)),'location','best');
sgtitle('N (Número de Features)');

export_fig([sv,'hist_N'],'-png','-m5','-transparent');
savefig([sv,'hist_N']);
%% %%%%%%%%%%%%%%%%%%%%%%%%%% M %%%%%%%%%%

un = unique(ggGr.M);
countNum = zeros(length(un),1);

for k = 1:length(un)
    countNum(k) = nnz(ggGr.M == un(k));
end

count = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];
subplot(2,3,1)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.M==un(k),1),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{1}]);
    hold on
end
hold off
legend(strcat('M=',num2str(un)),'location','best');

subplot(2,3,2)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.M==un(k),2),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{2}]);
    hold on
end
hold off
legend(strcat('M=',num2str(un)),'location','best');

subplot(2,3,3)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.M==un(k),3),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{3}]);
    hold on
end
hold off
legend(strcat('M=',num2str(un)),'location','best');
sgtitle('M (Janela do filtro) [amostras]');

export_fig([sv,'hist_M'],'-png','-m5','-transparent');
savefig([sv,'hist_M']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%% D %%%%%%%%%%

un = unique(ggGr.D);
countNum = zeros(length(un),1);

for k = 1:length(un)
    countNum(k) = nnz(ggGr.D == un(k));
end

count = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];
subplot(2,3,1)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.D==un(k),1),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{1}]);
    hold on
end
hold off
legend(strcat('D=',num2str(un)),'location','best');

subplot(2,3,2)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.D==un(k),2),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{2}]);
    hold on
end
hold off
legend(strcat('D=',num2str(un)),'location','best');

subplot(2,3,3)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.D==un(k),3),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{3}]);
    hold on
end
hold off
legend(strcat('D=',num2str(un)),'location','best');
sgtitle('D (Lag entre features) [amostras]');

export_fig([sv,'hist_D'],'-png','-m5','-transparent');
savefig([sv,'hist_D']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%% W %%%%%%%%%%

un = unique(ggGr.Window);
countNum = zeros(length(un),1);

for k = 1:length(un)
    countNum(k) = nnz(ggGr.Window == un(k));
end

count = table(un,countNum)
cl = distinguishable_colors(length(un));
fig = figure; fig.Position = [45 342 1248 420];
subplot(2,3,1)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.Window==un(k),1),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{1}]);
    hold on
end
hold off
legend(strcat('W=',num2str(un)),'location','best');

subplot(2,3,2)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.Window==un(k),2),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{2}]);
    hold on
end
hold off
legend(strcat('W=',num2str(un)),'location','best');

subplot(2,3,3)
for k = 1:length(un)
    histogram(tAmacGr(ggGr.Window==un(k),3),4:20,'FaceColor',cl(k,:)); xlabel('Tempo [h]'); ylabel('Frequência'); title(['Amostra ',am{3}]);
    hold on
end
hold off
legend(strcat('W=',num2str(un)),'location','best');
sgtitle('W (Janela do método) [h]');

export_fig([sv,'hist_W'],'-png','-m5','-transparent');
savefig([sv,'hist_W']);