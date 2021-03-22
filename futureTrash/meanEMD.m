clear all;

fpathCell = {% '\Amostra A1\N_2019_07_01';
%              '\Amostra A2\A_2019_08_08';
%              '\Amostra A2\A_2019_08_12';
%              '\Amostra A2\A_2019_08_28';
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
%              '\Amostra B2\A_2020_09_02';
%              '\Amostra B2\A_2020_09_09';
%              '\Amostra B3\A_2020_09_22';
%              '\Amostra B3\A_2020_09_24';
             '\Amostra B3\N_2020_09_11';
             '\Amostra B4\A_2020_10_02';
             '\Amostra B4\A_2020_10_06';
             '\Amostra B4\A_2020_10_08';
             '\Amostra B4\N_2020_09_30';
             '\Amostra B5\N_2020_10_16';
             '\Amostra B5\A_2020_10_22';
             '\Amostra B5\A_2020_10_26';
             '\Amostra B5\A_2020_10_27';
             };

% Root de arquivos preparados (para carregar arquivos brutos de vibração)
fpathRawInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Preparados'; 

% Root de arquivos processados (para carregar tempo dos ensaios)
fpathVarInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Processados'; 

% Root de arquivos processados (para carregar tempo dos ensaios)
fpathFigInit = 'D:\Documentos\Amaciamento\Ensaios\Imagens';

E = 16; % Divisões para média
m = 25.6e3; % Número de amostras por arquivo
kk = m/E; % Passo para cada média

for kf = 1:length(fpathCell)
    fpathFinal = fpathCell{kf};
    
    fvFolder = '\vibracao';
    fvT = '\vibTempo*.dat';
    
    fpathRaw = strcat(fpathRawInit,fpathFinal);
    
    fvFolder = strcat(fpathRaw,fvFolder);
    load(strcat(fpathVarInit,fpathFinal,'\corrente_RMS.mat'));
    time = cRMS.t; clear cRMS;
    fvT = strcat(fvFolder,fvT);
    
    mf = dir(fvT); % Carrega todos os nomes de arquivos
    Files = sort(string({mf.name}'));
    clear mf;
    
    Files = Files(time>0);
    
    Insf1 = []; Inse1 = [];
    Insf2 = []; Inse2 = [];
    Insf3 = []; Inse3 = [];
    Insf4 = []; Inse4 = [];
    
    for k = 1:length(Files) % Para todos os ensaios
            disp(strcat('Progresso: ',num2str(k*100/length(Files)),'%'))

            filename = strcat(fvFolder,'\',Files(k));

            data = importdata(filename); % Importa arquivo
            newData = data(:,1); % 1 para calota inferior, 2 para bancada, 3 para calota superior
            
            if k > 1
                
                
                for ke = 1:E
                    temp = [oldData(((ke-1)*kk+1):end);newData(1:(end-((E-ke+1)*kk)))];
                    [imd,res] = emd(temp,'MaxNumIMF',4);
                    [~, ~, ~, dInsf1(:,ke), dInse1(:,ke)] = hht(imd(:,1),25.6e3);
                    [~, ~, ~, dInsf2(:,ke), dInse2(:,ke)] = hht(imd(:,2),25.6e3);
                    [~, ~, ~, dInsf3(:,ke), dInse3(:,ke)] = hht(imd(:,3),25.6e3);
                    [~, ~, ~, dInsf4(:,ke), dInse4(:,ke)] = hht(imd(:,4),25.6e3);
                end
                
                Insf1 = [Insf1;mean(dInsf1,2)];
                Inse1 = [Inse1;mean(dInse1,2)];
                
                Insf2 = [Insf2;mean(dInsf2,2)];
                Inse2 = [Inse2;mean(dInse2,2)];
                
                Insf3 = [Insf3;mean(dInsf3,2)];
                Inse3 = [Inse3;mean(dInse3,2)];
                
                Insf4 = [Insf4;mean(dInsf4,2)];
                Inse4 = [Inse4;mean(dInse4,2)];
            end
            oldData = newData;
    end
    
    T = (((1:length(Insf1))*60/25.6e3)+1)/60;
    % figure;
    % signalwavelet.internal.guis.plot.hhtPlot(Insf1, Inse1, T', [0;25.6e3/2], -Inf, 'yaxis', 0);

    save(strcat(fpathVarInit,fpathFinal,'\vibHilbert10.mat'),'Insf1','Insf2','Insf3','Insf4','Inse1','Inse2','Inse3','Inse4','T','-v7.3');
    
end