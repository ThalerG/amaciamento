switch methodML
    case 'logReg'
        
    case 'tree'
        % MMC
        figure;
        analysisMLAnTable = sortrows(analysisMLAnTable,'maxSplits','ascend');
        plot(analysisMLAnTable.maxSplits, analysisMLAnTable.MMC_Train); hold on;
        plot(analysisMLAnTable.maxSplits, analysisMLAnTable.MMC_Test); hold off;
        ylabel('MMC'); xlabel('Maximum number of splits'); legend({'Treino','Teste'},'location','best');
        
        savefig([fsave_analysisML,'analysisML_graph_MMC.fig']);
        export_fig([fsave_analysisML,'analysisML_graph_MMC'],'-pdf','-transparent');
        close all;
        
        % ROC-AUC
        plot(analysisMLAnTable.maxSplits, analysisMLAnTable.ROC_AUC_Train); hold on;
        plot(analysisMLAnTable.maxSplits, analysisMLAnTable.ROC_AUC_Test); hold off;
        ylabel('ROC-AUC'); xlabel('Maximum number of splits'); legend({'Treino','Teste'},'location','best');
        
        savefig([fsave_analysisML,'analysisML_graph_ROC_AUC.fig']);
        export_fig([fsave_analysisML,'analysisML_graph_ROC_AUC'],'-pdf','-transparent');
        close all;
        
        % Fbeta-score
        plot(analysisMLAnTable.maxSplits, analysisMLAnTable.fselBeta_Train); hold on;
        plot(analysisMLAnTable.maxSplits, analysisMLAnTable.fselBeta_Test); hold off;
        ylabel(['Fbeta-score (beta = ',num2str(selBeta), ')']); xlabel('Maximum number of splits'); legend({'Treino','Teste'},'location','best');
        
        savefig([fsave_analysisML,'analysisML_graph_fBeta.fig']);
        export_fig([fsave_analysisML,'analysisML_graph_fBeta'],'-pdf','-transparent');
        close all;
    case 'SVM'
        % MMC
        graph = nan(height(analysisMLAnTable),2);
        name = cell(1,height(analysisMLAnTable));
        for k = 1:height(analysisMLAnTable)
            graph(k,1) = analysisMLAnTable(k,:).MMC_Train;
            graph(k,2) = analysisMLAnTable(k,:).MMC_Test;
            name{k} = [analysisMLAnTable(k,:).kernelFunction,', ',analysisMLAnTable(k,:).kernelScale];
        end
        figure;
        bar(graph); xlabel('Função, scale'); ylabel('MMC'); legend({'Treino','Teste'}, 'location','best');

        savefig([fsave_analysisML,'analysisML_graph_MMC.fig']);
        export_fig([fsave_analysisML,'analysisML_graph_MMC'],'-pdf','-transparent');
        close all;

        clear graph name
        
        % ROC-AUC
        graph = nan(height(analysisMLAnTable),2);
        name = cell(1,height(analysisMLAnTable));
        for k = 1:height(analysisMLAnTable)
            graph(k,1) = analysisMLAnTable(k,:).ROC_AUC_Train;
            graph(k,2) = analysisMLAnTable(k,:).ROC_AUC_Test;
            name{k} = [analysisMLAnTable(k,:).kernelFunction,', ',analysisMLAnTable(k,:).kernelScale];
        end
        figure;
        bar(graph); xlabel('Função, scale'); ylabel('ROC-AUC'); legend({'Treino','Teste'}, 'location','best');

        savefig([fsave_analysisML,'analysisML_graph_ROC_AUC.fig']);
        export_fig([fsave_analysisML,'analysisML_graph_ROC_AUC'],'-pdf','-transparent');
        close all;

        clear graph name
        
        % Fbeta-score
        graph = nan(height(analysisMLAnTable),2);
        name = cell(1,height(analysisMLAnTable));
        for k = 1:height(analysisMLAnTable)
            graph(k,1) = analysisMLAnTable(k,:).fselBeta_Train;
            graph(k,2) = analysisMLAnTable(k,:).fselBeta_Test;
            name{k} = [analysisMLAnTable(k,:).kernelFunction,', ',analysisMLAnTable(k,:).kernelScale];
        end
        figure;
        bar(graph); xlabel('Função, scale'); ylabel(['Fbeta-score (beta = ',num2str(selBeta), ')']);
        legend({'Treino','Teste'}, 'location','best');

        savefig([fsave_analysisML,'analysisML_graph_fBeta.fig']);
        export_fig([fsave_analysisML,'analysisML_graph_fBeta'],'-pdf','-transparent');
        close all;

        clear graph name
        
    case 'KNN'
        params = unique(analysisMLAnTable(:,{'distance','weight'}),'rows');
        % MMC
        figure;
        leg = {};
        for k = 1:height(params)
            temp = analysisMLAnTable(strcmp(analysisMLAnTable.distance,params.distance(k))&strcmp(analysisMLAnTable.weight,params.weight(k)),:);
            
            temp = sortrows(temp,'numNeighbors','ascend');
            plot(temp.numNeighbors, temp.MMC_Train); hold on;
            plot(temp.numNeighbors, temp.MMC_Test);
            
            leg = [leg, [params.distance{k},' distance, ',params.weight{k},' weight, Train'],[params.distance{k},' distance, ',params.weight{k},' weight, Test']];
        end
        hold off;
        
        ylabel('MMC'); xlabel('Number of neighbors'); legend(leg,'location','best');
        savefig([fsave_analysisML,'analysisML_graph_MMC.fig']);
        export_fig([fsave_analysisML,'analysisML_graph_MMC'],'-pdf','-transparent');
        close all;
        
        % ROC-AUC
        figure;
        leg = {};
        for k = 1:height(params)
            temp = analysisMLAnTable(strcmp(analysisMLAnTable.distance,params.distance(k))&strcmp(analysisMLAnTable.weight,params.weight(k)),:);
            
            temp = sortrows(temp,'numNeighbors','ascend');
            plot(temp.numNeighbors, temp.ROC_AUC_Train); hold on;
            plot(temp.numNeighbors, temp.ROC_AUC_Test);
            
            leg = [leg, [params.distance{k},' distance, ',params.weight{k},' weight, Train'],[params.distance{k},' distance, ',params.weight{k},' weight, Test']];
        end
        hold off;
        
        ylabel('ROC-AUC'); xlabel('Number of neighbors'); legend(leg,'location','best');
        savefig([fsave_analysisML,'analysisML_graph_ROC_AUC.fig']);
        export_fig([fsave_analysisML,'analysisML_graph_ROC_AUC'],'-pdf','-transparent');
        close all;
        
        % Fbeta-score
        figure;
        leg = {};
        for k = 1:height(params)
            temp = analysisMLAnTable(strcmp(analysisMLAnTable.distance,params.distance(k))&strcmp(analysisMLAnTable.weight,params.weight(k)),:);
            
            temp = sortrows(temp,'numNeighbors','ascend');
            plot(temp.numNeighbors, temp.fselBeta_Train); hold on;
            plot(temp.numNeighbors, temp.fselBeta_Test);
            
            leg = [leg, [params.distance{k},' distance, ',params.weight{k},' weight, Train'],[params.distance{k},' distance, ',params.weight{k},' weight, Test']];
        end
        hold off;
        ylabel(['Fbeta-score (beta = ',num2str(selBeta), ')']); xlabel('Number of neighbors'); legend(leg,'location','best');
        
        savefig([fsave_analysisML,'analysisML_graph_fBeta.fig']);
        export_fig([fsave_analysisML,'analysisML_graph_fBeta'],'-pdf','-transparent');
        close all;
end

clear leg k temp params