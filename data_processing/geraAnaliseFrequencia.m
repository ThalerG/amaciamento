%% An�lises de Magnitude dos Sinais
% Gera variaveis de matlab e figuras a partir de dados de frequencia pr� 
% processados em labview utilizando o VI "conv_Waveform-TXT.vi"

clear; close all; clc;

% Par�metros

cZload = 1; cOload = 1; cFFTload = 1;
vZload = 1; vOload = 1; vFFTload = 1;
aZload = 1; aOload = 1; aFFTload = 1;

fpathFinal = '\Amostra 5\N_2020-01-22';

fpathSource = 'C:\Users\G. Thaler\Documents\Projeto Amaciamento\Dados Preparados';
fpathVar = 'C:\Users\G. Thaler\Documents\Projeto Amaciamento\Dados Processados';
fpathFig = 'C:\Users\G. Thaler\Documents\Projeto Amaciamento\Imagens';

fpathSource = strcat(fpathSource,fpathFinal);
fpathVar = strcat(fpathVar,fpathFinal);
fpathFig = strcat(fpathFig,fpathFinal);

fGeral = '\medicoesGerais.dat';

fcFolder = '\corrente';
fcZ = '\corrZoom*.dat';
fcO = '\corrOct*.dat';
fcF = '\corrFFT*.dat';
fcRMS = '\corrRMS.dat';

fcinfoZ = '\corrFreqZoom.dat';
fcinfoO = '\corrFreqOct.dat';
fcinfoF = '\corrFreqFFT.dat';

fvFolder = '\vibracao';
fvZ = '\vibZoom*.dat';
fvO = '\vibOct*.dat';
fvF = '\vibFFT*.dat';
fvRMS = '\vibRMS.dat';

fvinfoZ = '\vibFreqZoom.dat';
fvinfoO = '\vibFreqOct.dat';
fvinfoF = '\vibFreqFFT.dat';

facuFolder = '\acusticas';
facuZ = '\acu_Zoom*.dat';
facuO = '\acu_Oct*.dat';
facuF = '\acu_FFT*.dat';
facuRMS = '\acu_RMS.dat';

facuinfoZ = '\acu_FreqZoom.dat';
facuinfoO = '\acu_FreqOct.dat';
facuinfoF = '\acu_FreqFFT.dat';

Tc = 60; % Tempo entre medi��es da corrente
Tv = 60; % Tempo entre medi��es da vibra��o
Ta = 600; % Tempo entre medi��es de emiss�es ac�sticas

% -------------------------------------------------------------------------
%                         Adapta��o de vari�veis

fcFolder = strcat(fpathSource,fcFolder);
fcZ = strcat(fcFolder,fcZ); fcO = strcat(fcFolder,fcO); fcF = strcat(fcFolder,fcF);
fcinfoZ = strcat(fcFolder,fcinfoZ); fcinfoO = strcat(fcFolder,fcinfoO); fcinfoF = strcat(fcFolder,fcinfoF);
fcRMS = strcat(fcFolder,fcRMS);

fvFolder = strcat(fpathSource,fvFolder);
fvZ = strcat(fvFolder,fvZ); fvO = strcat(fvFolder,fvO); fvF = strcat(fvFolder,fvF);
fvinfoZ = strcat(fvFolder,fvinfoZ); fvinfoO = strcat(fvFolder,fvinfoO); fvinfoF = strcat(fvFolder,fvinfoF);
fvRMS = strcat(fvFolder,fvRMS);

facuFolder = strcat(fpathSource,facuFolder);
facuZ = strcat(facuFolder,facuZ); facuO = strcat(facuFolder,facuO); facuF = strcat(facuFolder,facuF);
facuinfoZ = strcat(facuFolder,facuinfoZ); facuinfoO = strcat(facuFolder,facuinfoO); facuinfoF = strcat(facuFolder,facuinfoF);
facuRMS = strcat(facuFolder,facuRMS);

data = importaDados(strcat(fpathSource,fGeral),'\t');

t = data(:,1);
comp = data(:,12);
t0 = t(comp>0); t0 = t0(1);

clear comp;
%% -------------------------------------------------------------------------
%                         Carrega Zoom Corrente

