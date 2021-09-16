str = ['An�lise por tabela da estat�stica R encerrada em: ', num2str(cend(3)), '/', num2str(cend(2),'%02.f'), '/', num2str(cend(1),'%02.f'), '  ', num2str(cend(4),'%02.f'), ':', num2str(cend(5),'%02.f'), ':' num2str(cend(6),'%02.f')];
str = [str, '\n\nDura��o total da tarefa: ', num2str(cdur(1)), ':' , num2str(cdur(2),'%02.f'), ':' num2str(cdur(3),'%02.f')];
str = [str, '\n\nMelhores ', num2str(min([10,height(rStTbAnTable)])), ' resultados:\n'];

fprintf(fid,str);

writetable2eof(fid, rStTbAnTable(1:min([10,height(rStTbAnTable)]),:));

str = ['\nArquivos salvos em ',strrep(fsave_rStTb,'\','\\'),':\n'];
str = [str 'parameters.m -> Par�metros da busca (D, M, grandezas, diferen�a m�xima, crit�rio de sele��o (selMethod), e beta para c�lculo de Fbeta-Score (selBeta)\n'];
str = [str 'results_rawMatrix.m -> Matriz rStTbAn, de dimens�es length(Var) x length(L1) x length(L23) x length(ALPHA) de estrutura contendo resultados:\n'];
str = [str '\rStTbAn.Var -> grandezas\n'];
str = [str '\rStTbAn.L1 -> lambda1\n'];
str = [str '\rStTbAn.L23 -> lambda2 e lambda3\n'];
str = [str '\rStTbAn.Alpha -> signific�ncia\n'];
str = [str '\rStTbAn.ROC_AUC_Train -> ROC-AUC do conjunto de treino\n'];
str = [str '\rStTbAn.fselBeta_Train -> Fbeta-score do conjunto de treino\n'];
str = [str '\rStTbAn.rStTb.MMC_Train -> MMC do conjunto de treino\n'];
str = [str '\rStTbAn.ROC_AUC_Test -> ROC-AUC do conjunto de teste\n'];
str = [str '\rStTbAn.fselBeta_Test -> Fbeta-score do conjunto de teste\n'];
str = [str '\rStTbAn.MMC_Test -> MMC do conjunto de teste\n'];
str = [str '\rStTbAn.time_Train -> Tempo para treinamento do modelo [s]\n'];
str = [str 'results_rankedTable.m -> Tabela (rStTbAnTable) contendo as informa��es da busca\n'];
str = [str 'rStTb_graph_MMC_Train.m e .pdf -> MMC do conjunto de treino em torno do ponto m�ximo\n'];
str = [str 'rStTb_graph_ROCAUC_Train.m e .pdf -> ROC-AUC do conjunto de treino em torno do ponto m�ximo\n'];
str = [str 'rStTb_graph_fBeta_Train.m e .pdf -> Fbeta-score do conjunto de treino em torno do ponto m�ximo\n'];
str = [str 'rStTb_graph_MMC_Test.m e .pdf -> MMC do conjunto de treino em torno do ponto m�ximo\n'];
str = [str 'rStTb_graph_ROCAUC_Test.m e .pdf -> ROC-AUC do conjunto de treino em torno do ponto m�ximo\n'];
str = [str 'rStTb_graph_fBeta_Test.m e .pdf -> Fbeta-score do conjunto de treino em torno do ponto m�ximo\n\n\n'];

fprintf(fid,str);