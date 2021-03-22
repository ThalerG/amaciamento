clearvars -except B N M D minT thr

load('EnDataA.mat');

% Tempos de amaciamento esperados:

tEst{1} = 4.4;

tEst{2} = [7.5;
           2.5; 
           2.5;
           2.5];
       
tEst{3} = [11.8;
           2.5;
           2.5];
         
tEst{4} = [6;
           2.5;
           2.5;
           2.1];

tEst{5} = [12.5;
           2.5;
           2.5];
       
       
map = [54,167,232;
       246,41,41;
       234,242,20;
       72,242,20]/255;
   
for k1 = 1:length(EnData)
    fig = figure;
    fig.Position = [145.8000 519.4000 1268 242.6000];
    tmax = 0;
    tk = [];
    for k2 = 1:length(EnData{k1})
        if k2 == 1
            tk{length(EnData{k1})-k2+1} = 'Não amaciado';
        else
            tk{length(EnData{k1})-k2+1} = ['Amaciado ',num2str(k2-1)];
        end
        
        [Xobs,Yreal,tempo] = preTrain({EnData{k1}(k2)},{tEst{k1}(k2)},N,M,D,minT);
        tmax = max([tmax,tempo(end)]);
        yPred = mnrval(B,Xobs);
        yPred = yPred(:,2);
        yPred = yPred>thr;
        yRes = nan(size(Yreal));
        yRes(~Yreal & ~yPred) = 1;
        yRes(~Yreal & yPred) = 2;
        yRes(Yreal & ~yPred) = 3;
        yRes(Yreal & yPred) = 4;
        colormap(map);
        h = color_line(tempo,ones(size(tempo))*(length(EnData{k1})-k2+1),yRes','LineWidth',8); hold on;
    end
    hold off; title(['Amostra A', num2str(k1)]);
    ylim([0.5,length(EnData{k1})+0.5]);
    xlim([tempo(1),tmax]); xlabel('Tempo [h]'); ylabel('');
    yticks(1:length(EnData{k1}))
    yticklabels(tk);
    
    hold on;
    L(1) = plot(nan,nan,'color',map(1,:),'LineWidth',8);
    L(2) = plot(nan,nan,'color',map(2,:),'LineWidth',8);
    L(3) = plot(nan,nan,'color',map(3,:),'LineWidth',8);
    L(4) = plot(nan,nan,'color',map(4,:),'LineWidth',8);
    hold off;
    
    legend(L,{'TN','FP', 'FN', 'TP'},'location','southeast');
    set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
    
    savefig(['lr_am',num2str(k1)]);
    export_fig(['lr_am',num2str(k1)],'-m5','-png','-transparent');
end