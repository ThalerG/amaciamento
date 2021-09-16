str = '%%%%%%%% Análise de métodos estatísticos %%%%%%%%%%%%%%%%';

str = [str, '\n\nMétrica para performance utilizada:\n'];

switch selMethod
    case 'ROC_AUC'
        str = [str, 'Área abaixo da curva ROC (ROC-AUC)'];
    case 'Fbeta'
        str = [str, 'Fbeta-score com beta = ',num2str(selBeta)];
    case 'MCC'
        str = [str, 'MCC (coeficiente de correlação de Matthews)'];
    otherwise
        error(['Performance metric "', selMethod,'" not recognized'])
end

str = [str, '\n\nGrandezas utilizadas para análise: '];

for k = 1:length(vars)
    str = [str, vars{k}];
    if k ~= length(vars)
        str = [str, ', '];
    end
end

str = [str '\n\n'];

fprintf(fid,str);
clear str