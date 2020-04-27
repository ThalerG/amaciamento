function d = derMed(x,w)
% DERMED calcula ponto a ponto a diferença entre duas médias de amostras
%   d = derMed(x,w) calcula para cada elemento x(k) de um vetor x a  
%   diferença entre os valores médios dentro de uma janela de tamanho w,
%   tal que:
%     d(k) =  mean(x((k-w+1):k))- mean(x((k-2*w+1):(k-w))).
%   
%   Pode-se visualizar a operação considerando o vetor x:
%   x = x(1) x(2) ... x(k-2w) x(k-2w+1) ... x(k-w) x(k-w+1) ... x(k-1) x(k)
%                             |________M1________| |__________M2__________|                     
%                                           d = M2 - M1
%
%   Se k<2w, a janela w é reduzida para o máximo valor compatível
%   (w = floor(k/2)).


d = zeros(1,length(x));

for k = 1:length(x)
    if k<(2*w) % Diminui a janela nas primeiras amostras
        wt = floor(k/2);
        d(k) = mean(x((k-wt+1):k))-mean(x((k-2*wt+1):(k-wt)));
    else
        d(k) = mean(x((k-w+1):k))-mean(x((k-2*w+1):(k-w)));
    end
end