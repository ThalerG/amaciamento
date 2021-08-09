function [res] = detect_Dom(proportion,time,ensaio,cluster)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

unEnsaios = unique(ensaio); % Ensaios contidos nos dados
res.Pass = false; res.TimeDetect = []; res.Obs = ''; % Formato da análise

for k1 = 1:length(unEnsaios) % Para cada ensaio
    % Seleciona os dados do ensaio
    [~,orderTemp] = max(proportion(ensaio == unEnsaios(k1),:),[],2);
    timeTemp = time(ensaio == unEnsaios(k1));
    
    if orderTemp(end)~=cluster % Se não está acima do threshold no final, não detectou
        res.TimeDetect(k1) = NaN;
    else
        k2 = 0;
        while (orderTemp(end-k2)==cluster)&&(k2<(length(orderTemp)-1)) % Busca de trás pra frente pelo instante que passou o threshold
            k2 = k2+1;
        end
        res.TimeDetect(k1) = timeTemp(end-k2);
    end
    
end

if nnz(isnan(res.TimeDetect)) > 0
    res.Obs = 'Amaciamento não detectado em todos os ensaios';
elseif max(res.TimeDetect)~=res.TimeDetect(1)
    res.Obs = 'Amaciamento maior em ensaios amaciados';
else
    res.Pass = true;
end