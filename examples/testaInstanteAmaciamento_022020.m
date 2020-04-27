%% Graficos apresentação
%clear;

addpath('C:\Users\G. Thaler\Documents\Projeto Amaciamento\Ferramentas');

fpr = 'C:\Users\G. Thaler\Documents\Projeto Amaciamento\Dados Processados\';
fsave = 'C:\Users\G. Thaler\Documents\Projeto Amaciamento\Apresentações\fev-2020\';

w = 25;
r = 36;
s = 5.9e-4;
f = 0;

fsm3 = {'Amostra 3\N_2019-12-04\';
        'Amostra 3\A_2019-12-09\';
        'Amostra 3\A_2019-12-11\'};

fsm4 = {'Amostra 4\N_2019-12-16\';
        'Amostra 4\A_2019-12-19\';
        'Amostra 4\A_2020-01-06\';
        'Amostra 4\A_2020-01-13\'};

fsm5 = {'Amostra 5\N_2020-01-22\';
        'Amostra 5\A_2020-01-27\';
        'Amostra 5\A_2020-01-28\';};

fpath3 = strcat(fpr,fsm3);
fpath4 = strcat(fpr,fsm4);
fpath5 = strcat(fpr,fsm5);

%% Corrente derivada

loadPath = strcat(fpath3,'corrente_RMS.mat');

tend = inf;

fig = figure;
fig.Position = [fig.Position(1:2)-[0,500],900,length(loadPath)*300];

for k = 1:length(loadPath)
    load(loadPath{k});
    subplot(length(loadPath),1,k);
    dataF = cRMS.data(cRMS.t>0); t = cRMS.t(cRMS.t>0);
    [n,ta] = runin_detect_singleavg(dataF,t,w,r,s,f);
    dataF = derMed(cRMS.data(cRMS.t>0),w);
    hold on; plot(t(t>0), dataF);
    yl = ylim();
    tend = min(cRMS.t(end),tend); 
    line([ta,ta],[0 10],'LineStyle','--'); hold off;
    ylim(yl);
    title(['Amaciamento ',fsm3{k}]); xlabel('Tempo [h]'); ylabel('Corrente [A]');
    legend({'Corrente','Amaciamento'},'location','best')
end
for k = 1:length(loadPath)
    subplot(length(loadPath),1,k);
    xlim([0 24]); 
end

%% Corrente derivada

loadPath = strcat(fpath4,'corrente_RMS.mat');

tend = inf;

fig = figure;
fig.Position = [fig.Position(1:2)-[0,500],900,length(loadPath)*300];

for k = 1:length(loadPath)
    load(loadPath{k});
    subplot(length(loadPath),1,k);
    dataF = cRMS.data; t = cRMS.t;
    [n,ta] = runin_detect_singleavg(dataF,t,w,r,s,f);
    hold on; plot(t(t>0), dataF(t>0));
    yl = ylim();
    tend = min(cRMS.t(end),tend); 
    line([ta,ta],[0 10],'LineStyle','--'); hold off;
    ylim(yl);
    title(['Amaciamento ',fsm4{k}]); xlabel('Tempo [h]'); ylabel('Corrente [A]');
    legend({'Corrente','Amaciamento'},'location','best')
end
for k = 1:length(loadPath)
    subplot(length(loadPath),1,k);
    xlim([0 24]); 
end

%% Corrente derivada

loadPath = strcat(fpath5,'corrente_RMS.mat');

tend = inf;

fig = figure;
fig.Position = [fig.Position(1:2)-[0,500],900,length(loadPath)*300];

for k = 1:length(loadPath)
    load(loadPath{k});
    subplot(length(loadPath),1,k);
    dataF = cRMS.data; t = cRMS.t;
    [n,ta] = runin_detect_singleavg(dataF,t,w,r,s,f);
    hold on; plot(t(t>0), dataF(t>0));
    yl = ylim();
    tend = min(cRMS.t(end),tend); 
    line([ta,ta],[0 10],'LineStyle','--'); hold off;
    ylim(yl);
    title(['Amaciamento ',fsm5{k}]); xlabel('Tempo [h]'); ylabel('Corrente [A]');
    legend({'Corrente','Amaciamento'},'location','best')
end
for k = 1:length(loadPath)
    subplot(length(loadPath),1,k);
    %xlim([0 24]); 
end
