str = ['Análise por diferença espaçada encerrada em: ', num2str(cend(3)), '/', num2str(cend(2),'%02.f'), '/', num2str(cend(1),'%02.f'), '  ', num2str(cend(4),'%02.f'), ':', num2str(cend(5),'%02.f'), ':' num2str(cend(6),'%02.f')];
str = [str, '\n\nDuração total da tarefa: ', num2str(cdur(1)), ':' , num2str(cdur(2),'%02.f'), ':' num2str(cdur(3),'%02.f')];
str = [str, '\n\nMelhores ', num2str(min([10,height(spcDifAnTable)])), ' resultados:\n'];

fprintf(fid,str);

writetable2eof(fid, spcDifAnTable(1:min([10,height(spcDifAnTable)]),:));

str = ['\nArquivos salvos em ',strrep(fsave_spcDif,'\','\\'),':\n'];
str = [str 'parameters.m -> Parâmetros da busca (D, M, grandezas, diferença máxima, critério de seleção (selMethod), e beta para cálculo de Fbeta-Score (selBeta)\n'];
str = [str 'results_rawMatrix.m -> Matriz spcDifAn, de dimensões length(M) x length(D) x length(Var) x length(dMax) de estrutura contendo resultados:\n'];
str = [str '\spcDifAn.M -> janela do filtro de média móvel\n'];
str = [str '\spcDifAn.D -> espaçamento entre amostras\n'];
str = [str '\spcDifAn.Var -> grandeza avaliada\n'];
str = [str '\spcDifAn.dMax -> diferença máxima\n'];
str = [str '\spcDifAn.ROC_AUC_Train -> ROC-AUC do conjunto de treino\n'];
str = [str '\spcDifAn.fselBeta_Train -> Fbeta-score do conjunto de treino\n'];
str = [str '\spcDifAn.spcDif.MMC_Train -> MMC do conjunto de treino\n'];
str = [str '\spcDifAn.ROC_AUC_Test -> ROC-AUC do conjunto de teste\n'];
str = [str '\spcDifAn.fselBeta_Test -> Fbeta-score do conjunto de teste\n'];
str = [str '\spcDifAn.MMC_Test -> MMC do conjunto de teste\n'];
str = [str '\spcDifAn.time_Train -> Tempo para treinamento do modelo [s]\n'];
str = [str 'results_rankedTable.m -> Tabela (spcDifAnTable) contendo as informações da busca\n'];
str = [str 'spcDif_graph_MMC_Train.m e .pdf -> MMC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'spcDif_graph_ROCAUC_Train.m e .pdf -> ROC-AUC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'spcDif_graph_fBeta_Train.m e .pdf -> Fbeta-score do conjunto de treino em torno do ponto máximo\n'];
str = [str 'spcDif_graph_MMC_Test.m e .pdf -> MMC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'spcDif_graph_ROCAUC_Test.m e .pdf -> ROC-AUC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'spcDif_graph_fBeta_Test.m e .pdf -> Fbeta-score do conjunto de treino em torno do ponto máximo\n\n\n'];

fprintf(fid,str);