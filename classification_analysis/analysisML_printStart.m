str = '%%%%%%%% Análise de hiperparâmetros %%%%%%%%%%%%%%%%\n\n';
str = [str, '\n\n Modelo de classificação: '];

switch methodML
    case 'logReg'
        str = [str, 'regressão logística'];
    case 'tree'
        str = [str, 'árvore'];
        str = [str, '\n\n  Parâmetros da busca: '];
        str = [str, '\n  Número máximo de splits: ', array2minstr(paramMLBusca{1})];
    case 'SVM'
        str = [str, 'SVM'];
        str = [str, '\n\n  Parâmetros da busca: '];
        str = [str, '\n  Funções do kernel: ']; temp = paramMLBusca{1};
        for k = 1:length(temp)
            str = [str, temp{k}];
            if k ~= length(temp)
                str = [str, ', '];
            end
        end
        str = [str, '\n  Escalas do kernel: ', array2minstr(paramMLBusca{2})];
    case 'KNN'
        str = [str, 'K nearest neighbors'];
        str = [str, '\n\n  Parâmetros da busca: '];
        str = [str, '\n  Número de neighbors: ', array2minstr(paramMLBusca{1})];
        str = [str, '\n  Distâncias: ']; temp = paramMLBusca{2};
        for k = 1:length(temp)
            str = [str, temp{k}];
            if k ~= length(temp)
                str = [str, ', '];
            end
        end
        str = [str, '\n  Pesos: ']; temp = paramMLBusca{3};
        for k = 1:length(temp)
            str = [str, temp{k}];
            if k ~= length(temp)
                str = [str, ', '];
            end
        end
        clear temp;
end

str = [str, '\n\nGrandezas utilizadas para análise: '];

for k = 1:length(varsSel)
    str = [str, varsSel{k}];
    if k ~= length(varsSel)
        str = [str, ', '];
    end
end

str = [str, '\n\n  N: ', num2str(N)];
str = [str, '\n  M: ', num2str(M)];
str = [str, '\n  D: ', num2str(D)];
str = [str, '\n\nProcesso iniciado em: ', num2str(cstart(3)), '/', num2str(cstart(2),'%02.f'), '/', num2str(cstart(1),'%02.f'), '  ', num2str(cstart(4),'%02.f'), ':', num2str(cstart(5),'%02.f'), ':' num2str(cstart(6),'%02.f')];
str = [str,'\n\n'];
fprintf(fid,str);
clear str;