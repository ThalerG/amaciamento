function temperature = pres2temp(gas,pressure)
%PRES2TEMP Realiza a conversão entre pressão e temperatura na saturação 
% temperature = pres2temp(gas,pressure) A partir do gas selecionado(R134a, 
%                 R600a, R290, R600, R1234yf ou R404a), converte a pressão 
%                 em temperatura com base na linearização dos valores do
%                 Refprop.

x = log(pressure);

% Coeficientes da linearização das curvas do Refprop (ordem inversa)
switch gas
    case 'R134a'
        coef = [-26.36247488741,21.83585442057,2.271683879749,0.1918883398099,0.02793925270321,0.01100738839705,-0.002781778580458];
    case 'R600a'
        coef = [-11.99018583624,25.43522130718,2.784473139251,0.291215105668,0.04962742882715,0.004679357204325,-0.002446538513077];
    case 'R290'
        coef = [-42.3877740635,22.58350644045,2.497262717961,0.2670930834947,0.01203825437683,0.01225398949932,-0.002104830914877];
    case 'R600'
        coef = [-0.9041,60.464,15.209,3.7765,0.8395,0.0833,-0.0259];
    case 'R1234yf'
        coef = [-29.853208,52.406892,13.199271,2.722829,-0.287372,1.935296,-0.839062];
    case 'R404a'
        coef = [-45.74360510575,20.66520836738,2.230213295409,0.2302717401136,0.01125508738689,0.008354312231333,-0.001689638725145];
end

coef = flip(coef); % Corrige a ordem dos coeficientes

temperature = polyval(coef,x);

