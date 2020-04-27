function [n,ta] = runin_detect_singleavg(x,t,w,r,s,f)
%  detectaAmac utiliza o m�todo da derivada das m�dias para detectar o 
% instante de amaciamento.
%   
%   [n,ta] = detectaAmac(x,t,r,w,s) busca, dentro das derivadas m�dias do 
%   vetor x com janela w, o primeiro conjunto de r pontos consecutivos (com
%   tolerancia de f pontos) dentro da faixa limite de varia��o s. A sa�da
%   n � o n�mero da primeira amostra considerada amaciada, e ta � o
%   instante de amaciamento, na mesma unidade de tempo do vetor t 
%   fornecido, que deve corresponder ao instante de cada amostra x.
%
%   S�o recomendados valores:
%       w = 35 
%       r = 30
%       s = 6e-4
%       f = 0
%
%   See also derMed

L = length(t);

der = derMed(x(t>0),w);
t = t(t>0);
L = L-length(t); % N�mero de elementos descartados 

count = 0;
flag = 0;

for k = 1:length(der)
    if abs(der(k))<s
        count = count+1;
    else
        if flag<f
            flag = flag+1;
        else
            flag = 0;
            count = 0;
        end
    end
    
    if count>=r
        n = k+L;
        ta = t(k);
        return
    end
end

if count<r
    n = NaN;
    ta = NaN;
end
    
    