%% Análises temporal dos Sinais
% Gera variaveis de matlab e figuras a partir de dados pré 
% processados em labview utilizando o VI "conv_Waveform-TXT.vi" e do
% arquivo "medicoesGerais.dat"

clear; close all; clc;

% Parâmetros

cRload = 1; cKload = 1;
vRload = 1; vKload = 1;
aRload = 0; aKload = 0;
pressload = 1; tempload = 1; posload = 1; vazload = 1; 
usucload = 1; % Apenas para versões mais novas, que salvam uSuc

discardEnd = 1; % Descarta valores após o compressor ser desligado

fpathCell = {
             '\Amostra A1\N_2019_07_01';
             '\Amostra A2\A_2019_08_08';
             '\Amostra A2\A_2019_08_12';
             '\Amostra A2\A_2019_08_28';
             '\Amostra A2\N_2019_07_09';
             '\Amostra A3\A_2019_12_09';
             '\Amostra A3\A_2019_12_11';
             '\Amostra A3\N_2019_12_04';
             '\Amostra A4\A_2019_12_19';
             '\Amostra A4\A_2020_01_06';
             '\Amostra A4\A_2020_01_13';
             '\Amostra A4\N_2019_12_16';
             '\Amostra A5\A_2020_01_27';
             '\Amostra A5\A_2020_01_28';
             '\Amostra A5\N_2020_01_22';
%              '\Amostra B2\A_2020_09_02';
%              '\Amostra B2\A_2020_09_09';
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
%              '\Amostra B6\N_2021_01_27';
%              '\Amostra B6\N_2021_01_28';
%              '\Amostra B6\A_2021_02_02';
%              '\Amostra B7\N_2021_02_05';
%              '\Amostra B7\A_2021_02_08';
%              '\Amostra B7\A_2021_02_15';
%              '\Amostra B8\N_2021_02_18';
%              '\Amostra B8\A_2021_02_22';
%              '\Amostra B8\A_2021_02_26';
              };

fpathSourceInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Preparados';
fpathVarInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Processados';
fpathFigInit = 'D:\Documentos\Amaciamento\Ensaios\Imagens';



Tc = 60; % Tempo entre medições da corrente
Tv = 60; % Tempo entre medições da vibração
Ta = 600; % Tempo entre medições de emissões acústicas

% Colunas da Medição Geral

colTempo = 1; colTSuc = 2; colTComp = 3; colTInt = 4; colTDes = 5; 
colPSucOld = 6; colPSucNew = 21;  colPDes = 7; colPInt = 8; colPosSP = 9; colPos = 10; 
coluSuc = 12; colCompAtivo = 14; colVazao = 18;
% colCompAtivo = 12; colVazao = 16; % Versões antigas não salvavam tensão da válvula 


