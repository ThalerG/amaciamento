str = ['%%%%%%%% Par�metros de pr� processamento %%%%%%%%%%%%%%%%\n\nEscopo da busca:'];
str = [str, '\n  N: ', array2minstr(N)];
str = [str, '\n  M: ', array2minstr(M)];
str = [str, '\n  D: ', array2minstr(D)];
str = [str, '\n  Janela m�xima: ', num2str(wMax), ' h'];

str = [str, '\n\nN�mero de itera��es: ', num2str(numIt)];

str = [str, '\n\nProcesso iniciado em: ', num2str(cstart(3)), '/', num2str(cstart(2),'%02.f'), '/', num2str(cstart(1),'%02.f'), '  ', num2str(cstart(4),'%02.f'), ':', num2str(cstart(5),'%02.f'), ':' num2str(cstart(6),'%02.f')];

str = [str,'\n\n'];

fprintf(fid,str);
clear str;