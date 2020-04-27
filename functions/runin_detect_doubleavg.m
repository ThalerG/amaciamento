function [n,ta] = runin_detect_doubleavg(x,t,w1,w2,r,s,f)
%  detectaAmac utiliza o método da derivada das médias para detectar o 
% instante de amaciamento.
%   
%   [n,ta] = detectaAmac(x,t,r,w,s) busca, dentro das derivadas médias do 
%   vetor x com janela w, o primeiro conjunto de r pontos consecutivos (com
%   tolerancia de f pontos) dentro da faixa limite de variação s. A saída
%   n é o número da primeira amostra considerada amaciada, e ta é o
%   instante de amaciamento, na mesma unidade de tempo do vetor t 
%   fornecido, que deve corresponder ao instante de cada amostra x.
%
%   São recomendados valores:
%       w1 = 30
%       w2 = 1
%       r = 33
%       s = 7e-4
%       f = 0
%
%   See also derMed

L = length(t);

der = derMedDupla(x(t>0),w1,w2);
t = t(t>0);
L = L-length(t); % Número de elementos descartados 

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
    
    