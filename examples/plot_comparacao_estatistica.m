fPathCell = {{'\Amostra A1\N_2019_07_01'};
             {'\Amostra A2\A_2019_08_08';
             '\Amostra A2\A_2019_08_12';
             '\Amostra A2\A_2019_08_28';
             '\Amostra A2\N_2019_07_09';}
             {'\Amostra A3\A_2019_12_09';
             '\Amostra A3\A_2019_12_11';
             '\Amostra A3\N_2019_12_04';}
             {'\Amostra A4\A_2019_12_19';
             '\Amostra A4\A_2020_01_06';
             '\Amostra A4\A_2020_01_13';
             '\Amostra A4\N_2019_12_16';}
             {'\Amostra A5\A_2020_01_27';
             '\Amostra A5\A_2020_01_28';
             '\Amostra A5\N_2020_01_22';}
             {'\Amostra B2\A_2020_09_02';
             '\Amostra B2\A_2020_09_09'};
             {'\Amostra B3\A_2020_09_22';
             '\Amostra B3\A_2020_09_24';
             '\Amostra B3\N_2020_09_11';};
             {'\Amostra B4\A_2020_10_02';
             '\Amostra B4\A_2020_10_06';
             '\Amostra B4\A_2020_10_08';
             '\Amostra B4\N_2020_09_30';};
             {'\Amostra B5\A_2020_10_22';
              '\Amostra B5\A_2020_10_26';
              '\Amostra B5\A_2020_10_27';
              '\Amostra B5\N_2020_10_16';};
             };

fpathVarInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Processados';
fpath = 'D:\Documentos\Amaciamento\Ensaios\Imagens';
w = 20;

