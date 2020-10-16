clearvars -except B N M D minT thr

load('D:\Documentos\Amaciamento\Ferramentas\ProjetoMatlab\method_logisticRegression\test_2020_09_25\EnData.mat');

% conjVal = [2,1;4,2;5,3]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]
conjVal = [];

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
      
for k1 = 1:size(conjVal,1) % Apaga os valores dos conjuntos de validação
    tEst{conjVal(k1,1)}(conjVal(k1,2)) = [];
    EnData{conjVal(k1,1)}(conjVal(k1,2)) = [];
end

for k1 = 1:length(EnData)
    
    for k2 = 1:length(EnData{k1})
        fig = figure;
        a(1) = subplot(2,1,1);
        plot(EnData{k1}(k2).tempo,EnData{k1}(k2).cRMS,'LineWidth',1,'color','k'); hold on;
        ylabel('Corrente RMS [A]'); set(gca, 'XTickLabel', []);
        if k2 == 1
            title('Não amaciado');
        else
            title(['Amaciado ' num2str(k2-1)]);
        end
        a(1) = gca;
        temp = [];
        [temp(:,1:N),~] = mkTrainData(EnData{k1}(k2).cRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*1+1:N*2),~] = mkTrainData(EnData{k1}(k2).cKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*2+1:N*3),~] = mkTrainData(EnData{k1}(k2).vInfRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*3+1:N*4),~] = mkTrainData(EnData{k1}(k2).vInfKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*4+1:N*5),~] = mkTrainData(EnData{k1}(k2).vSupRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*5+1:N*6),~] = mkTrainData(EnData{k1}(k2).vSupKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*6+1:N*7),tempo] = mkTrainData(EnData{k1}(k2).vaz,EnData{k1}(k2).tempo,N,1,D,tEst{k1}(k2), minT);
        classTemp = strings(length(temp(:,1)),1);
        classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
        classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
        xlim([0,tempo(end)]); yl = ylim;
        line([tEst{k1}(k2),tEst{k1}(k2)],[yl(1),yl(2)],'Color','black','LineStyle','--'); hold off;
        ylim(yl);
        set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
        
        a(2) = subplot(2,1,2);
        classCor = temp;
        prob = mnrval(B,classCor);
        prob = prob(:,2);
        plot(tempo,prob,'LineWidth',1,'color','k'); hold on;
        line([tEst{k1}(k2),tEst{k1}(k2)],[0,1],'Color','black','LineStyle','--');
        line([0,tempo(end)],[thr,thr],'Color','red','LineStyle','--');
        xlim([0, tempo(end)]); ylim([0,1]); hold off;
        ylabel('Probabilidade');
        linkaxes(a,'x'); fig.Position = [2.466000000000000e+02 205 1.193600000000000e+03 4.821466650085724e+02]; xlabel('Tempo [h]');
        xlabel('Tempo [h]');
        set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
            
        tightfig(fig); 
        fig.Position = [2.466000000000000e+02 205 1.193600000000000e+03 4.821466650085724e+02];
        export_fig(['Am' num2str(k1) 'En' num2str(k2)],'-m5','-png','-transparent');
    end
end