str = ['%%%%%%%% Seleção de grandezas/features %%%%%%%%%%%%%%%%\n\n'];
str = [str, '\n\n Método de seleção: '];
if isequal(FSmethod(1:4),'hex_')
    str = [str 'Poda extensiva de grandezas'];
    switch FSmethod(5:end)
        case 'mRMR'
            str = [str, ' com classificação por mRMR e número máximo de features = ',num2str(maxFeatures)];
        case 'none'
            % Nada
        otherwise
            error(['Feature selection "', FSmethod,'" not recognized'])
    end
elseif isequal(FSmethod(1:4),'hgr_')
    str = [str 'Poda greedy de grandezas'];
    switch FSmethod(5:end)
        case 'mRMR'
            str = [str, ' com classificação por mRMR e número máximo de features = ',num2str(maxFeatures)];
        case 'none'
            % Nada
        otherwise
            error(['Feature selection "', FSmethod,'" not recognized'])
    end
else
    switch FSmethod
        case 'none'
            str = [str, 'Nenhum'];
        case 'mRMR'
            str = [str, 'Classificação por mRMR e número máximo de features = ',num2str(maxFeatures)];
        otherwise
            error(['Feature selection "', FSmethod,'" not recognized'])
    end
end

str = [str, '\n  Grandezas iniciais: '];
for k = 1:length(vars)
    str = [str, vars{k}];
    if k ~= length(vars)
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