for k1 = 1:length(fPathCell)
    tEnd = Inf;
    s = fPathCell{k1}{1}(1:11);
    pathIm = [fpath,s,'\Comparação']; mkdir(pathIm);
    leg = [];
    
    % Corrente Crista
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\corrente_Crest']);
        cCrest = data_movmean(cCrest,w);
        plot(cCrest.t, cCrest.data); hold on;
        leg = [leg, {fPathCell{k1}{k2}(2:end)}];
        tEnd = min([tEnd, cCrest.t(end)]);
        EnDataAlt{k1}{k2}.cCrest = cCrest.data;
        EnDataAlt{k1}{k2}.tempo = cCrest.t;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Fator de crista [adim]');
    savefig([pathIm,'\corrente_Crest']);
    export_fig([pathIm,'\corrente_Crest'],'-pdf','-transparent');
    export_fig([pathIm,'\corrente_Crest'],'-m5','-png','-transparent');
    close all;
    
    % Corrente Peak
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\corrente_Peak']);
        cPeak = data_movmean(cPeak,w);
        plot(cPeak.t, cPeak.data); hold on;
        EnDataAlt{k1}{k2}.cPeak = cPeak.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Pico [A]');
    savefig([pathIm,'\corrente_Peak']);
    export_fig([pathIm,'\corrente_Peak'],'-pdf','-transparent');
    export_fig([pathIm,'\corrente_Peak'],'-m5','-png','-transparent');
    close all;
    
    % Corrente Fator de forma
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\corrente_Shape']);
        cShape = data_movmean(cShape,w);
        plot(cShape.t, cShape.data); hold on;
        EnDataAlt{k1}{k2}.cShape = cShape.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Fator de forma [adim]');
    savefig([pathIm,'\corrente_Shape']);
    export_fig([pathIm,'\corrente_Shape'],'-pdf','-transparent');
    export_fig([pathIm,'\corrente_Shape'],'-m5','-png','-transparent');
    close all;
    
    % Corrente Assimetria
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\corrente_Skewness']);
        cSke = data_movmean(cSke,w);
        plot(cSke.t, cSke.data); hold on;
        EnDataAlt{k1}{k2}.cSke = cSke.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Assimetria [adim]');
    savefig([pathIm,'\corrente_Skewness']);
    export_fig([pathIm,'\corrente_Skewness'],'-pdf','-transparent');
    export_fig([pathIm,'\corrente_Skewness'],'-m5','-png','-transparent');
    close all;
    
    % Corrente Desvio padrão
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\corrente_Std']);
        cStd = data_movmean(cStd,w);
        plot(cStd.t, cStd.data); hold on;
        EnDataAlt{k1}{k2}.cStd = cStd.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Desvio padrão [A]');
    savefig([pathIm,'\corrente_Std']);
    export_fig([pathIm,'\corrente_Std'],'-pdf','-transparent');
    export_fig([pathIm,'\corrente_Std'],'-m5','-png','-transparent');
    close all;
    
    % Corrente THD
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\corrente_THD']);
        cTHD = data_movmean(cTHD,w);
        plot(cTHD.t, cTHD.data); hold on;
        EnDataAlt{k1}{k2}.cTHD = cTHD.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('THD [adim]');
    savefig([pathIm,'\corrente_THD']);
    export_fig([pathIm,'\corrente_THD'],'-pdf','-transparent');
    export_fig([pathIm,'\corrente_THD'],'-m5','-png','-transparent');
    close all;
    
    % Corrente Variância
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\corrente_Var']);
        cVar = data_movmean(cVar,w);
        plot(cVar.t, cVar.data); hold on;
        EnDataAlt{k1}{k2}.cVar = cVar.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Variância [A²]');
    savefig([pathIm,'\corrente_Var']);
    export_fig([pathIm,'\corrente_Var'],'-pdf','-transparent');
    export_fig([pathIm,'\corrente_Var'],'-m5','-png','-transparent');
    close all;
    
    % Corrente RMS
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\corrente_RMS']);
        cRMS = data_movmean(cRMS,w);
        plot(cRMS.t, cRMS.data); hold on;
        EnDataAlt{k1}{k2}.cRMS = cRMS.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('RMS [A]');
    savefig([pathIm,'\corrente_RMS']);
    export_fig([pathIm,'\corrente_RMS'],'-pdf','-transparent');
    export_fig([pathIm,'\corrente_RMS'],'-m5','-png','-transparent');
    close all;
    
    % Corrente Curtose
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\corrente_Curtose']);
        cKur = data_movmean(cKur,w);
        plot(cKur.t, cKur.data); hold on;
        EnDataAlt{k1}{k2}.cKur = cKur.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Curtose [adim]');
    savefig([pathIm,'\corrente_Curtose']);
    export_fig([pathIm,'\corrente_Curtose'],'-pdf','-transparent');
    export_fig([pathIm,'\corrente_Curtose'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Inf Crista
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaInf_Crest']);
        vInfCrest = data_movmean(vInfCrest,w);
        plot(vInfCrest.t, vInfCrest.data); hold on;
        EnDataAlt{k1}{k2}.vInfCrest = vInfCrest.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Fator de crista [adim]');
    savefig([pathIm,'\vibracao_CalotaInf_Crest']);
    export_fig([pathIm,'\vibracao_CalotaInf_Crest'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaInf_Crest'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Inf Peak
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaInf_Peak']);
        vInfPeak = data_movmean(vInfPeak,w);
        plot(vInfPeak.t, vInfPeak.data); hold on;
        EnDataAlt{k1}{k2}.vInfPeak = vInfPeak.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Pico [g]');
    savefig([pathIm,'\vibracao_CalotaInf_Peak']);
    export_fig([pathIm,'\vibracao_CalotaInf_Peak'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaInf_Peak'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Inf Fator de forma
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaInf_Shape']);
        vInfShape = data_movmean(vInfShape,w);
        plot(vInfShape.t, vInfShape.data); hold on;
        EnDataAlt{k1}{k2}.vInfPeak = vInfPeak.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Fator de forma [adim]');
    savefig([pathIm,'\vibracao_CalotaInf_Shape']);
    export_fig([pathIm,'\vibracao_CalotaInf_Shape'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaInf_Shape'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Inf Assimetria
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaInf_Ske']);
        vInfSke = data_movmean(vInfSke,w);
        plot(vInfSke.t, vInfSke.data); hold on;
        EnDataAlt{k1}{k2}.vInfSke = vInfSke.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Assimetria [adim]');
    savefig([pathIm,'\vibracao_CalotaInf_Skewness']);
    export_fig([pathIm,'\vibracao_CalotaInf_Skewness'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaInf_Skewness'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Inf Desvio padrão
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaInf_Std']);
        vInfStd = data_movmean(vInfStd,w);
        plot(vInfStd.t, vInfStd.data); hold on;
        EnDataAlt{k1}{k2}.vInfStd = vInfStd.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Desvio padrão [g]');
    savefig([pathIm,'\vibracao_CalotaInf_Std']);
    export_fig([pathIm,'\vibracao_CalotaInf_Std'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaInf_Std'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Inf THD
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaInf_THD']);
        vInfTHD = data_movmean(vInfTHD,w);
        plot(vInfTHD.t, vInfTHD.data); hold on;
        EnDataAlt{k1}{k2}.vInfTHD = vInfTHD.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('THD [adim]');
    savefig([pathIm,'\vibracao_CalotaInf_THD']);
    export_fig([pathIm,'\vibracao_CalotaInf_THD'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaInf_THD'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Inf Variância
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaInf_Var']);
        vInfVar = data_movmean(vInfVar,w);
        plot(vInfVar.t, vInfVar.data); hold on;
        EnDataAlt{k1}{k2}.vInfVar = vInfVar.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Variância [g²]');
    savefig([pathIm,'\vibracao_CalotaInf_Var']);
    export_fig([pathIm,'\vibracao_CalotaInf_Var'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaInf_Var'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Inf RMS
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaInf_RMS']);
        vInfRMS = data_movmean(vInfRMS,w);
        plot(vInfRMS.t, vInfRMS.data); hold on;
        EnDataAlt{k1}{k2}.vInfRMS = vInfRMS.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('RMS [g]');
    savefig([pathIm,'\vibracao_CalotaInf_RMS']);
    export_fig([pathIm,'\vibracao_CalotaInf_RMS'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaInf_RMS'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Inf Curtose
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaInf_Curtose']);
        vInfKur = data_movmean(vInfKur,w);
        plot(vInfKur.t, vInfKur.data); hold on;
        EnDataAlt{k1}{k2}.vInfKur = vInfKur.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Curtose [adim]');
    savefig([pathIm,'\vibracao_CalotaInf_Curtose']);
    export_fig([pathIm,'\vibracao_CalotaInf_Curtose'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaInf_Curtose'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Sup Crista
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaSup_Crest']);
        vSupCrest = data_movmean(vSupCrest,w);
        plot(vSupCrest.t, vSupCrest.data); hold on;
        EnDataAlt{k1}{k2}.vSupCrest = vSupCrest.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Fator de crista [adim]');
    savefig([pathIm,'\vibracao_CalotaSup_Crest']);
    export_fig([pathIm,'\vibracao_CalotaSup_Crest'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaSup_Crest'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Sup Peak
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaSup_Peak']);
        vSupPeak = data_movmean(vSupPeak,w);
        plot(vSupPeak.t, vSupPeak.data); hold on;
        EnDataAlt{k1}{k2}.vSupPeak = vSupPeak.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Pico [g]');
    savefig([pathIm,'\vibracao_CalotaSup_Peak']);
    export_fig([pathIm,'\vibracao_CalotaSup_Peak'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaSup_Peak'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Sup Fator de forma
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaSup_Shape']);
        vSupShape = data_movmean(vSupShape,w);
        plot(vSupShape.t, vSupShape.data); hold on;
        EnDataAlt{k1}{k2}.vSupShape = vSupShape.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Fator de forma [adim]');
    savefig([pathIm,'\vibracao_CalotaSup_Shape']);
    export_fig([pathIm,'\vibracao_CalotaSup_Shape'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaSup_Shape'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Sup Assimetria
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaSup_Ske']);
        vSupSke = data_movmean(vSupSke,w);
        plot(vSupSke.t, vSupSke.data); hold on;
        EnDataAlt{k1}{k2}.vSupSke = vSupSke.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Assimetria [adim]');
    savefig([pathIm,'\vibracao_CalotaSup_Skewness']);
    export_fig([pathIm,'\vibracao_CalotaSup_Skewness'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaSup_Skewness'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Sup Desvio padrão
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaSup_Std']);
        vSupStd = data_movmean(vSupStd,w);
        plot(vSupStd.t, vSupStd.data); hold on;
        EnDataAlt{k1}{k2}.vSupStd = vSupStd.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Desvio padrão [g]');
    savefig([pathIm,'\vibracao_CalotaSup_Std']);
    export_fig([pathIm,'\vibracao_CalotaSup_Std'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaSup_Std'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Sup THD
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaSup_THD']);
        vSupTHD = data_movmean(vSupTHD,w);
        plot(vSupTHD.t, vSupTHD.data); hold on;
        EnDataAlt{k1}{k2}.vSupTHD = vSupTHD.data;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('THD [adim]');
    savefig([pathIm,'\vibracao_CalotaSup_THD']);
    export_fig([pathIm,'\vibracao_CalotaSup_THD'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaSup_THD'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Sup Variância
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaSup_Var']);
        vSupVar = data_movmean(vSupVar,w);
        plot(vSupVar.t, vSupVar.data); hold on;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Variância [g²]');
    savefig([pathIm,'\vibracao_CalotaSup_Var']);
    export_fig([pathIm,'\vibracao_CalotaSup_Var'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaSup_Var'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Sup RMS
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaSup_RMS']);
        vSupRMS = data_movmean(vSupRMS,w);
        plot(vSupRMS.t, vSupRMS.data); hold on;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('RMS [g]');
    savefig([pathIm,'\vibracao_CalotaSup_RMS']);
    export_fig([pathIm,'\vibracao_CalotaSup_RMS'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaSup_RMS'],'-m5','-png','-transparent');
    close all;
    
    % Vibracao Sup Curtose
    fig = figure;
    fig.Position = [fig.Position(1:2)-[0,500],900,326.4];
    
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        
        load([fP,'\vibracao_CalotaSup_Curtose']);
        vSupKur = data_movmean(vSupKur,w);
        plot(vSupKur.t, vSupKur.data); hold on;
    end
    xlim([0 max([25,tEnd])]); xlabel('Tempo [h]');
    legend(leg,'location','best')
    ylabel('Curtose [adim]');
    savefig([pathIm,'\vibracao_CalotaSup_Curtose']);
    export_fig([pathIm,'\vibracao_CalotaSup_Curtose'],'-pdf','-transparent');
    export_fig([pathIm,'\vibracao_CalotaSup_Curtose'],'-m5','-png','-transparent');
    close all;
    
end