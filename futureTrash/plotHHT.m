load('D:\Documentos\Amaciamento\Ensaios\Dados Processados\Amostra B3\N_2020_09_11\vibHilbert10.mat');

clear Inse2 Inse3 Inse4 Insf2 Insf3 Insf4;
T = T/60;
Insf1 = Insf1(T<24); Inse1 = Inse1(T<24); T = T(T<24);
fig = figure;
signalwavelet.internal.guis.plot.hhtPlot(Insf1, Inse1, T', [0;25.6e3/2], -Inf, 'yaxis', 0);
export_fig('D:\햞ea de Trabalho\vib1','-m5','-png','-transparent');
close;

clear all;

load('D:\Documentos\Amaciamento\Ensaios\Dados Processados\Amostra B3\N_2020_09_11\vibHilbert10.mat');

clear Inse1 Inse3 Inse4 Insf1 Insf3 Insf4;
T = T/60;
Insf2 = Insf2(T<24); Inse2 = Inse2(T<24); T = T(T<24);
fig = figure;
signalwavelet.internal.guis.plot.hhtPlot(Insf2(T<24), Inse2(T<24), T', [0;25.6e3/2], -Inf, 'yaxis', 0);
export_fig('D:\햞ea de Trabalho\vib2','-m5','-png','-transparent');
close;

clear all;

load('D:\Documentos\Amaciamento\Ensaios\Dados Processados\Amostra B3\N_2020_09_11\vibHilbert10.mat');

clear Inse1 Inse2 Inse4 Insf1 Insf2 Insf4;
T = T/60;
Insf3 = Insf3(T<24); Inse3 = Inse3(T<24); T = T(T<24);
fig = figure;
signalwavelet.internal.guis.plot.hhtPlot(Insf3(T<24), Inse3(T<24), T', [0;25.6e3/2], -Inf, 'yaxis', 0);
export_fig('D:\햞ea de Trabalho\vib3','-m5','-png','-transparent');
close;

clear all;

load('D:\Documentos\Amaciamento\Ensaios\Dados Processados\Amostra B3\N_2020_09_11\vibHilbert10.mat');

clear Inse1 Inse2 Inse3 Insf1 Insf2 Insf3;
T = T/60;
Insf4 = Insf4(T<24); Inse4 = Inse4(T<24); T = T(T<24);
fig = figure;
signalwavelet.internal.guis.plot.hhtPlot(Insf4(T<24), Inse4(T<24), T', [0;25.6e3/2], -Inf, 'yaxis', 0);
export_fig('D:\햞ea de Trabalho\vib4','-m5','-png','-transparent');
close;