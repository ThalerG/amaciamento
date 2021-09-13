str = '%%%%%%%% An�lise de hiperpar�metros %%%%%%%%%%%%%%%%\n\n';
str = [str, '\n\n Modelo de classifica��o: '];

switch methodML
    case 'logReg'
        str = [str, 'regress�o log�stica'];
    case 'tree'
        str = [str, '�rvore'];
        str = [str, '\n\n  Par�metros da busca: '];
        str = [str, '\n  N�mero m�ximo de splits: ', array2minstr(paramMLBusca{1})];
    case 'SVM'
        str = [str, 'SVM'];
        str = [str, '\n\n  Par�metros da busca: '];
        str = [str, '\n  Fun��es do kernel: ']; temp = paramMLBusca{1};
        for k = 1:length(temp)
            str = [str, temp{k}];
            if k ~= length(temp)
                str = [str, ', '];
            end
        end
        str = [str, '\n  Escalas do kernel: ', array2minstr(paramMLBusca{2})];
    case 'KNN'
        str = [str, 'K nearest neighbors'];
        str = [str, '\n\n  Par�metros da busca: '];
        str = [str, '\n  N�mero de neighbors: ', array2minstr(paramMLBusca{1})];
        str = [str, '\n  Dist�ncias: ']; temp = paramMLBusca{2};
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

str = [str, '\n\nGrandezas utilizadas para an�lise: '];

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