% -------------------------------------------------------------------------
%                         Adaptação de variáveis
for kf = 1:length(fpathCell)
    
    aRload = 1;
    aKload = 1;
    
    fpathFinal = fpathCell{kf};
    
    fcFolder = '\corrente';
    fcT = '\corrTempo*.dat';

    fvFolder = '\vibracao';
    fvT = '\vibTempo*.dat';

    faFolder = '\acusticas';
    faT = '\acuTempo*.dat';

    fGeral = '\medicoesGerais.dat';

    fpathSource = strcat(fpathSourceInit,fpathFinal);
    fpathVar = strcat(fpathVarInit,fpathFinal);
    fpathFig = strcat(fpathFigInit,fpathFinal);
    fcFolder = strcat(fpathSource,fcFolder);
    fcT = strcat(fcFolder,fcT);

    fvFolder = strcat(fpathSource,fvFolder);
    fvT = strcat(fvFolder,fvT);

    faFolder = strcat(fpathSource,faFolder);
    faT = strcat(faFolder,faT);
    
    mkdir(fpathFig); mkdir(fpathVar);
    
    data = importTestData(strcat(fpathSource,fGeral));
    data = data(2:end,:); % Descarta a primeira amostra
    compAtivo = data(:,colCompAtivo);
    
    if discardEnd
        kEnd = find(compAtivo,1,'last');
        data = data(1:kEnd,:);
    end
    
    
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
    t0 = t0*3600; tEnd = tempo(end);
    
    %% -------------------------------------------------------------------------
    %                         Carrega Tempo Corrente

    if cRload||cKload

        mf = dir(fcT); % Carrega todos os nomes de arquivos
        Files = sort(string({mf.name}'));
        clear mf;
        
        teC = (((1:length(Files))-1)*Tc-t0)/3600;
        
        cRMS = zeros(length(Files),1);
        cKur = zeros(length(Files),1);
        cSke = zeros(length(Files),1);
        cShape = zeros(length(Files),1);
        cTHD = zeros(length(Files),1);
        cCrest = zeros(length(Files),1);
        cPeak = zeros(length(Files),1);
        cVar = zeros(length(Files),1);
        cStd = zeros(length(Files),1);

        ppm = ParforProgressbar(length(Files));
        
        parfor k = 1:length(Files)
            ppm.increment();

            filename = strcat(fcFolder,'\',Files(k));

            data = importdata(filename);
            if size(data,2)>1
                data = data(:,1);
            end
            
            cRMS(k) = rms(data);
            cKur(k) = kurtosis(data);
            cSke(k) = skewness(data);
            cShape(k) = cRMS(k)/(mean(abs(data)));
            cTHD(k) = thd(data);
            cPeak(k) = max(abs(data));
            cCrest(k) = cPeak(k)/cRMS(k);
            cVar(k) = var(data);
            cStd(k) = std(data);
            temp = abs(data - mean(data));
        end

        cRMS = cRMS(teC<tEnd); cRMS = cRMS(2:end); 
        cKur = cKur(teC<tEnd); cKur = cKur(2:end);
        cSke = cSke(teC<tEnd); cSke = cSke(2:end);
        cShape = cShape(teC<tEnd); cShape = cShape(2:end);
        cTHD = cTHD(teC<tEnd); cTHD = cTHD(2:end);
        cCrest = cCrest(teC<tEnd); cCrest = cCrest(2:end);
        cPeak = cPeak(teC<tEnd); cPeak = cPeak(2:end);
        cVar = cVar(teC<tEnd); cVar = cVar(2:end);
        cStd = cStd(teC<tEnd); cStd = cStd(2:end);
        teC = teC(teC<tEnd); teC = teC(2:end);
        cRMS = cRMS-mean(cRMS(teC<0));
        delete(ppm);
        
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
        vxSke = zeros(length(Files),1);
        vxShape = zeros(length(Files),1);
        vxTHD = zeros(length(Files),1);
        vxCrest = zeros(length(Files),1);
        vxPeak = zeros(length(Files),1);
        vxVar = zeros(length(Files),1);
        vxStd = zeros(length(Files),1);
        
        vyRMS = zeros(length(Files),1);
        vyKur = zeros(length(Files),1);
        vySke = zeros(length(Files),1);
        vyShape = zeros(length(Files),1);
        vyTHD = zeros(length(Files),1);
        vyCrest = zeros(length(Files),1);
        vyPeak = zeros(length(Files),1);
        vyVar = zeros(length(Files),1);
        vyStd = zeros(length(Files),1);
        
        vzRMS = zeros(length(Files),1);
        vzKur = zeros(length(Files),1);
        vzSke = zeros(length(Files),1);
        vzShape = zeros(length(Files),1);
        vzTHD = zeros(length(Files),1);
        vzCrest = zeros(length(Files),1);
        vzPeak = zeros(length(Files),1);
        vzVar = zeros(length(Files),1);
        vzStd = zeros(length(Files),1);
        
        vxT = zeros(length(Files),25.6e+3);
        ppm = ParforProgressbar(length(Files));
        
        parfor k = 1:length(Files)
            ppm.increment();

            filename = strcat(fvFolder,'\',Files(k));

            data = importdata(filename);

            vxRMS(k) = rms(data(:,1));
            vxKur(k) = kurtosis(data(:,1)); 
            vxSke(k) = skewness(data(:,1));
            vxShape(k) = vxRMS(k)/(mean(abs(data(:,1)))); 
            vxTHD(k) = thd(data(:,1));
            vxPeak(k) = max(abs(data(:,1)));
            vxCrest(k) = vxPeak(k)/vxRMS(k);
            vxStd(k) = std(data(:,1));
            vxVar(k) = var(data(:,1));       

            vyRMS(k) = rms(data(:,2));
            vyKur(k) = kurtosis(data(:,2));
            vySke(k) = skewness(data(:,2));
            vyShape(k) = vyRMS(k)/(mean(abs(data(:,2))));
            vyTHD(k) = thd(data(:,2));
            vyPeak(k) = max(abs(data(:,2)));
            vyCrest(k) = vyPeak(k)/vyRMS(k);
            vyStd(k) = std(data(:,2));
            vyVar(k) = var(data(:,2));
            
            vzRMS(k) = rms(data(:,3));
            vzKur(k) = kurtosis(data(:,3));
            vzSke(k) = skewness(data(:,3));
            vzShape(k) = vzRMS(k)/(mean(abs(data(:,3))));
            vzTHD(k) = thd(data(:,3));
            vzPeak(k) = max(abs(data(:,3)));
            vzCrest(k) = vzPeak(k)/vzRMS(k);
            vzStd(k) = std(data(:,3));
            vzVar(k) = var(data(:,3));
        end
        
        vxRMS = vxRMS(tV<tEnd); vxRMS = vxRMS(2:end); 
        vxKur = vxKur(tV<tEnd); vxKur = vxKur(2:end);
        vxSke = vxSke(tV<tEnd); vxSke = vxSke(2:end);
        vxShape = vxShape(tV<tEnd); vxShape = vxShape(2:end);
        vxTHD = vxTHD(tV<tEnd); vxTHD = vxTHD(2:end);
        vxCrest = vxCrest(tV<tEnd); vxCrest = vxCrest(2:end);
        vxPeak = vxPeak(tV<tEnd); vxPeak = vxPeak(2:end);
        vxVar = vxVar(tV<tEnd); vxVar = vxVar(2:end);
        vxStd = vxStd(tV<tEnd); vxStd = vxStd(2:end);
        
        vyRMS = vyRMS(tV<tEnd); vyRMS = vyRMS(2:end); 
        vyKur = vyKur(tV<tEnd); vyKur = vyKur(2:end);
        vySke = vySke(tV<tEnd); vySke = vySke(2:end);
        vyShape = vyShape(tV<tEnd); vyShape = vyShape(2:end);
        vyTHD = vyTHD(tV<tEnd); vyTHD = vyTHD(2:end);
        vyCrest = vyCrest(tV<tEnd); vyCrest = vyCrest(2:end);
        vyPeak = vyPeak(tV<tEnd); vyPeak = vyPeak(2:end);
        vyVar = vyVar(tV<tEnd); vyVar = vyVar(2:end);
        vyStd = vyStd(tV<tEnd); vyStd = vyStd(2:end);
        
        vzRMS = vzRMS(tV<tEnd); vzRMS = vzRMS(2:end); 
        vzKur = vzKur(tV<tEnd); vzKur = vzKur(2:end);
        vzSke = vzSke(tV<tEnd); vzSke = vzSke(2:end);
        vzShape = vzShape(tV<tEnd); vzShape = vzShape(2:end);
        vzTHD = vzTHD(tV<tEnd); vzTHD = vzTHD(2:end);
        vzCrest = vzCrest(tV<tEnd); vzCrest = vzCrest(2:end);
        vzPeak = vzPeak(tV<tEnd); vzPeak = vzPeak(2:end);
        vzVar = vzVar(tV<tEnd); vzVar = vzVar(2:end);
        vzStd = vzStd(tV<tEnd); vzStd = vzStd(2:end);
        tV = tV(tV<tEnd); tV = tV(2:end);
        
        delete(ppm);
        clear data;
    end

    %% -------------------------------------------------------------------
    %                         Carrega Tempo Emissões Acusticas

    if aRload||aKload
        mf = dir(faT); % Carrega todos os nomes de arquivos
        if isempty(mf)
            aRload = 0;
            aKload = 0;
        else
            Files = sort(string({mf.name}'));
            clear mf;
            
            teA = (((1:length(Files))-1)*Ta-t0)/3600;

            aRMS = zeros(length(Files),1);
            aKur = zeros(length(Files),1);

            ppm = ParforProgressbar(length(Files));
            
            for k = 1:length(Files)
                ppm.increment();

                filename = strcat(faFolder,'\',Files(k));

                data = importdata(filename);

                aRMS(k) = rms(data);
                aKur(k) = kurtosis(data);
            end

            aRMS = aRMS(teA<tEnd); aRMS = aRMS(2:end); 
            aKur = aKur(teA<tEnd); aKur = aKur(2:end);
            teA = teA(teA<tEnd); teA = teA(2:end);
            delete(ppm);
            
            clear data;
        end
    end

    %% Plot

    % Pressão

    if pressload
        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,600];
        subplot(3,1,1)
        plot(tempo, pDes)
        hold on;
        plot(tempo, ones(1,length(tempo))*14.7,'LineWidth',2);
        hold off;
        ylabel('Pressão [bar]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        legend({'Pressão de descarga','Setpoint'},'Location','best')


        subplot(3,1,1)
        plot(tempo, pDes)
        hold on;
        plot(tempo, ones(1,length(tempo))*14.7,'LineWidth',2);
        hold off;
        ylabel('Pressão [bar]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        legend({'Pressão de descarga','Setpoint'},'Location','best')

        subplot(3,1,2)
        plot(tempo, pInt)
        hold off;
        ylabel('Pressão [bar]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        legend({'Pressão intermediária'},'Location','best')

        pD.data = pDes;
        pD.t = tempo;

        pI.data = pInt;
        pI.t = tempo;

        pS.data = pSuc;
        pS.t = tempo;

        save(strcat(fpathVar,'\pressao_Descarga.mat'),'pD');
        save(strcat(fpathVar,'\pressao_Succao.mat'),'pS');
        save(strcat(fpathVar,'\pressao_Intermediaria.mat'),'pS');

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

    % Tensão da válvula de sucção

    if usucload && ~isnan(uSuc(1))
        fig = figure;
        fig.Position = [fig.Position(1:2),900,300];
        plot(tempo, uSuc)

        ylabel('Tensão [V]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])

        tensaoSuc.data = uSuc;
        tensaoSuc.t = tempo;

        save(strcat(fpathVar,'\tensaoSuc.mat'),'tensaoSuc');

        savefig(strcat(fpathFig,'\tensaoSuc.fig'));
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
        
        % Skewness
        fig = figure;
        fig.Position = [fig.Position(1:2),900,300];
        plot(teC, cSke)
        ylabel('Assimetria [adim]'), xlabel('Tempo [h]')
        xlim([0 teC(end)])

        temp = cSke;
        clear cSke;

        cSke.data = temp;
        cSke.t = teC;
        save(strcat(fpathVar,'\corrente_Skewness.mat'),'cSke');

        savefig(strcat(fpathFig,'\corrente_Skewness.fig'));
        
        % Shape Factor
        fig = figure;
        fig.Position = [fig.Position(1:2),900,300];
        plot(teC, cShape)
        ylabel('Fator de forma [adim]'), xlabel('Tempo [h]')
        xlim([0 teC(end)])

        temp = cShape;
        clear cShape;

        cShape.data = temp;
        cShape.t = teC;
        save(strcat(fpathVar,'\corrente_Shape.mat'),'cShape');

        savefig(strcat(fpathFig,'\corrente_Shape.fig'));
        
        % THD
        fig = figure;
        fig.Position = [fig.Position(1:2),900,300];
        plot(teC, cTHD)
        ylabel('THD [adim]'), xlabel('Tempo [h]')
        xlim([0 teC(end)])

        temp = cTHD;
        clear cTHD;

        cTHD.data = temp;
        cTHD.t = teC;
        save(strcat(fpathVar,'\corrente_THD.mat'),'cTHD');

        savefig(strcat(fpathFig,'\corrente_THD.fig'));
        
        % Pico
        fig = figure;
        fig.Position = [fig.Position(1:2),900,300];
        plot(teC, cPeak)
        ylabel('Pico [A]'), xlabel('Tempo [h]')
        xlim([0 teC(end)])

        temp = cPeak;
        clear cPeak;

        cPeak.data = temp;
        cPeak.t = teC;
        save(strcat(fpathVar,'\corrente_Peak.mat'),'cPeak');

        savefig(strcat(fpathFig,'\corrente_Peak.fig'));
        
        % Fator de Crista
        fig = figure;
        fig.Position = [fig.Position(1:2),900,300];
        plot(teC, cCrest)
        ylabel('Fator de Crista [adim]'), xlabel('Tempo [h]')
        xlim([0 teC(end)])

        temp = cCrest;
        clear cCrest;

        cCrest.data = temp;
        cCrest.t = teC;
        save(strcat(fpathVar,'\corrente_Crest.mat'),'cCrest');

        savefig(strcat(fpathFig,'\corrente_Crest.fig'));
        
        % Variance
        fig = figure;
        fig.Position = [fig.Position(1:2),900,300];
        plot(teC, cVar)
        ylabel('Variância [adim]'), xlabel('Tempo [h]')
        xlim([0 teC(end)])

        temp = cVar;
        clear cVar;

        cVar.data = temp;
        cVar.t = teC;
        save(strcat(fpathVar,'\corrente_Var.mat'),'cVar');

        savefig(strcat(fpathFig,'\corrente_Var.fig'));
        
        % Desvio padrão
        fig = figure;
        fig.Position = [fig.Position(1:2),900,300];
        plot(teC, cStd)
        ylabel('Desvio padrão [adim]'), xlabel('Tempo [h]')
        xlim([0 teC(end)])

        temp = cStd;
        clear cStd;

        cStd.data = temp;
        cStd.t = teC;
        save(strcat(fpathVar,'\corrente_Std.mat'),'cStd');

        savefig(strcat(fpathFig,'\corrente_Std.fig'));
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

   

    if vRload
        % RMS Vibração
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
        title('Calota superior do compressor');

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
        
        
        % Assimetria (Skewness)
        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,900];
        subplot(3,1,1)
        plot(tV, vxSke)
        ylabel('Assimetria [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota inferior do compressor');

        subplot(3,1,2)
        plot(tV, vySke)
        ylabel('Assimetria [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Bancada');

        subplot(3,1,3)
        plot(tV, vzSke)
        ylabel('Assimetria [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota superior do compressor');

        vInfSke.data = vxSke;
        vInfSke.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaInf_Ske.mat'),'vInfSke');

        vBanSke.data = vySke;
        vBanSke.t = tV;
        save(strcat(fpathVar,'\vibracao_Bancada_Ske.mat'),'vBanSke');

        vSupSke.data = vzSke;
        vSupSke.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaSup_Ske.mat'),'vSupSke');

        savefig(strcat(fpathFig,'\vibracao_Ske.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vxSke)
        ylabel('Assimetria [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota inferior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaInf_Ske.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vySke)
        ylabel('Assimetria [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Bancada');
        savefig(strcat(fpathFig,'\vibracao_Bancada_Ske.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vzSke)
        ylabel('Assimetria [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota superior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaSup_Ske.fig'));
        close all;
        
        % Fator de forma
        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,900];
        subplot(3,1,1)
        plot(tV, vxShape)
        ylabel('Fator de forma [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota inferior do compressor');

        subplot(3,1,2)
        plot(tV, vyShape)
        ylabel('Fator de forma [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Bancada');

        subplot(3,1,3)
        plot(tV, vzShape)
        ylabel('Fator de forma [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota superior do compressor');

        vInfShape.data = vxShape;
        vInfShape.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaInf_Shape.mat'),'vInfShape');

        vBanShape.data = vyShape;
        vBanShape.t = tV;
        save(strcat(fpathVar,'\vibracao_Bancada_Shape.mat'),'vBanShape');

        vSupShape.data = vzShape;
        vSupShape.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaSup_Shape.mat'),'vSupShape');

        savefig(strcat(fpathFig,'\vibracao_Shape.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vxShape)
        ylabel('Fator de forma [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota inferior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaInf_Shape.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vyShape)
        ylabel('Fator de forma [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Bancada');
        savefig(strcat(fpathFig,'\vibracao_Bancada_Shape.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vzShape)
        ylabel('Fator de forma [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota superior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaSup_Shape.fig'));
        close all;
        
        % THD
        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,900];
        subplot(3,1,1)
        plot(tV, vxTHD)
        ylabel('THD [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota inferior do compressor');

        subplot(3,1,2)
        plot(tV, vyTHD)
        ylabel('THD [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Bancada');

        subplot(3,1,3)
        plot(tV, vzTHD)
        ylabel('THD [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota superior do compressor');

        vInfTHD.data = vxTHD;
        vInfTHD.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaInf_THD.mat'),'vInfTHD');

        vBanTHD.data = vyTHD;
        vBanTHD.t = tV;
        save(strcat(fpathVar,'\vibracao_Bancada_THD.mat'),'vBanTHD');

        vSupTHD.data = vzTHD;
        vSupTHD.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaSup_THD.mat'),'vSupTHD');

        savefig(strcat(fpathFig,'\vibracao_THD.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vxTHD)
        ylabel('THD [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota inferior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaInf_THD.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vyTHD)
        ylabel('THD [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Bancada');
        savefig(strcat(fpathFig,'\vibracao_Bancada_THD.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vzTHD)
        ylabel('THD [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota superior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaSup_THD.fig'));
        close all;
        
        % Crest
        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,900];
        subplot(3,1,1)
        plot(tV, vxCrest)
        ylabel('Fator de crista [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota inferior do compressor');

        subplot(3,1,2)
        plot(tV, vyCrest)
        ylabel('Fator de crista [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Bancada');

        subplot(3,1,3)
        plot(tV, vzCrest)
        ylabel('Fator de crista [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota superior do compressor');

        vInfCrest.data = vxCrest;
        vInfCrest.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaInf_Crest.mat'),'vInfCrest');

        vBanCrest.data = vyCrest;
        vBanCrest.t = tV;
        save(strcat(fpathVar,'\vibracao_Bancada_Crest.mat'),'vBanCrest');

        vSupCrest.data = vzCrest;
        vSupCrest.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaSup_Crest.mat'),'vSupCrest');

        savefig(strcat(fpathFig,'\vibracao_Crest.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vxCrest)
        ylabel('Fator de crista [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota inferior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaInf_Crest.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vyCrest)
        ylabel('Fator de crista [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Bancada');
        savefig(strcat(fpathFig,'\vibracao_Bancada_Crest.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vzCrest)
        ylabel('Fator de crista [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota superior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaSup_Crest.fig'));
        close all;
        
        % Peak
        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,900];
        subplot(3,1,1)
        plot(tV, vxPeak)
        ylabel('Pico [g]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota inferior do compressor');

        subplot(3,1,2)
        plot(tV, vyPeak)
        ylabel('Pico [g]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Bancada');

        subplot(3,1,3)
        plot(tV, vzPeak)
        ylabel('Pico [g]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota superior do compressor');

        vInfPeak.data = vxPeak;
        vInfPeak.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaInf_Peak.mat'),'vInfPeak');

        vBanPeak.data = vyPeak;
        vBanPeak.t = tV;
        save(strcat(fpathVar,'\vibracao_Bancada_Peak.mat'),'vBanPeak');

        vSupPeak.data = vzPeak;
        vSupPeak.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaSup_Peak.mat'),'vSupPeak');

        savefig(strcat(fpathFig,'\vibracao_Peak.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vxPeak)
        ylabel('Pico [g]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota inferior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaInf_Peak.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vyPeak)
        ylabel('Pico [g]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Bancada');
        savefig(strcat(fpathFig,'\vibracao_Bancada_Peak.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vzPeak)
        ylabel('Pico [g]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota superior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaSup_Peak.fig'));
        close all;
        
        % Desvio Padrão
        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,900];
        subplot(3,1,1)
        plot(tV, vxStd)
        ylabel('Desvio Padrão [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota inferior do compressor');

        subplot(3,1,2)
        plot(tV, vyStd)
        ylabel('Desvio Padrão [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Bancada');

        subplot(3,1,3)
        plot(tV, vzStd)
        ylabel('Desvio Padrão [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota superior do compressor');

        vInfStd.data = vxStd;
        vInfStd.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaInf_Std.mat'),'vInfStd');

        vBanStd.data = vyStd;
        vBanStd.t = tV;
        save(strcat(fpathVar,'\vibracao_Bancada_Std.mat'),'vBanStd');

        vSupStd.data = vzStd;
        vSupStd.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaSup_Std.mat'),'vSupStd');

        savefig(strcat(fpathFig,'\vibracao_Std.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vxStd)
        ylabel('Desvio Padrão [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota inferior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaInf_Std.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vyStd)
        ylabel('Desvio Padrão [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Bancada');
        savefig(strcat(fpathFig,'\vibracao_Bancada_Std.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vzStd)
        ylabel('Desvio Padrão [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota superior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaSup_Std.fig'));
        close all;
        
        % Variância
        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,900];
        subplot(3,1,1)
        plot(tV, vxVar)
        ylabel('Variância [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota inferior do compressor');

        subplot(3,1,2)
        plot(tV, vyVar)
        ylabel('Variância [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Bancada');

        subplot(3,1,3)
        plot(tV, vzVar)
        ylabel('Variância [adim]'), xlabel('Tempo [h]')
        xlim([0 tV(end)])
        title('Calota superior do compressor');

        vInfVar.data = vxVar;
        vInfVar.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaInf_Var.mat'),'vInfVar');

        vBanVar.data = vyVar;
        vBanVar.t = tV;
        save(strcat(fpathVar,'\vibracao_Bancada_Var.mat'),'vBanVar');

        vSupVar.data = vzVar;
        vSupVar.t = tV;
        save(strcat(fpathVar,'\vibracao_CalotaSup_Var.mat'),'vSupVar');

        savefig(strcat(fpathFig,'\vibracao_Var.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vxVar)
        ylabel('Variância [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota inferior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaInf_Var.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vyVar)
        ylabel('Variância [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Bancada');
        savefig(strcat(fpathFig,'\vibracao_Bancada_Var.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tV, vzVar)
        ylabel('Variância [adim]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        title('Calota superior do compressor');
        savefig(strcat(fpathFig,'\vibracao_CalotaSup_Var.fig'));
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
end