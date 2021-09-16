str = ['%%%%%%%% Parâmetros da busca heurística estatística-R %%%%%%%%%%%%%%%%\n\nEscopo da busca:'];
str = [str, '\n  lambda1: ', array2minstr(L1)];
str = [str, '\n  lambda2: ', array2minstr(L2)];
str = [str, '\n  lambda3: ', array2minstr(L3)];
str = [str, '\n  Rc: ', array2minstr(Rc)];

str = [str, '\n\nNúmero de iterações: ', num2str(numIt)];

str = [str, '\n\nProcesso iniciado em: ', num2str(cstart(3)), '/', num2str(cstart(2),'%02.f'), '/', num2str(cstart(1),'%02.f'), '  ', num2str(cstart(4),'%02.f'), ':', num2str(cstart(5),'%02.f'), ':' num2str(cstart(6),'%02.f')];

str = [str,'\n\n'];

fprintf(fid,str);
clear str;