function pressure = temp2pres(gas,temperature)
%PRES2TEMP Realiza a conversão entre pressão e temperatura na saturação 
% pressure = temp2pres(gas,temperature) A partir do gas selecionado(R134a, 
%                 R600a, R290, R600, R1234yf ou R404a), converte a temperatura 
%                 em pressão com base na linearização dos valores do
%                 Refprop.


% Coeficientes da linearização das curvas do Refprop (ordem inversa)
switch gas
    case 'R134a'
        coef = [1.074288089836,0.03622951419553,-0.0001512337116417,6.852633297566E-7,-2.869823366278E-9,1.090911970012E-11,-1.132765633404E-14];
    case 'R600a'
        coef = [0.4487415858516,0.03552367283198,-0.0001470053590086,6.365161845777E-7,-2.530204800857E-9,8.902320581314E-12,-1.502579168936E-14];
    case 'R290'
        coef = [1.557205076411,0.03054603090965,-0.0001192821337922,5.26835932993E-7,-2.172434526016E-9,7.902354506059E-12,-3.891484073262E-16];
    case 'R600'
        coef = [0.0149,0.0164,-7E-5,3E-7,-1E-9,4E-12,-1E-14];
    case 'R1234yf'
        coef = [0,0,0,0,0,0,0];
    case 'R404a'
        coef = [1.792311990799,0.03186855702885,-0.0001262196158052,5.975577760152E-7,-2.385876017707E-9,1.290451082322E-11,-2.334832514649E-14];
end

coef = flip(coef); % Corrige a ordem dos coeficientes

x = polyval(coef,temperature);

pressure = exp(x);

