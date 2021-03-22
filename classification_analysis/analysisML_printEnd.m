str = ['Análise de hiperparâmetros encerrada em: ', num2str(cend(3)), '/', num2str(cend(2),'%02.f'), '/', num2str(cend(1),'%02.f'), '  ', num2str(cend(4),'%02.f'), ':', num2str(cend(5),'%02.f'), ':' num2str(cend(6),'%02.f')];
str = [str, '\n\nDuração total da tarefa: ', num2str(cdur(1)), ':' , num2str(cdur(2),'%02.f'), ':' num2str(cdur(3),'%02.f')];
str = [str, '\n\nMelhores ', num2str(min([10,height(analysisMLAnTable)])), ' resultados:\n'];

fprintf(fid,str);

writetable2eof(fid, analysisMLAnTable(1:min([10,height(analysisMLAnTable)]),:));

str = ['\nArquivos salvos em ',strrep(fsave_analysisML,'\','\\'),':\n'];
str = [str 'parameters.m -> Parâmetros da busca (critério de seleção (selMethod), beta para cálculo de Fbeta-Score (selBeta), tipo de classificador (methodML) e hiperparâmetros da busca (paramMLBusca))\n'];
str = [str 'results_rawMatrix.m -> Matriz analysisMLAn contendo resultados\n'];
str = [str 'results_rankedTable.m -> Tabela (analysisMLAnTable) contendo as informações da busca\n'];

fprintf(fid,str);