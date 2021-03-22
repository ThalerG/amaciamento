str = '%%%%%%%% An�lise de classificadores %%%%%%%%%%%%%%%% \n\nM�todo de classifica��o utilizado:\n';

switch methodML
    case 'tree'
        str = [str, '�rvore, com n�mero m�ximo de splits = ',num2str(maxSplits)];
    case 'SVM'
        str = [str, 'SVM, com fun��o de kernel "',kernelFunction,'" e scale "',kernelScale,'"'];
    case 'KNN'
        str = [str, 'K Nearest Neighbors, com ',num2str(numNeighbors),' neighbors, dist�ncia "',distance,'" e peso "', weight,'"'];
    case 'logReg'
        str = [str, 'Regress�o log�stica'];
    otherwise
        error(['Model "',methodML,'" not recognized'])
end

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

str = [str '\n\nM�todo para feature selection:\n'];

if isequal(FSmethod(1:4),'hex_')
    str = [str 'Poda extensiva de grandezas'];
    switch FSmethod(5:end)
        case 'mRMR'
            str = [str, ' com classifica��o por mRMR e n�mero m�ximo de features = ',num2str(maxFeatures)];
        case 'none'
            str = str;
        otherwise
            error(['Feature selection "', FSmethod,'" not recognized'])
    end
elseif isequal(FSmethod(1:4),'hgr_')
    str = [str 'Poda greedy de grandezas'];
    switch FSmethod(5:end)
        case 'mRMR'
            str = [str, ' com classifica��o por mRMR e n�mero m�ximo de features = ',num2str(maxFeatures)];
        case 'none'
            str = str;
        otherwise
            error(['Feature selection "', FSmethod,'" not recognized'])
    end
else
    switch FSmethod
        case 'none'
            str = [str, 'Nenhum'];
        case 'mRMR'
            str = [str, 'Classifica��o por mRMR e n�mero m�ximo de features = ',num2str(maxFeatures)];
        otherwise
            error(['Feature selection "', FSmethod,'" not recognized'])
    end
end

str = [str, '\n\nGrandezas utilizadas para an�lise: '];

for k = 1:length(vars)
    str = [str, vars{k}];
    if k ~= length(vars)
        str = [str, ', '];
    end
end

str = [str '\n\n\n'];

fprintf(fid,str);
clear str