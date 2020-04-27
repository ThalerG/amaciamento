%% Análises temporal dos Sinais
% Gera variaveis de matlab e figuras a partir de dados pré 
% processados em labview utilizando o VI "conv_Waveform-TXT.vi" e do
% arquivo "medicoesGerais.dat"

clear; close all; clc;

% Parâmetros

cChirpload = 1;
vChirpload = 1;
aChirpload = 0;

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

FsC = 25.6e+3;
FsV = 25.6e+3;
FsA = 300e+3;

m = 100;

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

if cChirpload
    f1 = 50; f2 = 70;
    mf = dir(fcT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;
                
    teC = (((1:length(Files))-1)*Tc-t0)/3600;
    
    w = exp(-1j*2*pi*(f2-f1)/(m*FsC));
    a = exp(1j*2*pi*f1/FsC);
        
    corChirp = zeros(m,length(Files));
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fcFolder,'\',Files(k));

        data = importdata(filename);
        
        corChirp(:,k) = czt(data,m,w,a);
        
    end

    
    fn = (0:m-1)'/m;
    fChirpC = (f2-f1)*fn + f1;
    
    clear data;

end
figure;

vZoomFigZ = surf(teC,fChirpC,abs(corChirp));
ylim([fChirpC(1) fChirpC(end)]);
xlim([0 teC(end)]);
c = colorbar;
c.Label.String = 'Amplitude [dB]';
set(vZoomFigZ,'edgecolor','none')
xlabel('Tempo [h]');
ylabel('Frequência [Hz]');
title('Chirp-Z da Corrente');
view(2);
colormap jet

cChirp.t = teC;
cChirp.f = fChirpC;
cChirp.data = corChirp;

save(strcat(fpathVar,'\corrente_SpCur.mat'),'cChirp');
savefig(strcat(fpathFig,'\corrente_SpCur.fig'));

%% -------------------------------------------------------------------------
%                         Carrega Tempo Vibracao

if vChirpload
    f1 = 50; f2 = 70;
    mf = dir(fvT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;
                
    tV = (((1:length(Files))-1)*Tv-t0)/3600;
    
    vibChirpInf = zeros(m,length(Files));
    vibChirpSup = zeros(m,length(Files));
    vibChirpBan = zeros(m,length(Files));

    w = exp(-1j*2*pi*(f2-f1)/(m*FsV));
    a = exp(1j*2*pi*f1/FsV);
        
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fvFolder,'\',Files(k));

        data = importdata(filename);
       
        vibChirpInf(:,k) = czt(data(:,1),m,w,a);
        vibChirpSup(:,k) = czt(data(:,2),m,w,a);
        vibChirpBan(:,k) = czt(data(:,3),m,w,a);
        
    end

    fn = (0:m-1)'/m;
    fChirpV = (f2-f1)*fn + f1;
    
    clear data;
end

figure;

vZoomFigZ = surf(tV,fChirpV,abs(vibChirpInf));
ylim([fChirpV(1) fChirpV(end)]);
xlim([0 tV(end)]);
c = colorbar;
c.Label.String = 'Amplitude [dB]';
set(vZoomFigZ,'edgecolor','none')
xlabel('Tempo [h]');
ylabel('Frequência [Hz]');
title('Chirp-Z da Vibração na Calota Inferior');
view(2);
colormap jet

vChirpInf.t = tV;
vChirpInf.f = fChirpV;
vChirpInf.data = vibChirpInf;

save(strcat(fpathVar,'\vibracao_Inf_SpCur.mat'),'vChirpInf');
savefig(strcat(fpathFig,'\vibracao_Inf_SpCur.fig'));


figure;

vZoomFigZ = surf(tV,fChirpV,abs(vibChirpSup));
ylim([fChirpV(1) fChirpV(end)]);
xlim([0 tV(end)]);
c = colorbar;
c.Label.String = 'Amplitude [dB]';
set(vZoomFigZ,'edgecolor','none')
xlabel('Tempo [h]');
ylabel('Frequência [Hz]');
title('Chirp-Z da Vibração na Calota Superior');
view(2);
colormap jet

vChirpSup.t = tV;
vChirpSup.f = fChirpV;
vChirpSup.data = vibChirpSup;

save(strcat(fpathVar,'\vibracao_Sup_SpCur.mat'),'vChirpSup');
savefig(strcat(fpathFig,'\vibracao_Sup_SpCur.fig'));


figure;

vZoomFigZ = surf(tV,fChirpV,abs(vibChirpBan));
ylim([fChirpV(1) fChirpV(end)]);
xlim([0 tV(end)]);
c = colorbar;
c.Label.String = 'Amplitude [dB]';
set(vZoomFigZ,'edgecolor','none')
xlabel('Tempo [h]');
ylabel('Frequência [Hz]');
title('Chirp-Z da Vibração na Bancada');
view(2);
colormap jet

vChirpBan.t = tV;
vChirpBan.f = fChirpV;
vChirpBan.data = vibChirpBan;

save(strcat(fpathVar,'\vibracao_Ban_SpCur.mat'),'vChirpBan');
savefig(strcat(fpathFig,'\vibracao_Ban_SpCur.fig'));


%% -------------------------------------------------------------------
%                         Carrega Tempo Emissões Acusticas

if aChirpload
    f1 = 1000; f2 = 1020;
    mf = dir(faT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;
                
    teA = (((1:length(Files))-1)*Ta-t0)/3600;
    
    acuChirp = zeros(m,length(Files));

    w = exp(-1j*2*pi*(f2-f1)/(m*FsA));
    a = exp(1j*2*pi*f1/FsA);
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(faFolder,'\',Files(k));

        data = importdata(filename);
        
        acuChirp(:,k) = czt(data,m,w,a);
    end

    fn = (0:m-1)'/m;
    fChirpA = (f2-f1)*fn + f1;
    
    clear data;
end

vZoomFigZ = surf(teA,fChirpA,abs(acuChirp));
ylim([fChirpV(1) fChirpV(end)]);
xlim([0 teA(end)]);
c = colorbar;
c.Label.String = 'Amplitude [dB]';
set(vZoomFigZ,'edgecolor','none')
xlabel('Tempo [h]');
ylabel('Frequência [Hz]');
title('Chirp-Z das Emissões Acústicas');
view(2);
colormap jet

aChirp.t = teA;
aChirp.f = fChirpA;
aChirp.data = acuChirp;

save(strcat(fpathVar,'\acusticas_SpCur.mat'),'vSpKurBan');
savefig(strcat(fpathFig,'\acusticas_SpCur.fig'));

clear colCompAtivo colPDes colPos colPosSP colPSuc colTComp colTDes...
          colTempo colTInt colTSuc colVazao fcFolder fvFolder fcT fvT fGeral...
          filename Files ;

