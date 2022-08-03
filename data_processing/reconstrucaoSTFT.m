%% Reconstrução de sinais
% Gera variaveis de matlab e figuras a partir de dados de frequencia pré 
% processados em labview utilizando o VI "conv_Waveform-TXT.vi"

clear; close all; clc;

% Parâmetros

cload = 1;
vload = 1;

discardEnd = 1; % Descarta valores após o compressor ser desligado

fpathCell = {
%              '\Amostra A1\N_2019_07_01';
%              '\Amostra A2\A_2019_08_08';
%              '\Amostra A2\A_2019_08_12';
%              '\Amostra A2\A_2019_08_28';
             '\Amostra A2\N_2019_07_09';
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
%              '\Amostra B2\A_2020_09_02';
%              '\Amostra B2\A_2020_09_09';
%              '\Amostra B3\N_2020_09_11';
%              '\Amostra B3\A_2020_09_22';
%              '\Amostra B3\A_2020_09_24';
%              '\Amostra B4\N_2020_09_30';
%              '\Amostra B4\A_2020_10_02';
%              '\Amostra B4\A_2020_10_06';
%              '\Amostra B4\A_2020_10_08';
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
%              '\Amostra B7\A_2021_07_24';
%              '\Amostra B8\N_2021_02_18';
%              '\Amostra B8\A_2021_02_22';
%              '\Amostra B8\A_2021_02_26';
%              '\Amostra B10\N_2021_03_22';
%              '\Amostra B10\A_2021_03_25';
%              '\Amostra B10\A_2021_03_30';
%              '\Amostra B11\N_2021_04_05';
%              '\Amostra B11\A_2021_04_08';
%              '\Amostra B11\A_2021_04_22';
%              '\Amostra B12\N_2021_04_27';
%              '\Amostra B12\A_2021_04_30';
%              '\Amostra B12\A_2021_05_03'; 
%              '\Amostra B12\A_2021_05_04';
%              '\Amostra B15\N_2021_05_31';
%              '\Amostra B15\A_2021_06_07';
%              '\Amostra B15\A_2021_06_09';
%              '\Amostra B15\A_2021_06_15';
             };

fpathSourceInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Preparados';
fpathVarInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Processados';
fpathFigInit = 'D:\Documentos\Amaciamento\Ensaios\Imagens';

fGeral = '\medicoesGerais.dat';

fs = 25.6e3;
Tc = 60; % Tempo entre medições da corrente
Tv = 60; % Tempo entre medições da vibração
Ta = 600; % Tempo entre medições de emissões acústicas

colTempo = 1; colCompAtivo = 14;

% -------------------------------------------------------------------------
%                         Adaptação de variáveis
for kf = 1:length(fpathCell)
    
    fpathFinal = fpathCell{kf};
    
    fcFolder = '\corrente';
    fcT = '\corrTempo*.dat';

    fvFolder = '\vibracao';
    fvT = '\vibTempo*.dat';

    fGeral = '\medicoesGerais.dat';

    fpathSource = strcat(fpathSourceInit,fpathFinal);
    fpathVar = strcat(fpathVarInit,fpathFinal);
    fpathFig = strcat(fpathFigInit,fpathFinal);
    fcFolder = strcat(fpathSource,fcFolder);
    fcT = strcat(fcFolder,fcT);

    fvFolder = strcat(fpathSource,fvFolder);
    fvT = strcat(fvFolder,fvT);
    
    mkdir(fpathFig); mkdir(fpathVar);
    
    data = importTestData(strcat(fpathSource,fGeral));
    data = data(2:end,:); % Descarta a primeira amostra
    compAtivo = data(:,colCompAtivo);
    
    if discardEnd % Descarta valores após desligar
        kEnd = find(compAtivo,1,'last');
        data = data(1:kEnd,:);
    end
    
    t = data(:,colTempo)/3600;
    compAtivo = data(:,colCompAtivo);
    
    clear data;

    t0 = t(compAtivo>0); t0 = t0(1);
    tempo = (t-t0);
    t0 = t0*3600; tEnd = tempo(end);
    
    if cload
        mf = dir(fcT); % Carrega todos os nomes de arquivos
        Files = sort(string({mf.name}'));
        clear mf;
        
        teC = [NaN;tempo];
        
        corFFT = zeros(length(Files),fs);

        ppm = ParforProgressbar(length(Files));
        
        for k = 1:length(Files)
            ppm.increment();

            filename = strcat(fcFolder,'\',Files(k));

            data = table2array(readtable(filename,'ReadVariableNames', false));
            if size(data,2)>1
                data = data(:,1);
            end
            
            corFFT(k,:) = fft(data);
        end

        corFFT = corFFT(teC<=tEnd,:);
        teC = teC(teC<=tEnd);
        delete(ppm);
        clear data;
    end
    
    cFFT.data = corFFT; clear corFFT;
    cFFT.t = teC;
    cFFT.f = fs/2*linspace(-1,1,fs);
    save(strcat(fpathVar,'\corrente_FFT.mat'),'cFFT','-v7.3');
    
    clear cFFT;    
    
    if vload
        mf = dir(fvT); % Carrega todos os nomes de arquivos
        Files = sort(string({mf.name}'));
        clear mf;
        
        tV = [NaN;tempo];
        
        vxFFT = zeros(length(Files),fs);
        vyFFT = zeros(length(Files),fs);
        vzFFT = zeros(length(Files),fs);
        ppm = ParforProgressbar(length(Files));
        
        parfor k = 1:length(Files)
            ppm.increment();

            filename = strcat(fvFolder,'\',Files(k));
            data = table2array(readtable(filename));

            vxFFT(k,:) = fft(data(:,1))   
            vyFFT(k,:) = fft(data(:,2))   
            vzFFT(k,:) = fft(data(:,3)) 
        end
        
        vxFFT = vxFFT(tV<=tEnd,:);
        vyFFT = vyFFT(tV<=tEnd,:);
        vzFFT = vzFFT(tV<=tEnd,:);
        tV = tV(tV<=tEnd);
        
        vInfFFT.data = vxFFT; clear vxFFT
        vInfFFT.t = tV;
        vInfFFT.f = fs/2*linspace(-1,1,fs);
        save(strcat(fpathVar,'\vibracao_CalotaInf_FFT.mat'),'vInfFFT','-v7.3');
        
        clear vInfFFT
        
        vBanFFT.data = vyFFT; clear vyFFT
        vBanFFT.t = tV;
        vBanFFT.f = fs/2*linspace(-1,1,fs);
        save(strcat(fpathVar,'\vibracao_Bancada_FFT.mat'),'vBanFFT','-v7.3');

        clear vBanFFT
        
        vSupFFT.data = vzFFT; clear vzFFT
        vSupFFT.t = tV;
        vSupFFT.f = fs/2*linspace(-1,1,fs);
        save(strcat(fpathVar,'\vibracao_CalotaSup_FFT.mat'),'vSupFFT','-v7.3');
        
        clear vSupFFT
        
        delete(ppm);
        clear data;
    end
    
end