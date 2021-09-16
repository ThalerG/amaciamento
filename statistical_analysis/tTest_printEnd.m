str = ['An�lise por teste t encerrada em: ', num2str(cend(3)), '/', num2str(cend(2),'%02.f'), '/', num2str(cend(1),'%02.f'), '  ', num2str(cend(4),'%02.f'), ':', num2str(cend(5),'%02.f'), ':' num2str(cend(6),'%02.f')];
str = [str, '\n\nDura��o total da tarefa: ', num2str(cdur(1)), ':' , num2str(cdur(2),'%02.f'), ':' num2str(cdur(3),'%02.f')];
str = [str, '\n\nMelhores ', num2str(min([10,height(tTestAnTable)])), ' resultados:\n'];

fprintf(fid,str);

writetable2eof(fid, tTestAnTable(1:min([10,height(tTestAnTable)]),:));

str = ['\nArquivos salvos em ',strrep(fsave_tTest,'\','\\'),':\n'];
str = [str 'parameters.m -> Par�metros da busca (N, D, M, grandezas, alpha, crit�rio de sele��o (selMethod), e beta para c�lculo de Fbeta-Score (selBeta)\n'];
str = [str 'results_rawMatrix.m -> Matriz tTestAn, de dimens�es length(N) x length(M) x length(D) x length(Var) x length(Alpha) de estrutura contendo resultados:\n'];
str = [str '\tTestAn.N -> n�mero de features por grandeza\n'];
str = [str '\tTestAn.M -> janela do filtro de m�dia m�vel\n'];
str = [str '\tTestAn.D -> espa�amento entre amostras\n'];
str = [str '\tTestAn.Var -> grandeza avaliada\n'];
str = [str '\tTestAn.Alpha -> signific�ncia\n'];
str = [str '\tTestAn.ROC_AUC_Train -> ROC-AUC do conjunto de treino\n'];
str = [str '\tTestAn.fselBeta_Train -> Fbeta-score do conjunto de treino\n'];
str = [str '\tTestAn.tTest.MMC_Train -> MMC do conjunto de treino\n'];
str = [str '\tTestAn.ROC_AUC_Test -> ROC-AUC do conjunto de teste\n'];
str = [str '\tTestAn.fselBeta_Test -> Fbeta-score do conjunto de teste\n'];
str = [str '\tTestAn.MMC_Test -> MMC do conjunto de teste\n'];
str = [str '\tTestAn.time_Train -> Tempo para treinamento do modelo [s]\n'];
str = [str 'results_rankedTable.m -> Tabela (tTestAnTable) contendo as informa��es da busca\n'];
str = [str 'tTest_graph_MMC_Train.m e .pdf -> MMC do conjunto de treino em torno do ponto m�ximo\n'];
str = [str 'tTest_graph_ROCAUC_Train.m e .pdf -> ROC-AUC do conjunto de treino em torno do ponto m�ximo\n'];
str = [str 'tTest_graph_fBeta_Train.m e .pdf -> Fbeta-score do conjunto de treino em torno do ponto m�ximo\n'];
str = [str 'tTest_graph_MMC_Test.m e .pdf -> MMC do conjunto de treino em torno do ponto m�ximo\n'];
str = [str 'tTest_graph_ROCAUC_Test.m e .pdf -> ROC-AUC do conjunto de treino em torno do ponto m�ximo\n'];
str = [str 'tTest_graph_fBeta_Test.m e .pdf -> Fbeta-score do conjunto de treino em torno do ponto m�ximo\n\n\n'];

fprintf(fid,str);