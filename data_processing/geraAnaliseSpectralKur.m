%% Análises temporal dos Sinais
% Gera variaveis de matlab e figuras a partir de dados pré 
% processados em labview utilizando o VI "conv_Waveform-TXT.vi" e do
% arquivo "medicoesGerais.dat"

clear; close all; clc;

% Parâmetros

cSpKurload = 1;
vSpKurload = 1;
aSpKurload = 1;

fpathFinal = '\Amostra 5\N_2020-01-22';

fpathSource = 'C:\Users\G. Thaler\Documents\Projeto Amaciamento\Dados Preparados';
fpathVar = 'C:\Users\G. Thaler\Documents\Projeto Amaciamento\Dados Processados';
fpathFig = 'C:\Users\G. Thaler\Documents\Projeto Amaciamento\Imagens';

fpathSource = strcat(fpathSource,fpathFinal);
fpathVar = strcat(fpathVar,fpathFinal);
fpathFig = strcat(fpathFig,fpathFinal);

fcFolder = '\corrente';
fcT = '\corrTempo*.dat';

fvFolder = '\vibracao';
fvT = '\vibTempo*.dat';

faFolder = '\acusticas';
faT = '\acu_Tempo*.dat';

fGeral = '\medicoesGerais.dat';

Tc = 60; % Tempo entre medições da corrente
Tv = 60; % Tempo entre medições da vibração
Ta = 600; % Tempo entre medições de emissões acústicas

% Colunas da Medição Geral

colTempo = 1; colTSuc = 2; colTComp = 3; colTInt = 4; colTDes = 5; 
% colPSuc = 6; colPDes = 7; colPInt = 8; colPosSP = 9; colPos = 10; coluSuc = 12; colCompAtivo = 14; colVazao = 18;
colPSuc = 6; colPDes = 7; colPInt = 8; colPosSP = 9; colPos = 10; colCompAtivo = 12; colVazao = 16;


% -------------------------------------------------------------------------
%                         Adaptação de variáveis

fcFolder = strcat(fpathSource,fcFolder);
fcT = strcat(fcFolder,fcT);

fvFolder = strcat(fpathSource,fvFolder);
fvT = strcat(fvFolder,fvT);

faFolder = strcat(fpathSource,faFolder);
faT = strcat(faFolder,faT);

data = importaDados(strcat(fpathSource,fGeral));

t = data(:,colTempo)/3600; tSuc = data(:,colTSuc); tComp = data(:,colTComp);
tInt = data(:,colTInt); tAmb = data(:,colTDes); pSuc = data(:,colPSuc); 
pDes = data(:,colPDes); pInt = data(:,colPInt); posSP = data(:,colPosSP); pos = data(:,colPos);
compAtivo = data(:,colCompAtivo); vazao = data(:,colVazao);

clear data;

t0 = t(compAtivo>0); t0 = t0(1);
tempo = (t-t0);
t0 = t0*3600;
clear k;

%% -------------------------------------------------------------------------
%                         Carrega Tempo Corrente

