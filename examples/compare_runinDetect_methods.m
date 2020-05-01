%% Run-in instant detection - Comparison between methods

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
fpr = [rt 'Dados Processados\']; % General rocessed data folder (see documentation for data format)

% Create new folder for generated figures
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\methods_graphCompare_' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d')];
mkdir(fsave);

lr_param = [15,62,0.01,0]; % Linear regression parameters: w,r,s,f
doubleAvg_param = [30,1,32,7e-4,0]; % Double average parameters: w1,w2,r,s,f
Rstats_param = [0.1,0.2,0.2,0.05,62,3]; % R-statistics (significance) parameters: lambda1,lambda2,lambda3,alpha,r,f
RstatsRc_param = [0.32,0.1,0.47,1.65,56,0]; % R-statistics (Rc) parameters: lambda1,lambda2,lambda3,Rc,r,f

sampleStart = 1; % Starting sample

fsm{1} = {'Amostra 1\N_2019-07-01\'};

tEst{1} = 7;

fsm{2} = {'Amostra 2\N_2019-07-09\';
          'Amostra 2\A_2019-08-08\';
          'Amostra 2\A_2019-08-12\';
          'Amostra 2\A_2019-08-28\'};

tEst{2} = [7;
           2;
           2;
           2];
      
       
fsm{3} = {'Amostra 3\N_2019-12-04\';
          'Amostra 3\A_2019-12-09\';
          'Amostra 3\A_2019-12-11\'};

tEst{3} = [12;
           2;
           2];
       
      
fsm{4} = {'Amostra 4\N_2019-12-16\';
          'Amostra 4\A_2019-12-19\';
          'Amostra 4\A_2020-01-06\';
          'Amostra 4\A_2020-01-13\'};
      
tEst{4} = [7;
           2;
           2;
           2];

fsm{5} = {'Amostra 5\N_2020-01-22\';
          'Amostra 5\A_2020-01-27\';
          'Amostra 5\A_2020-01-28\'};

tEst{5} = [13;
           2;
           2];      
      
path = cell(length(fsm),1);

for k1 = 1:length(fsm)
    path{k1} = strcat(fpr,fsm{k1});
end


%% Graphs

fName = 'corrente_RMS.mat';

for k1 = sampleStart:length(path)
    figure;
    ha = tightPlots(length(path{k1}), 1, 1100, [447 70], 85, [55 25], [65 30],'pixels');
    
    for k2 = 1:length(path{k1})
        axes(ha(k2));
        load([path{k1}{k2} fName]);
        dataF = cRMS.data(cRMS.t>0); t = cRMS.t(cRMS.t>0);
        [~,taLr] = runin_detect_lr(dataF,t,lr_param(1),lr_param(2),lr_param(3),lr_param(4));
        [~,taDavg] = runin_detect_doubleavg(dataF,t,doubleAvg_param(1),doubleAvg_param(2),doubleAvg_param(3),doubleAvg_param(4),doubleAvg_param(5));
        [~,taRs] = runin_detect_Rstats(dataF,t,Rstats_param(1),Rstats_param(2),Rstats_param(3),Rstats_param(4),Rstats_param(5),Rstats_param(6));
        [~,taRsH] = runin_detect_Rstats_hRc(dataF,t,RstatsRc_param(1),RstatsRc_param(2),RstatsRc_param(3),RstatsRc_param(4),RstatsRc_param(5),RstatsRc_param(6));
        dataF = cRMS.data(cRMS.t>0);
        hold on; plot(t,dataF,'LineWidth',1,'color','k'); yl = ylim();
        c = lines(4);
        line([tEst{k1}(k2),tEst{k1}(k2)],[0 10],'LineWidth',1,'color','k','LineStyle',':');
        line([taLr,taLr],[0 10],'LineWidth',1.5,'LineStyle','--','color',c(1,:));
        line([taRs,taRs],[0 10],'LineWidth',1.5,'LineStyle','--','color',c(2,:));
        line([taRsH,taRsH],[0 10],'LineWidth',1.5,'LineStyle','--','color',c(3,:));
        line([taDavg,taDavg],[0 10],'LineWidth',1.5,'LineStyle','--','color',c(4,:));hold off;
        ylim(yl);
        
        legend({'Corrente RMS','Instante sugerido','Detec��o - Regress�o Linear','Detec��o - R-statistics (\alpha)','Detec��o - R-statistics (Rc)','Detec��o - M�dia dupla'},'location','eastoutside');
        xlabel('Tempo [h]'); ylabel('Corrente [A]');
        set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
        yticklabels('auto'); xticklabels('auto')
        xticks(0:2:20); xlim([0 20]);
        ylim([1 1.15])
        if k2 == 1
            title('N�o Amaciado');
        else
            title(['Amaciado ' num2str(k2-1)]);
        end
        hold off;
    end
    savefig([fsave 'am' num2str(k1) 'Amac.fig']);
    export_fig([fsave 'am' num2str(k1) 'Amac'],'-png','-transparent');
%    close
    clear dataF cRMS
end