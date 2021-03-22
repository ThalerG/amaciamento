%% Decomposição do sinal de vibração
% 

clear; close all; clc;

% Parâmetros

fpathCell = {%'\Amostra A1\N_2019_07_01';
%              '\Amostra A2\A_2019_08_08';
%              '\Amostra A2\A_2019_08_12';
%              '\Amostra A2\A_2019_08_28';
%              '\Amostra A2\A_2019_10_02';
%              '\Amostra A2\A_2019_10_14';
%              '\Amostra A2\N_2019_07_09';
%              '\Amostra A3\A_2019_12_09';
%              '\Amostra A3\A_2019_12_11';
%              '\Amostra A3\N_2019_12_04';
%              '\Amostra A4\A_2019_12_19';
%              '\Amostra A4\A_2020_01_06';
%              '\Amostra A4\A_2020_01_13';
%              '\Amostra A4\N_2019_12_16';
              '\Amostra A5\A_2020_01_27';
%              '\Amostra A5\A_2020_01_28';
              '\Amostra A5\N_2020_01_22';
%              '\Amostra B2\A_2020_09_08';
%              '\Amostra B2\A_2020_09_09';
%              '\Amostra B2\N_2020_07_02';
%              '\Amostra B3\A_2020_09_22';
%              '\Amostra B3\A_2020_09_24';
%              '\Amostra B3\N_2020_09_11';
%              '\Amostra B4\A_2020_10_02';
%              '\Amostra B4\A_2020_10_06';
%              '\Amostra B4\A_2020_10_08';
%              '\Amostra B4\N_2020_09_30';
%              '\Amostra B5\N_2020_10_16';
%              '\Amostra B5\A_2020_10_22';
%              '\Amostra B5\A_2020_10_26';
%              '\Amostra B5\A_2020_10_27';
              };
          
nBands = 50;
sup = 10;
fend = 10e3;
Fs = 25.6e3;
          
fpathSourceInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Preparados';
fpathVarInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Processados';
fpathFigInit = 'D:\Documentos\Amaciamento\Ensaios\Imagens';

Tv = 60; % Tempo entre medições da vibração

% Colunas da Medição Geral

colTempo = 1; colTSuc = 2; colTComp = 3; colTInt = 4; colTDes = 5; 
colPSucOld = 6; colPSucNew = 21;  colPDes = 7; colPInt = 8; colPosSP = 9; colPos = 10; 
coluSuc = 12; colCompAtivo = 14; colVazao = 18;
% colCompAtivo = 12; colVazao = 16; % Versões antigas não salvavam tensão da válvula 

% -------------------------------------------------------------------------
%                         Adaptação de variáveis
for kf = 1:length(fpathCell)
    
    fpathFinal = fpathCell{kf};
   
    fvFolder = '\vibracao';
    fvT = '\vibTempo*.dat';

    fGeral = '\medicoesGerais.dat';

    fpathSource = strcat(fpathSourceInit,fpathFinal);
    fpathVar = strcat(fpathVarInit,fpathFinal);
    fpathFig = strcat(fpathFigInit,fpathFinal);

    fvFolder = strcat(fpathSource,fvFolder);
    fvT = strcat(fvFolder,fvT);
    
    mkdir(fpathFig); mkdir(fpathVar);
    
    data = importTestData(strcat(fpathSource,fGeral));

    t = data(:,colTempo)/3600; tSuc = data(:,colTSuc); tComp = data(:,colTComp);
    tInt = data(:,colTInt); tAmb = data(:,colTDes); pSuc = data(:,colPSucNew); 
    pDes = data(:,colPDes); pInt = data(:,colPInt); posSP = data(:,colPosSP); pos = data(:,colPos);
    compAtivo = data(:,colCompAtivo); vazao = data(:,colVazao);
    uSuc = data(:,coluSuc); % Quando disponível
    
    if isnan(pSuc(2))
        pSuc = data(:,colPSucOld);
    end

    clear data;

    t0 = t(compAtivo>0); t0 = t0(1);
    tempo = (t-t0);
    t0 = t0*3600;


    %% -------------------------------------------------------------------------
    %                         Carrega Tempo Vibracao

    
    mf = dir(fvT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;

    tV = (((1:length(Files))-1)*Tv-t0)/3600;

    vxT = nan(length(Files),25.6e+3);
    vyT = nan(length(Files),25.6e+3);
    
    vxB = nan(length(Files),nBands);
    vyB = nan(length(Files),nBands);
    
    for k = 1:length(Files)
        disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

        filename = strcat(fvFolder,'\',Files(k));

        data = importdata(filename);

        vxT(k,:) = data(:,1);
        vyT(k,:) = data(:,2);
        
        [vxB(k,:),f] = bandPower(vxT(k,:),Fs,fend,nBands,sup);
        [vyB(k,:),~] = bandPower(vyT(k,:),Fs,fend,nBands,sup);
        
    end

    clear data;
    
    figure;
    B = 20*log(vxB*9.80665/(1e-6));
    vZoomFigX = surf(tV,f,B');
    ylim([f(1) f(end)]);
    xlim([0 tV(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    cmax = max(max(B(tV>0,:))); cmin = min(min(B(tV>0,:)));
    caxis([cmin, cmax]);
    set(vZoomFigX,'edgecolor','none')
    xlabel('Tempo [h]');
    ylabel('Frequência [Hz]');
    title('Zoom Vibração Calota Inferior');
    view(2);
    
    clear vxB;
    
    figure;
    B = 20*log(vyB*9.80665/(1e-6));
    vZoomFigy = surf(tV,f,B');
    ylim([f(1) f(end)]);
    xlim([0 tV(end)]);
    c = colorbar;
    c.Label.String = 'Amplitude [dB]';
    cmax = max(max(B(tV>0,:))); cmin = min(min(B(tV>0,:)));
    caxis([cmin, cmax]);
    set(vZoomFigy,'edgecolor','none')
    xlabel('Tempo [h]');
    ylabel('Frequência [Hz]');
    title('Zoom Vibração Calota Superior');
    view(2);
    
    clear vyB;
end

