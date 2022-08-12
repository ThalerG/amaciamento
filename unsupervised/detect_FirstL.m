function [res] = detect_FirstL(proportion,time,ensaio,cluster,thr)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


unEnsaios = unique(ensaio); % Ensaios contidos nos dados
res.Pass = false; res.TimeDetect = []; res.Obs = ''; % Formato da análise

if cluster>size(proportion,2)
    res.Obs = "Cluster inexistente";
    res.TimeDetect = NaN;
    return
end

for k1 = 1:length(unEnsaios) % Para cada ensaio
    % Seleciona os dados do ensaio
    propTemp = proportion(ensaio == unEnsaios(k1),cluster);
    timeTemp = time(ensaio == unEnsaios(k1));
    
    low = propTemp<thr;
    
    if any(low) % O cluster desce do limiar no ensaio
        tempoProp = timeTemp(low);
        res.TimeDetect(k1) = tempoProp(1);
    else % Cluster não aparece no ensaio
        res.TimeDetect(k1) = NaN;
    end
    
end

if nnz(isnan(res.TimeDetect)) > 0
    res.Obs = 'Amaciamento não detectado em todos os ensaios';
elseif max(res.TimeDetect)~=res.TimeDetect(1)
    res.Obs = 'Amaciamento maior em ensaios amaciados';
else
    res.Pass = true;
end