if cSpKurload

    mf = dir(fcT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;
                
    teC = (((1:length(Files))-1)*Tc-t0)/3600;
    
    corSpKur = zeros(801,length(Files));
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fcFolder,'\',Files(k));

        data = importdata(filename);
        
        [corSpKur(:,k),fKurC] = pkurtosis(data,25.6e3);
    end

    clear data;

end

vZoomFigZ = surf(teC,fKurC,corSpKur);
ylim([fKurC(1) fKurC(end)]);
xlim([0 teC(end)]);
c = colorbar;
c.Label.String = 'Amplitude [dB]';
set(vZoomFigZ,'edgecolor','none')
xlabel('Tempo [h]');
ylabel('Frequência [Hz]');
title('Curtose Espectral da Corrente');
view(2);
colormap jet

cSpKur.t = teC;
cSpKur.f = fKurC;
cSpKur.data = corSpKur;

save(strcat(fpathVar,'\corrente_SpCur.mat'),'cSpKur');
savefig(strcat(fpathFig,'\corrente_SpCur.fig'));

%% -------------------------------------------------------------------------
%                         Carrega Tempo Vibracao

if vSpKurload
    mf = dir(fvT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;
                
    tV = (((1:length(Files))-1)*Tv-t0)/3600;
    
    vibSpKurInf = zeros(801,length(Files));
    vibSpKurSup = zeros(801,length(Files));
    vibSpKurBan = zeros(801,length(Files));
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fvFolder,'\',Files(k));

        data = importdata(filename);
       
        [vibSpKurInf(:,k),fKurV] = pkurtosis(data(:,1),25.6e3);
        [vibSpKurSup(:,k),fKurV] = pkurtosis(data(:,2),25.6e3);
        [vibSpKurBan(:,k),fKurV] = pkurtosis(data(:,3),25.6e3);
    end

    clear data;
end

vZoomFigZ = surf(tV,fKurV,vibSpKurInf);
ylim([fKurV(1) fKurV(end)]);
xlim([0 tV(end)]);
c = colorbar;
c.Label.String = 'Amplitude [dB]';
set(vZoomFigZ,'edgecolor','none')
xlabel('Tempo [h]');
ylabel('Frequência [Hz]');
title('Curtose Espectral da Vibração na Calota Inferior');
view(2);
colormap jet

vSpKurInf.t = tV;
vSpKurInf.f = fKurV;
vSpKurInf.data = vibSpKurInf;

save(strcat(fpathVar,'\vibracao_Inf_SpCur.mat'),'vSpKurInf');
savefig(strcat(fpathFig,'\vibracao_Inf_SpCur.fig'));

vZoomFigZ = surf(tV,fKurV,vibSpKurSup);
ylim([fKurV(1) fKurV(end)]);
xlim([0 tV(end)]);
c = colorbar;
c.Label.String = 'Amplitude [dB]';
set(vZoomFigZ,'edgecolor','none')
xlabel('Tempo [h]');
ylabel('Frequência [Hz]');
title('Curtose Espectral da Vibração na Calota Superior');
view(2);
colormap jet

vSpKurSup.t = tV;
vSpKurSup.f = fKurV;
vSpKurSup.data = vibSpKurSup;

save(strcat(fpathVar,'\vibracao_Sup_SpCur.mat'),'vSpKurSup');
savefig(strcat(fpathFig,'\vibracao_Sup_SpCur.fig'));

vZoomFigZ = surf(tV,fKurV,vibSpKurBan);
ylim([fKurV(1) fKurV(end)]);
xlim([0 tV(end)]);
c = colorbar;
c.Label.String = 'Amplitude [dB]';
set(vZoomFigZ,'edgecolor','none')
xlabel('Tempo [h]');
ylabel('Frequência [Hz]');
title('Curtose Espectral da Vibração na Bancada');
view(2);
colormap jet

vSpKurBan.t = tV;
vSpKurBan.f = fKurV;
vSpKurBan.data = vibSpKurBan;

save(strcat(fpathVar,'\vibracao_Ban_SpCur.mat'),'vSpKurBan');
savefig(strcat(fpathFig,'\vibracao_Ban_SpCur.fig'));


%% -------------------------------------------------------------------
%                         Carrega Tempo Emissões Acusticas

if aSpKurload
    mf = dir(faT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;
                
    teA = (((1:length(Files))-1)*Ta-t0)/3600;
    
    acuSpKur = zeros(801,length(Files));
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(faFolder,'\',Files(k));

        data = importdata(filename);
        
        [acuSpKur(:,k),fKurA] = pkurtosis(data,300e3);
    end

    clear data;
end

vZoomFigZ = surf(teA,fKurA,acuSpKur);
ylim([fKurV(1) fKurV(end)]);
xlim([0 teA(end)]);
c = colorbar;
c.Label.String = 'Amplitude [dB]';
set(vZoomFigZ,'edgecolor','none')
xlabel('Tempo [h]');
ylabel('Frequência [Hz]');
title('Curtose Espectral das Emissões Acústicas');
view(2);
colormap jet

aSpKur.t = teA;
aSpKur.f = fKurA;
aSpKur.data = acuSpKur;

save(strcat(fpathVar,'\acusticas_SpCur.mat'),'vSpKurBan');
savefig(strcat(fpathFig,'\acusticas_SpCur.fig'));

clear colCompAtivo colPDes colPos colPosSP colPSuc colTComp colTDes...
          colTempo colTInt colTSuc colVazao fcFolder fvFolder fcT fvT fGeral...
          filename Files ;