if cZload
    mf = dir(fcZ); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));

    f = importdata(fcinfoZ);

    z = zeros(length(f),length(Files));

    t = (((1:length(Files))-1)*Tc-t0)/3600;
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fcFolder,'\',Files(k));

        freq = importdata(filename);

        z(:,k) = freq;
    end

    figure;
    cZoomFig = surf(t,f,z);
    ylim([f(1) f(end)]);
    xlim([0 t(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    set(cZoomFig,'edgecolor','none')
    xlabel('Tempo [h]');
    ylabel('Frequ�ncia [Hz]');
    title('Zoom Corrente');
    view(2);
    colormap jet
    
    cZ.t = t;
    cZ.f = f;
    cZ.data = z;
    
    save(strcat(fpathVar,'\corrente_Zoom.mat'),'cZ');
    savefig(strcat(fpathFig,'\corrente_Zoom.fig'));
    
    close all;
    clear cZ;
end

%% -------------------------------------------------------------------------
%                         Carrega FFT Corrente


if cFFTload
    mf = dir(fcF); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));

    f = importdata(fcinfoF);

    z = zeros(length(f),length(Files));

    t = (((1:length(Files))-1)*Tc-t0)/3600;
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fcFolder,'\',Files(k));

        freq = importdata(filename);

        z(:,k) = freq;
    end
    
%     figure;
%     cFFTFig = surf(t,f,z);
%     ylim([f(1) f(end)]);
%     xlim([0 t(end)]);
%     c = colorbar;
%     c.Label.String = 'Amplitude [dB]';
%     set(cFFTFig,'edgecolor','none')
%     xlabel('Tempo [h]');
%     ylabel('Frequ�ncia [Hz]');
%     title('FFT Corrente');
%     view(2);
%     colormap jet
    
    cFFT.t = t;
    cFFT.f = f;
    cFFT.data = z;
    
    save(strcat(fpathVar,'\corrente_FFT.mat'),'cFFT');
%     savefig(strcat(fpathFig,'\corrente_FFT.fig'));
    
    close all;
    clear cFFT;
end

%% -------------------------------------------------------------------------
%                         Carrega Oitava Corrente


if cOload
    mf = dir(fcO); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));

    f = importdata(fcinfoO);

    z = zeros(length(f),length(Files));

    t = (((1:length(Files))-1)*Tc-t0)/3600;
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fcFolder,'\',Files(k));

        freq = importdata(filename);

        z(:,k) = freq;
    end

    figure;
    cOctFig = surf(t,f,z);
    ylim([f(1) f(end)]);
    xlim([0 t(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    set(cOctFig,'edgecolor','none')
    xlabel('Tempo [h]');
    set(gca, 'YScale', 'log')
    ylabel('Frequ�ncia [Hz]');
    title('Oitava Corrente');
    view(2);
    colormap jet
    
    cO.t = t;
    cO.f = f;
    cO.data = z;
    
    save(strcat(fpathVar,'\corrente_Oitava.mat'),'cO');
    savefig(strcat(fpathFig,'\corrente_Oitava.fig'));
    
    close all;
    clear cO;
end

%% -------------------------------------------------------------------------
%                         Carrega Zoom Vibra��o

if vZload
    mf = dir(fvZ); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));

    f = importdata(fvinfoZ);

    zx = zeros(length(f),length(Files));
    zy = zeros(length(f),length(Files));
    zz = zeros(length(f),length(Files));
    
    t = (((1:length(Files))-1)*Tv-t0)/3600;
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fvFolder,'\',Files(k));

        freq = importdata(filename);

        zx(:,k) = freq(:,1);
        zy(:,k) = freq(:,2);
        zz(:,k) = freq(:,3);
    end

    vZoomFigX = surf(t,f,zx);
    ylim([f(1) f(end)]);
    xlim([0 t(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    set(vZoomFigX,'edgecolor','none')
    xlabel('Tempo [h]');
    ylabel('Frequ�ncia [Hz]');
    title('Zoom Vibra��o Calota Inferior');
    view(2);
    colormap jet
    
    vInfZ.t = t;
    vInfZ.f = f;
    vInfZ.data = zx;
    
    save(strcat(fpathVar,'\vibracao_CalotaInf_Zoom.mat'),'vInfZ');
    savefig(strcat(fpathFig,'\vibracao_CalotaInf_Zoom.fig'));
    
    close all;
    clear vInfZ;
    
    
    vZoomFigY = surf(t,f,zy);
    ylim([f(1) f(end)]);
    xlim([0 t(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    set(vZoomFigY,'edgecolor','none')
    xlabel('Tempo [h]');
    ylabel('Frequ�ncia [Hz]');
    title('Zoom Vibra��o Bancada');
    view(2);
    colormap jet
    
    vBanZ.t = t;
    vBanZ.f = f;
    vBanZ.data = zy;
    
    save(strcat(fpathVar,'\vibracao_Bancada_Zoom.mat'),'vBanZ');
    savefig(strcat(fpathFig,'\vibracao_Bancada_Zoom.fig'));
    
    close all;
    clear vBanZ;
    
    vZoomFigZ = surf(t,f,zz);
    ylim([f(1) f(end)]);
    xlim([0 t(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    set(vZoomFigZ,'edgecolor','none')
    xlabel('Tempo [h]');
    ylabel('Frequ�ncia [Hz]');
    title('Zoom Vibra��o Calota Superior');
    view(2);
    colormap jet
    
    vSupZ.t = t;
    vSupZ.f = f;
    vSupZ.data = zz;
    
    save(strcat(fpathVar,'\vibracao_CalotaSup_Zoom.mat'),'vSupZ');
    savefig(strcat(fpathFig,'\vibracao_CalotaSup_Zoom.fig'));
    
    close all;
    clear vSupZ;
end

%% -------------------------------------------------------------------------
%                         Carrega FFT Vibra��o

if vFFTload
    mf = dir(fvF); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));

    f = importdata(fvinfoF);

    zx = zeros(length(f),length(Files));
    zy = zeros(length(f),length(Files));
    zz = zeros(length(f),length(Files));
        
    t = (((1:length(Files))-1)*Tv-t0)/3600;
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fvFolder,'\',Files(k));

        freq = importdata(filename);

        zx(:,k) = freq(:,1);
        zy(:,k) = freq(:,2);
        zz(:,k) = freq(:,3);
    end

%     vZoomFigX = surf(t,f,zx);
%     ylim([f(1) f(end)]);
%     xlim([0 t(end)]);
%     c = colorbar;
%     c.Label.String = 'Amplitude [dB]';
%     set(vZoomFigX,'edgecolor','none')
%     xlabel('Tempo [h]');
%     ylabel('Frequ�ncia [Hz]');
%     title('FFT Vibra��o Calota Inferior');
%     view(2);
%     colormap jet
    
    vInfFFT.t = t;
    vInfFFT.f = f;
    vInfFFT.data = zx;
    
    save(strcat(fpathVar,'\vibracao_CalotaInf_FFT.mat'),'vInfFFT');
%     savefig(strcat(fpathFig,'\vibracao_CalotaInf_FFT.fig'));
    
    close all;
    clear vInfFFT;
    
%     vZoomFigY = surf(t,f,zy);
%     ylim([f(1) f(end)]);
%     xlim([0 t(end)]);
%     c = colorbar;
%     c.Label.String = 'Amplitude [dB]';
%     set(vZoomFigY,'edgecolor','none')
%     xlabel('Tempo [h]');
%     ylabel('Frequ�ncia [Hz]');
%     title('FFT Vibra��o Bancada');
%     view(2);
%     colormap jet
    
    vBanFFT.t = t;
    vBanFFT.f = f;
    vBanFFT.data = zy;
    
    save(strcat(fpathVar,'\vibracao_Bancada_FFT.mat'),'vBanFFT');
%     savefig(strcat(fpathFig,'\vibracao_Bancada_FFT.fig'));
    
    close all;
    clear vBanFFT;
    
%     vZoomFigZ = surf(t,f,zz);
%     ylim([f(1) f(end)]);
%     xlim([0 t(end)]);
%     c = colorbar;
%     c.Label.String = 'Amplitude [dB]';
%     set(vZoomFigZ,'edgecolor','none')
%     xlabel('Tempo [h]');
%     ylabel('Frequ�ncia [Hz]');
%     title('FFT Vibra��o Calota Superior');
%     view(2);
%     colormap jet
    
    vSupFFT.t = t;
    vSupFFT.f = f;
    vSupFFT.data = zz;
    
    save(strcat(fpathVar,'\vibracao_CalotaSup_FFT.mat'),'vSupFFT');
%     savefig(strcat(fpathFig,'\vibracao_CalotaSup_FFT.fig'));
    
    close all;
    clear vSupFFT;
end

%% -------------------------------------------------------------------------
%                         Carrega Oitava Vibra��o

if vOload
    mf = dir(fvO); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));

    f = importdata(fvinfoO);

    zx = zeros(length(f),length(Files));
    zy = zeros(length(f),length(Files));
    zz = zeros(length(f),length(Files));
        
    t = (((1:length(Files))-1)*Tv-t0)/3600;
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fvFolder,'\',Files(k));

        freq = importdata(filename);

        zx(:,k) = freq(:,1);
        zy(:,k) = freq(:,2);
        zz(:,k) = freq(:,3);
    end

    vZoomFigX = surf(t,f,zx);
    ylim([f(1) f(end)]);
    xlim([0 t(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    set(vZoomFigX,'edgecolor','none')
    set(gca, 'YScale', 'log')
    xlabel('Tempo [h]');
    ylabel('Frequ�ncia [Hz]');
    title('Oitava Vibra��o Calota Inferior');
    view(2);
    colormap jet
    
    vInfO.t = t;
    vInfO.f = f;
    vInfO.data = zx;
    
    save(strcat(fpathVar,'\vibracao_CalotaInf_O.mat'),'vInfO');
    savefig(strcat(fpathFig,'\vibracao_CalotaInf_O.fig'));
    
    close all;
    clear vInfO;
    
    vZoomFigY = surf(t,f,zy);
    ylim([f(1) f(end)]);
    xlim([0 t(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    set(vZoomFigY,'edgecolor','none')
    set(gca, 'YScale', 'log')
    xlabel('Tempo [h]');
    ylabel('Frequ�ncia [Hz]');
    title('Oitava Vibra��o Bancada');
    view(2);
    colormap jet
    
    vBanO.t = t;
    vBanO.f = f;
    vBanO.data = zy;
    
    save(strcat(fpathVar,'\vibracao_Bancada_O.mat'),'vBanO');
    savefig(strcat(fpathFig,'\vibracao_Bancada_O.fig'));
    
    close all;
    clear vBanO;
    
    vZoomFigZ = surf(t,f,zz);
    ylim([f(1) f(end)]);
    xlim([0 t(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    set(gca, 'YScale', 'log')
    set(vZoomFigZ,'edgecolor','none')
    xlabel('Tempo [h]');
    ylabel('Frequ�ncia [Hz]');
    title('Oitava Vibra��o Calota Superior');
    view(2);
    colormap jet
    
    vSupO.t = t;
    vSupO.f = f;
    vSupO.data = zy;
    
    save(strcat(fpathVar,'\vibracao_CalotaSup_O.mat'),'vSupO');
    savefig(strcat(fpathFig,'\vibracao_CalotaSup_O.fig'));
    
    close all;
    clear vSupO;
end

%% -------------------------------------------------------------------------
%                         Carrega Zoom Emiss�es Ac�sticas
t = t(1:(Ta/Tv):end);


if aZload
    mf = dir(facuZ); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));

    f = importdata(facuinfoZ);

    z = zeros(length(f),length(Files));
        
    t = (((1:length(Files))-1)*Ta-t0)/3600;
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(facuFolder,'\',Files(k));

        freq = importdata(filename);

        z(:,k) = freq;
    end

    vZoomFigX = surf(t,f,z);
    ylim([f(1) f(end)]);
    xlim([0 t(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    set(vZoomFigX,'edgecolor','none')
    xlabel('Tempo [h]');
    ylabel('Frequ�ncia [Hz]');
    title('Zoom Emiss�es Ac�sticas');
    view(2);
    colormap jet
        
    aZ.t = t;
    aZ.f = f;
    aZ.data = z;
    
    save(strcat(fpathVar,'\acusticas_Zoom.mat'),'aZ');
    savefig(strcat(fpathFig,'\acusticas_Zoom.fig'));
    
    close all;
    clear aZ;
end

%% -------------------------------------------------------------------------
%                         Carrega FFT Emiss�es Ac�sticas

if aFFTload
    mf = dir(facuF); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));

    f = importdata(facuinfoF);

    z = zeros(length(f),length(Files));
            
    t = (((1:length(Files))-1)*Ta-t0)/3600;
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(facuFolder,'\',Files(k));

        freq = importdata(filename);

        z(:,k) = freq;
    end

%     vZoomFigX = surf(t,f,z);
%     ylim([f(1) f(end)]);
%     xlim([0 t(end)]);
%     c = colorbar;
%     c.Label.String = 'Amplitude [dB]';
%     set(vZoomFigX,'edgecolor','none')
%     xlabel('Tempo [h]');
%     ylabel('Frequ�ncia [Hz]');
%     title('FFT Emiss�es Ac�sticas');
%     view(2);
%     colormap jet
    
    aFFT.t = t;
    aFFT.f = f;
    aFFT.data = z;
    
    save(strcat(fpathVar,'\acusticas_FFT.mat'),'aFFT');
%     savefig(strcat(fpathFig,'\acusticas_FFT.fig'));
    
    close all;
    clear aFFT;
end

%% -------------------------------------------------------------------------
%                         Carrega Oitava Emissoes Acusticas

if aOload
    mf = dir(facuO); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));

    f = importdata(facuinfoO);

    z = zeros(length(f),length(Files));
            
    t = (((1:length(Files))-1)*Ta-t0)/3600;
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(facuFolder,'\',Files(k));

        freq = importdata(filename);

        z(:,k) = freq;
    end

    vZoomFigX = surf(t,f,z);
    ylim([f(1) f(end)]);
    xlim([0 t(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    set(vZoomFigX,'edgecolor','none')
    set(gca, 'YScale', 'log')
    xlabel('Tempo [h]');
    ylabel('Frequ�ncia [Hz]');
    title('Oitava Emiss�es Ac�sticas');
    view(2);
    colormap jet
    
    aO.t = t;
    aO.f = f;
    aO.data = z;
    
    save(strcat(fpathVar,'\acusticas_O.mat'),'aO');
    savefig(strcat(fpathFig,'\acusticas_O.fig'));
    
    close all;
    clear aO;
end

clear;