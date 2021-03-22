% ROC-AUC

graph = nan(min([5,height(featSelAnTable)]),2);

for k = 1:min([5,height(featSelAnTable)])
    graph(k,1) = featSelAnTable(k,:).ROC_AUC_Train;
    graph(k,2) = featSelAnTable(k,:).ROC_AUC_Test;
end

figure;
bar(graph); xlabel('Posição'); ylabel('ROC-AUC'); legend({'Treino','Teste'}, 'location','best');

savefig([fsave_featSel,'featSel_graph_ROC_AUC.fig']);
export_fig([fsave_featSel,'featSel_graph_ROC_AUC'],'-pdf','-transparent');
close all;

clear graph

% Fbeta

graph = nan(min([5,height(featSelAnTable)]),2);

for k = 1:min([5,height(featSelAnTable)])
    graph(k,1) = featSelAnTable(k,:).fselBeta_Train;
    graph(k,2) = featSelAnTable(k,:).fselBeta_Test;
end

figure;
bar(graph); xlabel('Posição'); ylabel(['Fbeta-score (beta = ',num2str(selBeta), ')']); legend({'Treino','Teste'}, 'location','best');

savefig([fsave_featSel,'featSel_graph_fBeta.fig']);
export_fig([fsave_featSel,'featSel_graph_fBeta'],'-pdf','-transparent');
close all;

clear graph

% MMC

graph = nan(min([5,height(featSelAnTable)]),2);

for k = 1:min([5,height(featSelAnTable)])
    graph(k,1) = featSelAnTable(k,:).MMC_Train;
    graph(k,2) = featSelAnTable(k,:).MMC_Test;
end

figure;
bar(graph); xlabel('Posição'); ylabel('MMC'); legend({'Treino','Teste'}, 'location','best');

savefig([fsave_featSel,'featSel_graph_MMC.fig']);
export_fig([fsave_featSel,'featSel_graph_MMC'],'-pdf','-transparent');
close all;

clear graph k