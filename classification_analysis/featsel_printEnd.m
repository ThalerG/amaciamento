str = ['Sele��o de features/grandezas encerrada em: ', num2str(cend(3)), '/', num2str(cend(2),'%02.f'), '/', num2str(cend(1),'%02.f'), '  ', num2str(cend(4),'%02.f'), ':', num2str(cend(5),'%02.f'), ':' num2str(cend(6),'%02.f')];
str = [str, '\n\nDura��o total da tarefa: ', num2str(cdur(1)), ':' , num2str(cdur(2),'%02.f'), ':' num2str(cdur(3),'%02.f')];
str = [str, '\n\nMelhores ', num2str(min([10,height(featSelAnTable)])), ' resultados:\n'];

fprintf(fid,str);

writetable2eof(fid, featSelAnTable(1:min([10,height(featSelAnTable)]),:));

str = ['\nArquivos salvos em ',strrep(fsave_featSel,'\','\\'),':\n'];
str = [str 'parameters.m -> Par�metros da busca (grandezas iniciais (vars), crit�rio de sele��o (selMethod), beta para c�lculo de Fbeta-Score (selBeta) e n�mero m�ximo de features no caso de filtragem(maxFeatures)\n'];
str = [str 'results_rawMatrix.m -> Matriz featSelAn contendo resultados:\n'];
str = [str '\tfeatSelAn.N -> n�mero de features por grandeza\n'];
str = [str '\tfeatSelAn.M -> janela do filtro de m�dia m�vel\n'];
str = [str '\tfeatSelAn.Vars -> espa�amento entre amostras\n'];
str = [str '\tfeatSelAn.ROC_AUC_Train -> ROC-AUC do conjunto de treino\n'];
str = [str '\tfeatSelAn.fselBeta_Train -> Fbeta-score do conjunto de treino\n'];
str = [str '\tfeatSelAn.preProc.MMC_Train -> MMC do conjunto de treino\n'];
str = [str '\tfeatSelAn.ROC_AUC_Test -> ROC-AUC do conjunto de teste\n'];
str = [str '\tfeatSelAn.fselBeta_Test -> Fbeta-score do conjunto de teste\n'];
str = [str '\tfeatSelAn.MMC_Test -> MMC do conjunto de teste\n'];
str = [str '\tfeatSelAn.time_Train -> Tempo para treinamento do modelo [s]\n'];
str = [str 'results_rankedTable.m -> Tabela (featSelAnTable) contendo as informa��es da busca\n'];
str = [str 'featSel_graph_ROC_AUC.m e .pdf -> Comparativo da ROC-AUC dos ' num2str(min([5,height(featSelAnTable)])), ' melhores grupos de vari�veis\n'];
str = [str 'featSel_graph_fBeta.m e .pdf -> Comparativo do Fbeta-score dos ' num2str(min([5,height(featSelAnTable)])), ' melhores grupos de vari�veis (Beta = ' ,num2str(selBeta), ')\n'];
str = [str 'featSel_graph_MMC.m e .pdf -> Comparativo do MMC dos ' num2str(min([5,height(featSelAnTable)])), ' melhores grupos de vari�veis\n'];

fprintf(fid,str);
clear str;