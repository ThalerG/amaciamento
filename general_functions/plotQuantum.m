close all;
load('D:\Documentos\Amaciamento\Ferramentas\ProjetoMatlab\EnDataB')
pt = 'D:\Documentos\Amaciamento\Apresentações\2020-11_mauricio\';

for k1 = 1:length(EnDataB)
    fig = figure;
    t = Inf;
    leg = {};
    n = 1;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).cRMS); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
        if EnDataB{k1}(k2).name(12) == 'A'
            leg = [leg,{['Amaciado ',num2str(n)]}];
            n = n+1;
        else
            leg = [leg,"Não Amaciado"];
            n = n+1;
        end
    end
    xlabel('Tempo [h]'); ylabel('Corrente [A]');
    legend(leg,'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 20]); title(['Amostra B',num2str(k1+1)]);
    fig.Position = [246.6000 233.8000 1.2392e+03 212.2733];
    hold off;
    export_fig([pt,'corRMS',num2str(k1+1)],'-m5','-png','-transparent');
    savefig([pt,'corRMS',num2str(k1+1)]);
end

for k1 = 1:length(EnDataB)
    fig = figure;
    t = Inf;
    leg = {};
    n = 1;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).vaz); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
        if EnDataB{k1}(k2).name(12) == 'A'
            leg = [leg,{['Amaciado ',num2str(n)]}];
            n = n+1;
        else
            leg = [leg,"Não Amaciado"];
            n = n+1;
        end
    end
    xlabel('Tempo [h]'); ylabel('Vazão [kg/h]');
    legend(leg,'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 20]); title(['Amostra B',num2str(k1+1)]);
    fig.Position = [246.6000 233.8000 1.2392e+03 212.2733];
    hold off;
    export_fig([pt,'vaz',num2str(k1+1)],'-m5','-png','-transparent');
    savefig([pt,'vaz',num2str(k1+1)]);
end

for k1 = 1:length(EnDataB)
    fig = figure;
    t = Inf;
    leg = {};
    n = 1;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).cKur); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
        if EnDataB{k1}(k2).name(12) == 'A'
            leg = [leg,{['Amaciado ',num2str(n)]}];
            n = n+1;
        else
            leg = [leg,"Não Amaciado"];
            n = n+1;
        end
    end
    xlabel('Tempo [h]'); ylabel('Curtose [adim]');
    legend(leg,'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 20]); title(['Amostra B',num2str(k1+1)]); ylim([1.48 1.5]);
    fig.Position = [246.6000 233.8000 1.2392e+03 212.2733];
    hold off;
    export_fig(['corKur',num2str(k1+1)],'-m5','-png','-transparent');
    savefig([pt,'corKur',num2str(k1+1)]);
end

for k1 = 1:length(EnDataB)
    fig = figure;
    t = Inf;
    leg = {};
    n = 1;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).vInfRMS); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
        if EnDataB{k1}(k2).name(12) == 'A'
            leg = [leg,{['Amaciado ',num2str(n)]}];
            n = n+1;
        else
            leg = [leg,"Não Amaciado"];
            n = n+1;
        end
    end
    xlabel('Tempo [h]'); ylabel('Vibração [g]');
    legend(leg,'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 20]); title(['Amostra B',num2str(k1+1)]);
    fig.Position = [246.6000 233.8000 1.2392e+03 212.2733];
    hold off;
    export_fig([pt,'vInfRMS',num2str(k1+1)],'-m5','-png','-transparent');
    savefig([pt,'vInfRMS',num2str(k1+1)]);
end

for k1 = 1:length(EnDataB)
    fig = figure;
    t = Inf;
    leg = {};
    n = 1;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).vSupRMS); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
        if EnDataB{k1}(k2).name(12) == 'A'
            leg = [leg,{['Amaciado ',num2str(n)]}];
            n = n+1;
        else
            leg = [leg,"Não Amaciado"];
            n = n+1;
        end
    end
    xlabel('Tempo [h]'); ylabel('Vibração [g]');
    legend(leg,'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 20]); title(['Amostra B',num2str(k1+1)]);
    fig.Position = [246.6000 233.8000 1.2392e+03 212.2733];
    hold off;
    export_fig([pt,'vSupRMS',num2str(k1+1)],'-m5','-png','-transparent');
    savefig([pt,'vSupRMS',num2str(k1+1)]);
end

for k1 = 1:length(EnDataB)
    fig = figure;
    t = Inf;
    leg = {};
    n = 1;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).vInfKur); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
        if EnDataB{k1}(k2).name(12) == 'A'
            leg = [leg,{['Amaciado ',num2str(n)]}];
            n = n+1;
        else
            leg = [leg,"Não Amaciado"];
            n = n+1;
        end
    end
    xlabel('Tempo [h]'); ylabel('Curtose [adim]');
    legend(leg,'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 20]); title(['Amostra B',num2str(k1+1)]);
    fig.Position = [246.6000 233.8000 1.2392e+03 212.2733];
    hold off;
    export_fig([pt,'vInfKur',num2str(k1+1)],'-m5','-png','-transparent');
    savefig([pt,'vInfKur',num2str(k1+1)]);
end

for k1 = 1:length(EnDataB)
    fig = figure;
    t = Inf;
    leg = {};
    n = 1;
    for k2 = 1:length(EnDataB{k1})
        plot(EnDataB{k1}(k2).tempo,EnDataB{k1}(k2).vSupKur); hold on;
        t = min([t,EnDataB{k1}(k2).tempo(end)-0.5]);
        if EnDataB{k1}(k2).name(12) == 'A'
            leg = [leg,{['Amaciado ',num2str(n)]}];
            n = n+1;
        else
            leg = [leg,"Não Amaciado"];
            n = n+1;
        end
    end
    xlabel('Tempo [h]'); ylabel('Curtose [adim]');
    legend(leg,'location','best');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    xlim([0.1 20]); title(['Amostra B',num2str(k1+1)]);
    fig.Position = [246.6000 233.8000 1.2392e+03 212.2733];
    hold off;
    export_fig([pt,'vSupKur',num2str(k1+1)],'-m5','-png','-transparent');
    savefig([pt,'vSupKur',num2str(k1+1)]);
end