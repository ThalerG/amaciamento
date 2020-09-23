%% An�lises temporal dos Sinais
% Gera variaveis de matlab e figuras a partir de dados pr� 
% processados em labview utilizando o VI "conv_Waveform-TXT.vi" e do
% arquivo "medicoesGerais.dat"

clear; close all; clc;

% Par�metros

cRload = 1; cKload = 1;
vRload = 1; vKload = 1;
aRload = 1; aKload = 1;
pressload = 1; tempload = 1; posload = 1; vazload = 1; 
usucload = 1; % Apenas para vers�es mais novas, que salvam uSuc

fpathCell = {% '\Amostra A1\N_2019_07_01';
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
%              '\Amostra A5\A_2020_01_27';
%              '\Amostra A5\A_2020_01_28';
%              '\Amostra A5\N_2020_01_22';
%              '\Amostra B2\A_2020_07_06';
%              '\Amostra B2\A_2020_07_10';
%              '\Amostra B2\A_2020_08_17';
%              '\Amostra B2\A_2020_08_28';
%              '\Amostra B2\A_2020_09_02';
             '\Amostra B2\A_2020_09_08';
             '\Amostra B2\A_2020_09_09';
             '\Amostra B2\N_2020_07_02'};


fpathSourceInit = 'D:\Documentos\Amaciamento\EnsaiosBCKP\Dados Preparados';
fpathVarInit = 'D:\Documentos\Amaciamento\EnsaiosBCKP\Dados Processados';
fpathFigInit = 'D:\Documentos\Amaciamento\EnsaiosBCKP\Imagens';



Tc = 60; % Tempo entre medi��es da corrente
Tv = 60; % Tempo entre medi��es da vibra��o
Ta = 600; % Tempo entre medi��es de emiss�es ac�sticas

% Colunas da Medi��o Geral

colTempo = 1; colTSuc = 2; colTComp = 3; colTInt = 4; colTDes = 5; 
colPSucOld = 6; colPSucNew = 21;  colPDes = 7; colPInt = 8; colPosSP = 9; colPos = 10; 
coluSuc = 12; colCompAtivo = 14; colVazao = 18;
% colCompAtivo = 12; colVazao = 16; % Vers�es antigas n�o salvavam tens�o da v�lvula 


% -------------------------------------------------------------------------
%                         Adapta��o de vari�veis
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

    t = data(:,colTempo)/3600; tSuc = data(:,colTSuc); tComp = data(:,colTComp);
    tInt = data(:,colTInt); tAmb = data(:,colTDes); pSuc = data(:,colPSucNew); 
    pDes = data(:,colPDes); pInt = data(:,colPInt); posSP = data(:,colPosSP); pos = data(:,colPos);
    compAtivo = data(:,colCompAtivo); vazao = data(:,colVazao);
    uSuc = data(:,coluSuc); % Quando dispon�vel
    
    if isnan(pSuc(2))
        pSuc = data(:,colPSucOld);
    end

    clear data;

    t0 = t(compAtivo>0); t0 = t0(1);
    tempo = (t-t0);
    t0 = t0*3600;

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
    %                         Carrega Tempo Emiss�es Acusticas

    if aRload||aKload
        mf = dir(faT); % Carrega todos os nomes de arquivos
        if isempty(mf)
            Files = sort(string({mf.name}'));
            aRload = 0;
            aKload = 0;
        else
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
    end

    %% Plot

    % Press�o

    if pressload
        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,600];
        subplot(3,1,1)
        plot(tempo, pDes)
        hold on;
        plot(tempo, ones(1,length(tempo))*14.7,'LineWidth',2);
        hold off;
        ylabel('Press�o [bar]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        legend({'Press�o de descarga','Setpoint'},'Location','best')


        subplot(3,1,1)
        plot(tempo, pDes)
        hold on;
        plot(tempo, ones(1,length(tempo))*14.7,'LineWidth',2);
        hold off;
        ylabel('Press�o [bar]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        legend({'Press�o de descarga','Setpoint'},'Location','best')

        subplot(3,1,2)
        plot(tempo, pInt)
        hold off;
        ylabel('Press�o [bar]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        legend({'Press�o intermedi�ria'},'Location','best')

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
        ylabel('Press�o [bar]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        legend({'Press�o de descarga','Setpoint'},'Location','best')

        savefig(strcat(fpathFig,'\pressao_Descarga.fig'));
        close all;

        fig = figure;
        fig.Position = [fig.Position(1:2)-[0,500],900,300];
        plot(tempo, pSuc)
        hold on;
        plot(tempo, ones(1,length(tempo))*1.148,'LineWidth',2);
        hold off;
        ylabel('Press�o [bar]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        legend({'Press�o de suc��o','Setpoint'},'Location','best')

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
        ylabel('Temperatura [�C]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        legend({'Suc��o','Corpo','Intermedi�ria','Descarga'},'Location','best')

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
        ylabel('Posi��o [Passos]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])
        legend({'Posi��o','Refer�ncia'},'Location','best')

        posicao.data = pos;
        posicao.t = tempo;
        posicaoSP.data = posSP;
        posicaoSP.t = tempo;

        save(strcat(fpathVar,'\posicao'),'posicao');
        save(strcat(fpathVar,'\posicaoSP.mat'),'posicaoSP');

        savefig(strcat(fpathFig,'\posicao.fig'));
        close all;
    end

    % Tens�o da v�lvula de suc��o

    if usucload && ~isnan(uSuc(1))
        fig = figure;
        fig.Position = [fig.Position(1:2),900,300];
        plot(tempo, uSuc)

        ylabel('Tens�o [V]'), xlabel('Tempo [h]')
        xlim([0 tempo(end)])

        tensaoSuc.data = uSuc;
        tensaoSuc.t = tempo;

        save(strcat(fpathVar,'\tensaoSuc.mat'),'tensaoSuc');

        savefig(strcat(fpathFig,'\tensaoSuc.fig'));
        close all;
    end

    % Vaz�o

    if vazload
        fig = figure;
        fig.Position = [fig.Position(1:2),900,300];
        plot(tempo, vazao)
        ylabel('Vaz�o [kg/h]'), xlabel('Tempo [h]')
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

    % RMS Vibra��o

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

    % Curtose Vibra��o

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

    % RMS Emiss�es Ac�sticas

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

    % Curtose Emiss�es Ac�sticas

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