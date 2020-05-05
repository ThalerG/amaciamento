%% Graficos apresentação

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
fpr = [rt 'Dados Processados\']; % General rocessed data folder (see documentation for data format)

% Create new folder for generated figures
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\linRegression_graphTest_' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;

% fsm: Test data folder 
% tEst: Manually inputed estimated run-in time

w1 = 30;
w2 = 1;
r = 32;
s = 7e-4;
f = 0;

amStart = 1;

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


%% Corrente

fName = 'corrente_RMS.mat';


for k1 = amStart:length(path)
    figure;
    ha = tightPlots(length(path{k1}), 1, 1100, [447 70], 85, [55 25], [65 30],'pixels');
    
    for k2 = 1:length(path{k1})
        axes(ha(k2));
        load([path{k1}{k2} fName]);
        dataF = cRMS.data(cRMS.t>0); t = cRMS.t(cRMS.t>0);
        [n,ta] = runin_detect_doubleavg(dataF,t,w1,w2,r,s,f);
        dataF = cRMS.data(cRMS.t>0);
        hold on; plot(t,dataF,'LineWidth',1); yl = ylim();
        line([tEst{k1}(k2),tEst{k1}(k2)],[0 10],'LineWidth',1,'color','k','LineStyle',':');
        line([ta,ta],[0 10],'LineWidth',1,'color','k','LineStyle','--'); hold off;
        ylim(yl);
        
        legend({'Corrente RMS','Instante sugerido','Instante detectado'},'location','best');
        xlabel('Tempo [h]'); ylabel('Corrente [A]');
        set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
        yticklabels('auto'); xticklabels('auto')
        xticks(0:2:20); xlim([0 20]);
        ylim([1 1.15])
        if k2 == 1
            title('Não Amaciado');
        else
            title(['Amaciado ' num2str(k2-1)]);
        end
        hold off;
    end
    savefig([fsave 'am' num2str(k1) 'Amac.fig']);
%    export_fig([fsave 'am' num2str(k1) 'Amac'],'-png','-transparent');
    close
    clear dataF cRMS
end