%% Análises temporal dos Sinais
% Gera variaveis de matlab e figuras a partir de dados pré 
% processados em labview utilizando o VI "conv_Waveform-TXT.vi" e do
% arquivo "medicoesGerais.dat"

clear; close all; clc;

% Parâmetros

cRload = 1; cKload = 1;
vRload = 1; vKload = 1;
aRload = 1; aKload = 1;
pressload = 1; tempload = 1; posload = 1; vazload = 1;

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

data = importTestData(strcat(fpathSource,fGeral));

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

if cRload||cKload

    mf = dir(fcT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;
                
    teC = (((1:length(Files))-1)*Tc-t0)/3600;
    
    cRMS = zeros(length(Files),1);
    cKur = zeros(length(Files),1);

    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fcFolder,'\',Files(k));

        data = importdata(filename);

        cRMS(k) = rms(data);
        cKur(k) = kurtosis(data);
    end

    clear data;

end

%% -------------------------------------------------------------------------
%                         Carrega Tempo Vibracao

if vRload||vKload
    mf = dir(fvT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;
                
    tV = (((1:length(Files))-1)*Tv-t0)/3600;
    
    vxRMS = zeros(length(Files),1);
    vxKur = zeros(length(Files),1);

    vyRMS = zeros(length(Files),1);
    vyKur = zeros(length(Files),1);

    vzRMS = zeros(length(Files),1);
    vzKur = zeros(length(Files),1);
    
    vxT = zeros(length(Files),25.6e+3);
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fvFolder,'\',Files(k));

        data = importdata(filename);

        vxRMS(k) = rms(data(:,1));
        vxKur(k) = kurtosis(data(:,1));

        vyRMS(k) = rms(data(:,2));
        vyKur(k) = kurtosis(data(:,2));

        vzRMS(k) = rms(data(:,3));
        vzKur(k) = kurtosis(data(:,3));
        
        vxT(k,:) = data(:,1);
    end

    clear data;
end

%% -------------------------------------------------------------------
%                         Carrega Tempo Emissões Acusticas

if aRload||aKload
    mf = dir(faT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;
                
    teA = (((1:length(Files))-1)*Ta-t0)/3600;
    
    aRMS = zeros(length(Files),1);
    aKur = zeros(length(Files),1);

    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(faFolder,'\',Files(k));

        data = importdata(filename);

        aRMS(k) = rms(data);
        aKur(k) = kurtosis(data);
    end

    clear data;
end

clear colCompAtivo colPDes colPos colPosSP colPSuc colTComp colTDes...
          colTempo colTInt colTSuc colVazao fcFolder fvFolder fcT fvT fGeral...
          filename Files ;

%% Plot

% Pressão

if pressload
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,600];
    subplot(2,1,1)
    plot(tempo, pDes)
    hold on;
    plot(tempo, ones(1,length(tempo))*14.7,'LineWidth',2);
    hold off;
    ylabel('Pressão [bar]'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    legend({'Pressão de descarga','Setpoint'},'Location','best')

    subplot(2,1,2)
    plot(tempo, pSuc)
    hold on;
    plot(tempo, ones(1,length(tempo))*1.148,'LineWidth',2);
    hold off;
    ylabel('Pressão [bar]'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    legend({'Pressão de sucção','Setpoint'},'Location','best')

    pD.data = pDes;
    pD.t = tempo;
    
    pS.data = pSuc;
    pS.t = tempo;
    
    save(strcat(fpathVar,'\pressao_Descarga.mat'),'pD');
    save(strcat(fpathVar,'\pressao_Succao.mat'),'pS');
    
    savefig(strcat(fpathFig,'\pressao_DescargaSuccao.fig'));
    close all;
    
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,300];
    plot(tempo, pDes)
    hold on;
    plot(tempo, ones(1,length(tempo))*14.7,'LineWidth',2);
    hold off;
    ylabel('Pressão [bar]'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    legend({'Pressão de descarga','Setpoint'},'Location','best')
    
    savefig(strcat(fpathFig,'\pressao_Descarga.fig'));
    close all;
    
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,300];
    plot(tempo, pSuc)
    hold on;
    plot(tempo, ones(1,length(tempo))*1.148,'LineWidth',2);
    hold off;
    ylabel('Pressão [bar]'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    legend({'Pressão de sucção','Setpoint'},'Location','best')
    
    savefig(strcat(fpathFig,'\pressao_Succao.fig'));
    close all;
end

% Temperatura

if tempload
    fig = figure;
    fig.Position = [fig.Position(1:2),900,300];
    plot(tempo, tSuc,'LineWidth',2)
    hold on;
    plot(tempo, tComp,'LineWidth',2);
    plot(tempo, tInt,'LineWidth',2);
    plot(tempo, tAmb,'LineWidth',2);
    hold off;
    ylabel('Temperatura [ºC]'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    legend({'Sucção','Corpo','Intermediária','Descarga'},'Location','best')

    tS.data = tSuc;
    tS.t = tempo;
    tC.data = tComp;
    tC.t = tempo;
    tI.data = tInt;
    tI.t = tempo;
    tA.data = tAmb;
    tA.t = tempo;

    save(strcat(fpathVar,'\temperatura_Succao.mat'),'tS');
    save(strcat(fpathVar,'\temperatura_Compressor.mat'),'tC');
    save(strcat(fpathVar,'\temperatura_Intermediaria.mat'),'tI');
    save(strcat(fpathVar,'\temperatura_Ambiente.mat'),'tA');

    savefig(strcat(fpathFig,'\temperatura.fig'));
    close all;
end

% Posicao

if posload
    fig = figure;
    fig.Position = [fig.Position(1:2),900,300];
    plot(tempo, pos)
    hold on;
    plot(tempo, posSP);
    hold off;
    ylabel('Posição [Passos]'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    legend({'Posição','Referência'},'Location','best')

    posicao.data = pos;
    posicao.t = tempo;
    posicaoSP.data = posSP;
    posicaoSP.t = tempo;

    save(strcat(fpathVar,'\posicao'),'posicao');
    save(strcat(fpathVar,'\posicaoSP.mat'),'posicaoSP');

    savefig(strcat(fpathFig,'\posicao.fig'));
    close all;
end

% Vazão

if vazload
    fig = figure;
    fig.Position = [fig.Position(1:2),900,300];
    plot(tempo, vazao)
    ylabel('Vazão [kg/h]'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])

    vaz.data = vazao;
    vaz.t = tempo;
    save(strcat(fpathVar,'\vazao.mat'),'vaz');

    savefig(strcat(fpathFig,'\vazao.fig'));
    close all;
end
    
% RMS Corrente

if cRload
    fig = figure;
    fig.Position = [fig.Position(1:2),900,300];
    plot(teC, cRMS)
    ylabel('Valor RMS [A]'), xlabel('Tempo [h]')
    xlim([0 teC(end)])
    
    CR = cRMS;
    clear cRMS;
    
    cRMS.data = CR;
    cRMS.t = teC;
    save(strcat(fpathVar,'\corrente_RMS.mat'),'cRMS');

    savefig(strcat(fpathFig,'\corrente_RMS.fig'));
    close all;
end

% Curtose Corrente

if cKload
    fig = figure;
    fig.Position = [fig.Position(1:2),900,300];
    plot(teC, cKur)
    ylabel('Curtose'), xlabel('Tempo [h]')
    xlim([0 teC(end)])
    legend({'Corrente do compressor'},'Location','best')

    CK = cKur;
    clear cKur;
    
    cKur.data = CK;
    cKur.t = teC;
    save(strcat(fpathVar,'\corrente_Curtose.mat'),'cKur');

    savefig(strcat(fpathFig,'\corrente_Curtose.fig'));
    close all;
end

% RMS Vibração

if vRload
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,900];
    subplot(3,1,1)
    plot(tV, vxRMS)
    ylabel('Valor RMS [g]'), xlabel('Tempo [h]')
    xlim([0 tV(end)])
    title('Calota inferior do compressor');

    subplot(3,1,2)
    plot(tV, vyRMS)
    ylabel('Valor RMS [g]'), xlabel('Tempo [h]')
    xlim([0 tV(end)])
    title('Bancada');

    subplot(3,1,3)
    plot(tV, vzRMS)
    ylabel('Valor RMS [g]'), xlabel('Tempo [h]')
    xlim([0 tV(end)])
    title('Ambiente');

    vInfRMS.data = vxRMS;
    vInfRMS.t = tV;
    save(strcat(fpathVar,'\vibracao_CalotaInf_RMS.mat'),'vInfRMS');

    vBanRMS.data = vyRMS;
    vBanRMS.t = tV;
    save(strcat(fpathVar,'\vibracao_Bancada_RMS.mat'),'vBanRMS');
    
    vSupRMS.data = vzRMS;
    vSupRMS.t = tV;
    save(strcat(fpathVar,'\vibracao_CalotaSup_RMS.mat'),'vSupRMS');
    
    savefig(strcat(fpathFig,'\vibracao_RMS.fig'));
    close all;
    
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,300];
    plot(tV, vxRMS)
    ylabel('Valor RMS [g]'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    title('Calota inferior do compressor');
    savefig(strcat(fpathFig,'\vibracao_CalotaInf_RMS.fig'));
    close all;
    
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,300];
    plot(tV, vyRMS)
    ylabel('Valor RMS [g]'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    title('Bancada');
    savefig(strcat(fpathFig,'\vibracao_Bancada_RMS.fig'));
    close all;
    
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,300];
    plot(tV, vzRMS)
    ylabel('Valor RMS [g]'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    title('Calota superior do compressor');
    savefig(strcat(fpathFig,'\vibracao_CalotaSup_RMS.fig'));
    close all;
end

% Curtose Vibração

if vKload
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,900];
    subplot(3,1,1)  
    plot(tV, vxKur)
    ylabel('Curtose'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    title('Calota inferior do compressor');
    
    subplot(3,1,2) 
    plot(tV, vyKur)
    ylabel('Curtose'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    title('Bancada');
    
    subplot(3,1,3) 
    plot(tV, vzKur)
    ylabel('Curtose'), xlabel('Tempo [h]')
    xlim([0 tempo(end)])
    title('Calota inferior do compressor');

    vInfKur.data = vxKur;
    vInfKur.t = tV;
    save(strcat(fpathVar,'\vibracao_CalotaInf_Curtose.mat'),'vInfKur');

    vBanKur.data = vyKur;
    vBanKur.t = tV;
    save(strcat(fpathVar,'\vibracao_Bancada_Curtose.mat'),'vBanKur');
    
    vSupKur.data = vzKur;
    vSupKur.t = tV;
    save(strcat(fpathVar,'\vibracao_CalotaSup_Curtose.mat'),'vSupKur');
    
    savefig(strcat(fpathFig,'\vibracao_Curtose.fig'));
    close all;
    
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,300];
    plot(tV, vxKur)
    ylabel('Curtose'), xlabel('Tempo [h]')
    xlim([0 tV(end)])
    title('Calota inferior do compressor');
    savefig(strcat(fpathFig,'\vibracao_CalotaInf_Curtose.fig'));
    close all;
    
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,300];
    plot(tV, vyKur)
    ylabel('Curtose'), xlabel('Tempo [h]')
    xlim([0 tV(end)])
    title('Bancada');
    savefig(strcat(fpathFig,'\vibracao_Bancada_Curtose.fig'));
    close all;
    
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,300];
    plot(tV, vzKur)
    ylabel('Curtose'), xlabel('Tempo [h]')
    xlim([0 tV(end)])
    title('Calota superior do compressor');
    savefig(strcat(fpathFig,'\vibracao_CalotaSup_Curtose.fig'));
    close all;
end

% RMS Emissões Acústicas

if aRload
    fig = figure;
    fig.Position = [fig.Position(1:2),900,300];
    plot(teA, aRMS)
    ylabel('Valor RMS [A]'), xlabel('Tempo [h]')
    xlim([0 teA(end)])

    AR = aRMS;
    clear aRMS;
    
    aRMS.data = AR;
    aRMS.t = teA;
    save(strcat(fpathVar,'\acusticas_RMS.mat'),'aRMS');

    savefig(strcat(fpathFig,'\acusticas_RMS.fig'));
    close all;
end

% Curtose Emissões Acústicas

if aKload
    fig = figure;
    fig.Position = [fig.Position(1:2),900,300];
    plot(teA, aKur)
    ylabel('Curtose'), xlabel('Tempo [h]')
    xlim([0 teA(end)])
    legend({'Corrente do compressor'},'Location','best')

    AK = aKur;
    clear aKur;
    
    aKur.data = AK;
    aKur.t = teA;
    save(strcat(fpathVar,'\acusticas_Curtose.mat'),'aKur');

    savefig(strcat(fpathFig,'\acusticas_Curtose.fig'));
    close all;
end
