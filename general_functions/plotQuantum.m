close all;
load('D:\Documentos\Amaciamento\Ferramentas\ProjetoMatlab\EnDataB')

for k1 = 1:length(EnDataB)
    fig = figure;
    t = Inf;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).cRMS); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
    end
    xlabel('Tempo [h]'); ylabel('Corrente [A]');
    legend({'Amaciado 1', 'Amaciado 2'},'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 t]);
    fig.Position = [2.466000000000000e+02 205 1.193600000000000e+03 4.821466650085724e+02/2];
    hold off;
    export_fig(['corRMS',num2str(k1+2)],'-m5','-png','-transparent');
end

for k1 = 2:length(EnDataB)
    fig = figure;
    t = Inf;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).vaz); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
    end
    xlabel('Tempo [h]'); ylabel('Vazão [kg/h]');
    legend({'Não Amaciado', 'Amaciado 1', 'Amaciado 2'},'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 t]);
    fig.Position = [2.466000000000000e+02 205 1.193600000000000e+03 4.821466650085724e+02/2];
    hold off;
    export_fig(['vaz',num2str(k1+2)],'-m5','-png','-transparent');
end

for k1 = 2:length(EnDataB)
    fig = figure;
    t = Inf;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).cKur); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
    end
    xlabel('Tempo [h]'); ylabel('Curtose da Corrente [adim]');
    legend({'Não Amaciado', 'Amaciado 1', 'Amaciado 2'},'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 t]);
    fig.Position = [2.466000000000000e+02 205 1.193600000000000e+03 4.821466650085724e+02/2];
    hold off;
    export_fig(['corKur',num2str(k1+2)],'-m5','-png','-transparent');
end

for k1 = 2:length(EnDataB)
    fig = figure;
    t = Inf;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).vInfRMS); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
    end
    xlabel('Tempo [h]'); ylabel('Vibração [g]');
    legend({'Não Amaciado', 'Amaciado 1', 'Amaciado 2'},'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 t]);
    fig.Position = [2.466000000000000e+02 205 1.193600000000000e+03 4.821466650085724e+02/2];
    hold off;
    export_fig(['vInfRMS',num2str(k1+2)],'-m5','-png','-transparent');
end