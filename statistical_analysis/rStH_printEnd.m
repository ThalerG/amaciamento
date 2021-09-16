str = ['Análise heurística da estatística R encerrada em: ', num2str(cend(3)), '/', num2str(cend(2),'%02.f'), '/', num2str(cend(1),'%02.f'), '  ', num2str(cend(4),'%02.f'), ':', num2str(cend(5),'%02.f'), ':' num2str(cend(6),'%02.f')];
str = [str, '\n\nDuração total da tarefa: ', num2str(cdur(1)), ':' , num2str(cdur(2),'%02.f'), ':' num2str(cdur(3),'%02.f')];
str = [str, '\n\nMelhores ', num2str(min([10,height(rStHAnTable)])), ' resultados:\n'];

fprintf(fid,str);

writetable2eof(fid, rStHAnTable(1:min([10,height(rStHAnTable)]),:));

str = ['\nArquivos salvos em ',strrep(fsave_rStH,'\','\\'),':\n'];
str = [str 'parameters.m -> Parâmetros da busca (lamda1, lamda2, lamda3, grandezas, Rc, critério de seleção (selMethod), e beta para cálculo de Fbeta-Score (selBeta)\n'];
str = [str 'results_rawMatrix.m -> Matriz rStHAn, de dimensões length(Var) x length(L1) x length(L2) x length(L3) x length(Rc) de estrutura contendo resultados:\n'];
str = [str '\rStHAn.Var -> grandezas\n'];
str = [str '\rStHAn.L1 -> lambda1\n'];
str = [str '\rStHAn.L2 -> lambda2\n'];
str = [str '\rStHAn.L3 -> lambda3\n'];
str = [str '\rStHAn.Rc -> valor R crítico\n'];
str = [str '\rStHAn.ROC_AUC_Train -> ROC-AUC do conjunto de treino\n'];
str = [str '\rStHAn.fselBeta_Train -> Fbeta-score do conjunto de treino\n'];
str = [str '\rStHAn.rStH.MMC_Train -> MMC do conjunto de treino\n'];
str = [str '\rStHAn.ROC_AUC_Test -> ROC-AUC do conjunto de teste\n'];
str = [str '\rStHAn.fselBeta_Test -> Fbeta-score do conjunto de teste\n'];
str = [str '\rStHAn.MMC_Test -> MMC do conjunto de teste\n'];
str = [str '\rStHAn.time_Train -> Tempo para treinamento do modelo [s]\n'];
str = [str 'results_rankedTable.m -> Tabela (rStHAnTable) contendo as informações da busca\n'];
str = [str 'rStH_graph_MMC_Train.m e .pdf -> MMC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'rStH_graph_ROCAUC_Train.m e .pdf -> ROC-AUC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'rStH_graph_fBeta_Train.m e .pdf -> Fbeta-score do conjunto de treino em torno do ponto máximo\n'];
str = [str 'rStH_graph_MMC_Test.m e .pdf -> MMC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'rStH_graph_ROCAUC_Test.m e .pdf -> ROC-AUC do conjunto de treino em torno do ponto máximo\n'];
str = [str 'rStH_graph_fBeta_Test.m e .pdf -> Fbeta-score do conjunto de treino em torno do ponto máximo\n\n\n'];

fprintf(fid,str);