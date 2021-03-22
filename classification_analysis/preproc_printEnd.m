str = ['Análise de parâmetros de pré-processamento encerrada em: ', num2str(cend(3)), '/', num2str(cend(2),'%02.f'), '/', num2str(cend(1),'%02.f'), '  ', num2str(cend(4),'%02.f'), ':', num2str(cend(5),'%02.f'), ':' num2str(cend(6),'%02.f')];
str = [str, '\n\nDuração total da tarefa: ', num2str(cdur(1)), ':' , num2str(cdur(2),'%02.f'), ':' num2str(cdur(3),'%02.f')];
str = [str, '\n\nMelhores ', num2str(min([10,height(preProcAnTable)])), ' resultados:\n'];

fprintf(fid,str);

writetable2eof(fid, preProcAnTable(1:min([10,height(preProcAnTable)]),:));

str = ['\nArquivos salvos em ',strrep(fsave_preProc,'\','\\'),':\n'];
str = [str 'parameters.m -> Parâmetros da busca (N, D, M, critério de seleção (selMethod), e beta para cálculo de Fbeta-Score (selBeta)\n'];
str = [str 'results_rawMatrix.m -> Matriz preProcAn, de dimensões length(N) x length(M) x length(D) de estrutura contendo resultados:\n'];
str = [str '\tpreProcAn.N -> número de features por grandeza\n'];
str = [str '\tpreProcAn.M -> janela do filtro de média móvel\n'];
str = [str '\tpreProcAn.D -> espaçamento entre amostras\n'];
str = [str '\tpreProcAn.ROC_AUC_Train -> ROC-AUC do conjunto de treino\n'];
str = [str '\tpreProcAn.fselBeta_Train -> Fbeta-score do conjunto de treino\n'];
str = [str '\tpreProcAn.preProc.MMC_Train -> MMC do conjunto de treino\n'];
str = [str '\tpreProcAn.ROC_AUC_Test -> ROC-AUC do conjunto de teste\n'];
str = [str '\tpreProcAn.fselBeta_Test -> Fbeta-score do conjunto de teste\n'];
str = [str '\tpreProcAn.MMC_Test -> MMC do conjunto de teste\n'];
str = [str '\tpreProcAn.time_Train -> Tempo para treinamento do modelo [s]\n'];
str = [str 'results_rankedTable.m -> Tabela (preProcAnTable) contendo as informações da busca\n'];
str = [str 'preproc_graph_MMC_Train.m e .pdf -> MMC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'preproc_graph_ROCAUC_Train.m e .pdf -> ROC-AUC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'preproc_graph_fBeta_Train.m e .pdf -> Fbeta-score do conjunto de treino em torno do ponto máximo\n'];
str = [str 'preproc_graph_MMC_Test.m e .pdf -> MMC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'preproc_graph_ROCAUC_Test.m e .pdf -> ROC-AUC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'preproc_graph_fBeta_Test.m e .pdf -> Fbeta-score do conjunto de treino em torno do ponto máximo\n\n\n'];

fprintf(fid,str);