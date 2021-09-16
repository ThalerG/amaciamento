str = '%%%%%%%% An�lise de m�todos estat�sticos %%%%%%%%%%%%%%%%';

str = [str, '\n\nM�trica para performance utilizada:\n'];

switch selMethod
    case 'ROC_AUC'
        str = [str, '�rea abaixo da curva ROC (ROC-AUC)'];
    case 'Fbeta'
        str = [str, 'Fbeta-score com beta = ',num2str(selBeta)];
    case 'MCC'
        str = [str, 'MCC (coeficiente de correla��o de Matthews)'];
    otherwise
        error(['Performance metric "', selMethod,'" not recognized'])
end

str = [str, '\n\nGrandezas utilizadas para an�lise: '];

for k = 1:length(vars)
    str = [str, vars{k}];
    if k ~= length(vars)
        str = [str, ', '];
    end
end

str = [str '\n\n'];

fprintf(fid,str);
clear str