close all;

rt = 'D:\Documentos\Amaciamento\Ensaios\'; % Root folder
fpr = [rt 'Dados Processados\']; % General rocessed data folder (see documentation for data format)

fsm{1} = {'Amostra A1\N_2019_07_01'};

fsm{2} = {'Amostra A2\N_2019_07_09';
          'Amostra A2\A_2019_08_08';
          'Amostra A2\A_2019_08_12';
          'Amostra A2\A_2019_08_28';
%          'Amostra A2\A_2019_10_02';
%           'Amostra A2\A_2019_10_14';
          };
         
fsm{3} = {'Amostra A3\N_2019_12_04';
          'Amostra A3\A_2019_12_09';
          'Amostra A3\A_2019_12_11';
          };
         
fsm{4} = {'Amostra A4\N_2019_12_16';
          'Amostra A4\A_2019_12_19';
          'Amostra A4\A_2020_01_06';
          'Amostra A4\A_2020_01_13';
          };
         
fsm{5} = {'Amostra A5\N_2020_01_22';
          'Amostra A5\A_2020_01_27';
          'Amostra A5\A_2020_01_28';
          };

% fsm{6} = {% 'Amostra B2\A_2020_07_06';
% %           'Amostra B2\A_2020_07_10';
% %           'Amostra B2\A_2020_08_17';
% %           'Amostra B2\A_2020_08_28';
%           'Amostra B2\A_2020_09_02';
%           'Amostra B2\A_2020_09_08';
%           'Amostra B2\A_2020_09_09';
% %           'Amostra B2\N_2020_07_02'
%            };

tEst{1} = 4.4;

tEst{2} = [7.5;
           2.5;
           2.5;
           2.5];
       
tEst{3} = [11.8;
           2.5;
           2.5];
         
tEst{4} = [6;
           2.5;
           2.5;
           2.1];

tEst{5} = [12.5;
           2.5;
           2.5];
       
tEst{6} = [0;
           0;
           0;
           0;
           0;
           0;
           0;
           0;
           ];

EnData = cell(length(fsm),1);
EnDataAcu = cell(length(fsm),1);

for k1 = 1:length(fsm)
    fig = figure; fig.Position = [488 41.8000 864.2000 740.8000];
    leg = {};
    
    for k2 = 1:length(fsm{k1})
        load([fpr, fsm{k1}{k2}, '\pressao_Descarga.mat']);
        load([fpr, fsm{k1}{k2}, '\pressao_Succao.mat']);
        load([fpr, fsm{k1}{k2}, '\corrente_RMS.mat']);
        load([fpr, fsm{k1}{k2}, '\corrente_RMS.mat']);
        load([fpr, fsm{k1}{k2}, '\corrente_Curtose.mat']);
        load([fpr, fsm{k1}{k2}, '\vibracao_CalotaInf_RMS.mat']);
        load([fpr, fsm{k1}{k2}, '\vibracao_CalotaInf_Curtose.mat']);
        load([fpr, fsm{k1}{k2}, '\vibracao_CalotaSup_RMS.mat']);
        load([fpr, fsm{k1}{k2}, '\vibracao_CalotaSup_Curtose.mat']);
        load([fpr, fsm{k1}{k2}, '\vazao.mat']);
        load([fpr, fsm{k1}{k2}, '\acusticas_RMS.mat']);
        load([fpr, fsm{k1}{k2}, '\acusticas_Curtose.mat']);
        
        subplot(4,1,1);
        temp.pD = pD.data;
        temp.tempo = pD.t';
        plot(temp.tempo,temp.pD); hold on;
        
        subplot(4,1,2);
        temp.pS = pS.data;
        temp.tempo = pS.t';
        plot(temp.tempo,temp.pS); hold on;
        
        subplot(4,1,3);
        temp.cRMS = cRMS.data;
        temp.tempo = cRMS.t';
        plot(temp.tempo,temp.cRMS); hold on;
        
        leg = [leg fsm{k1}{k2}];

        if length(vaz.data) < length(cRMS.data)
            vaz.data(end+1:length(cRMS.data)) = vaz.data(end);
        elseif length(vaz.data) > length(cRMS.data)
            vaz.data = vaz.data(1:length(cRMS.data));
        end
        
        subplot(4,1,4);
        temp.vaz = vaz.data;
        plot(temp.tempo,temp.vaz); hold on;
        
        temp.cRMS = cRMS.data;
        temp.cKur = cKur.data;
        temp.vaz = vaz.data;
        temp.vInfRMS = vInfRMS.data;
        temp.vInfKur = vInfKur.data;
        temp.vSupRMS = vSupRMS.data;
        temp.vSupKur = vSupKur.data;
        temp.tempo = cRMS.t';
        temp.name = fsm{k1}{k2};
        EnData{k1}(k2) = temp;
        
        Names = {'Tempo [h]', 'Corrente RMS [V]', 'Corrente Curtose [adim]', 'Vibração Calota Inferior RMS [g]', 'Vibração Calota Inferior Curtose [adim]', 'Vibração Calota Superior RMS [g]', 'Vibração Calota Superior Curtose [adim]', 'Vazão'};
        T = table(temp.tempo, temp.cRMS, temp.cKur, temp.vInfRMS, temp.vInfKur, temp.vSupRMS, temp.vSupKur, temp.vaz, 'VariableNames', {'Tempo', 'CorrenteRMS', 'CorrenteCurtose', 'VibracaoCalotaInferiorRMS', 'VibracaoCalotaInferiorCurtose', 'VibracaoCalotaSuperiorRMS', 'VibracaoCalotaSuperiorCurtose', 'Vazao'});
        
        tempa.tempo = aRMS.t';
        tempa.aRMS = aRMS.data;
        tempa.aKur = aKur.data;
        EnDataAcu{k1}(k2) = tempa;
        
        NamesA = {'Tempo [h]','Emissões Acústicas RMS []','Emissões Acústicas Curtose [adim]'};
        Ta = table(tempa.tempo, tempa.aRMS, tempa.aKur,'VariableNames',{'Tempo','EmissoesAcusticasRMS','EmissoesAcusticasCurtose'});
        fName = strrep(fsm{k1}{k2},'Amostra ',''); fName = [strrep(fName,'\','_'),'tAm',num2str(tEst{k1}(k2))];
%        writetable(T,[fName,'.csv']);
%        writetable(Ta,[fName,'_acu.csv']);
    end
    
    subplot(4,1,1);
    legend(leg,'location','best')
    xlim([0.5 25]);
    title('Pressão de descarga')
    
    subplot(4,1,2);
    legend(leg,'location','best')
    xlim([0.5 25]);
    title('Pressão de sucção')
        
    subplot(4,1,3);
    xlim([0.5 25]);
    
    for k2 = 1:length(fsm{k1})
        yl = ylim();
        line([tEst{k1}(k2) tEst{k1}(k2)], [yl(1),yl(2)],'Color','black','LineStyle','--'); ylim(yl);
    end
    legend(leg,'location','best')
    title('Corrente')
    
    subplot(4,1,4);
    xlim([0.5 25]);
    
    for k2 = 1:length(fsm{k1})
        yl = ylim();
        line([tEst{k1}(k2) tEst{k1}(k2)], [yl(1),yl(2)],'Color','black','LineStyle','--'); ylim(yl);
    end
    legend(leg,'location','best')
    title('Vazão')
    
    if k1 == 6
        subplot(4,1,1);
        ylim([7.436 7.800]);
        
        subplot(4,1,2);
        ylim([0.600 0.654]);
    else
        subplot(4,1,1);
        ylim([14.342 15.061]);
        
        subplot(4,1,2);
        ylim([1.098 1.200]);
    end
    
    hold off;
    % export_fig(['Amostra',num2str(k1)],'-png','-m5','-transparent');
    
end