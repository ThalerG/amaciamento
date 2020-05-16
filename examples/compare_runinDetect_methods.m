%% Run-in instant detection - Comparison between methods

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
fpr = [rt 'Dados Processados\']; % General rocessed data folder (see documentation for data format)

% Create new folder for generated figures
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\methods_graphCompare_' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave);

n_methods = 5; % Number of tested methods
n_adjust = 2; % Number of different adjustments

lr_param = NaN(n_adjust,4); % Linear regression parameters: w,r,s,f
doubleAvg_param = NaN(n_adjust,5); % Double average parameters: w1,w2,r,s,f
Rstats_param = NaN(n_adjust,6);  % R-statistics (significance) parameters: lambda1,lambda2,lambda3,alpha,r,f
RstatsRc_param = NaN(n_adjust,6); % R-statistics (Rc) parameters: lambda1,lambda2,lambda3,Rc,r,f
spacedDif_param = NaN(n_adjust,5); % Spaced difference parameters: w, n, r, s, f

for k0 = 1:n_adjust
    switch k0
        case 1 % Minimizes sum(e²) of all samples
            lr_param(k0,:) = [15,62,0.01,0]; 
            doubleAvg_param(k0,:) = [30,1,32,7e-4,0]; 
            Rstats_param(k0,:) = [0.05,0.2,0.2,0.01,62,0];
            RstatsRc_param(k0,:) = [0.32,0.35,0.28,0.9,7,0]; 
            spacedDif_param(k0,:) = [25, 30, 31, 7e-4, 0]; 
            
        case 2 % Minimizes sum(e²) only of not run-in samples
            lr_param(k0,:) = [60,87,0.05,0]; 
            doubleAvg_param(k0,:) = [20,1,10,3e-4,0];
            Rstats_param(k0,:) = [0.2,0.5,0.5,0.5,7,0];
            RstatsRc_param(k0,:) = [0.02,0.5,0.26,1.45,18,0];
            spacedDif_param(k0,:) = [35, 5, 9, 1e-4, 0];
            
    end
end

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
      
tEst{4} = [8;
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
Err = cell(n_methods,n_adjust,length(fsm));


for k1 = 1:length(fsm)
    for k0 = 1:n_adjust
        for k = 1:n_methods
            Err{k,k0,k1} = NaN(length(fsm{k1}),1);
        end
    end
    path{k1} = strcat(fpr,fsm{k1});
end



%% Graphs

fName = 'corrente_RMS.mat';

for k0 = 1:n_adjust
    for k1 = sampleStart:length(path)
        figure;
        ha = tightPlots(length(path{k1}), 1, 1100, [447 70], 85, [55 25], [65 30],'pixels');

        for k2 = 1:length(path{k1})
            axes(ha(k2));
            load([path{k1}{k2} fName]);
            dataF = cRMS.data(cRMS.t>0); t = cRMS.t(cRMS.t>0);
            [~,taLr] = runin_detect_lr(dataF,t,lr_param(k0,1),lr_param(k0,2),lr_param(k0,3),lr_param(k0,4));
            [~,taDavg] = runin_detect_doubleavg(dataF,t,doubleAvg_param(k0,1),doubleAvg_param(k0,2),doubleAvg_param(k0,3),doubleAvg_param(k0,4),doubleAvg_param(k0,5));
            [~,taRs] = runin_detect_Rstats(dataF,t,Rstats_param(k0,1),Rstats_param(k0,2),Rstats_param(k0,3),Rstats_param(k0,4),Rstats_param(k0,5),Rstats_param(k0,6));
            [~,taRsH] = runin_detect_Rstats_hRc(dataF,t,RstatsRc_param(k0,1),RstatsRc_param(k0,2),RstatsRc_param(k0,3),RstatsRc_param(k0,4),RstatsRc_param(k0,5),RstatsRc_param(k0,6));
            [~,taSdif] = runin_detect_spacedDif(dataF,t,spacedDif_param(k0,1),spacedDif_param(k0,2),spacedDif_param(k0,3),spacedDif_param(k0,4),spacedDif_param(k0,5));
            dataF = cRMS.data(cRMS.t>0);
            
            temp = [taLr, taRs, taRsH, taDavg, taSdif] - tEst{k1}(k2);
            Err{1,k0,k1}(k2) = temp(1);
            Err{2,k0,k1}(k2) = temp(2);
            Err{3,k0,k1}(k2) = temp(3);
            Err{4,k0,k1}(k2) = temp(4);
            Err{5,k0,k1}(k2) = temp(5);
                   

            hold on; plot(t,dataF,'LineWidth',1,'color','k'); yl = ylim();
            c = lines(5);
            line([tEst{k1}(k2),tEst{k1}(k2)],[0 10],'LineWidth',1,'color','k','LineStyle',':');
            line([taLr,taLr],[0 10],'LineWidth',1.5,'LineStyle','--','color',c(1,:));
            line([taRs,taRs],[0 10],'LineWidth',1.5,'LineStyle','--','color',c(2,:));
            line([taRsH,taRsH],[0 10],'LineWidth',1.5,'LineStyle','--','color',c(3,:));
            line([taDavg,taDavg],[0 10],'LineWidth',1.5,'LineStyle','--','color',c(4,:));
            line([taSdif,taSdif],[0 10],'LineWidth',1.5,'LineStyle','--','color',c(5,:));hold off;
            ylim(yl);

            legend({'Corrente RMS','Instante sugerido','Detecção - Regressão Linear','Detecção - R-statistics (\alpha)','Detecção - R-statistics (Rc)','Detecção - Média dupla', 'Detecção - Diferença espaçada'},'location','eastoutside');
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
        savefig([fsave 'am' num2str(k1) 'Amac_A' num2str(k0) '.fig']);
        export_fig([fsave 'am' num2str(k1) 'Amac_A' num2str(k0)],'-pdf','-transparent');
        close
        clear dataF cRMS
    end
end

%% Error mean/std

ErrT = cell(n_methods,n_adjust);
ErrA = cell(n_methods,n_adjust);
ErrN = cell(n_methods,n_adjust);

SumErrT = NaN(n_methods,n_adjust);
SumErrN = NaN(n_methods,n_adjust);
SumErrA = NaN(n_methods,n_adjust);

AvgErrT = NaN(n_methods,n_adjust);
AvgErrN = NaN(n_methods,n_adjust);
AvgErrA = NaN(n_methods,n_adjust);

StdErrT = NaN(n_methods,n_adjust);
StdErrN = NaN(n_methods,n_adjust);
StdErrA = NaN(n_methods,n_adjust);

for k0 = 1:n_adjust
    for k = 1:n_methods
        ErrT{k,k0} = vertcat(Err{k,k0,:});
        for k1 = 1:length(fsm)
            ErrN{k,k0} = [ErrN{k,k0};Err{k,k0,k1}(1)];
            if length(fsm{k1})>1
                ErrA{k,k0} = [ErrA{k,k0}; vertcat(Err{k,k0,k1}(2:end))];
            end
        end
        SumErrT(k,k0) = sum(abs(ErrT{k,k0}));
        SumErrN(k,k0) = sum(abs(ErrN{k,k0}));
        SumErrA(k,k0) = sum(abs(ErrA{k,k0}));
        
        AvgErrT(k,k0) = mean(ErrT{k,k0});
        AvgErrN(k,k0) = mean(ErrN{k,k0});
        AvgErrA(k,k0) = mean(ErrA{k,k0});
        
        StdErrT(k,k0) = std(ErrT{k,k0});
        StdErrN(k,k0) = std(ErrN{k,k0});
        StdErrA(k,k0) = std(ErrA{k,k0});
    end
end

% All tests
xi = 0.5:1/(n_adjust+1):1.5; x = reshape(xi(2:end-1)'+(0:(n_methods-1)),[],1);
y = reshape(AvgErrT',1,[]); e = reshape(StdErrT',1,[]);
fig = figure;
fig.Position = 1e3*[0.4110    0.3786    1.1000    2*0.225108910891089];
for k = 1:n_adjust
    n = k:n_adjust:length(x);
    errorbar(x(n),y(n),e(n),'o','LineWidth',1.5);
    hold on
end
xticks(1:n_methods);
xticklabels({'M1','M2.1','M2.2','M3','M4'})
legend({'A1','A2'},'location','best'); xlim([0.5 n_methods+0.5]);
set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
ylabel('Corrente [A]');  expandaxes(fig); grid on;
savefig([fsave 'AvgErrT.fig']);
export_fig([fsave 'AvgErrT'],'-pdf','-transparent');
close

% Run-in tests
xi = 0.5:1/(n_adjust+1):1.5; x = reshape(xi(2:end-1)'+(0:(n_methods-1)),[],1);
y = reshape(AvgErrN',1,[]); e = reshape(StdErrN',1,[]);
fig = figure;
fig.Position = 1e3*[0.4110    0.3786    1.1000    2*0.225108910891089];
for k = 1:n_adjust
    n = k:n_adjust:length(x);
    errorbar(x(n),y(n),e(n),'o','LineWidth',1.5);
    hold on
end
xticks(1:n_methods);
xticklabels({'M1','M2.1','M2.2','M3','M4'})
legend({'A1','A2'},'location','best'); xlim([0.5 n_methods+0.5]);
set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
ylabel('Corrente [A]');  expandaxes(fig); grid on;
savefig([fsave 'AvgErrN.fig']);
export_fig([fsave 'AvgErrN'],'-pdf','-transparent');
close

% Already run-in tests
xi = 0.5:1/(n_adjust+1):1.5; x = reshape(xi(2:end-1)'+(0:(n_methods-1)),[],1);
y = reshape(AvgErrA',1,[]); e = reshape(StdErrA',1,[]);
fig = figure;
fig.Position = 1e3*[0.4110    0.3786    1.1000    2*0.225108910891089];
for k = 1:n_adjust
    n = k:n_adjust:length(x);
    errorbar(x(n),y(n),e(n),'o','LineWidth',1.5);
    hold on
end
xticks(1:n_methods);
xticklabels({'M1','M2.1','M2.2','M3','M4'})
legend({'A1','A2'},'location','best'); xlim([0.5 n_methods+0.5]);
set(gca,'FontSize',14); set(gca,'FontName','Times New Roman');
ylabel('Corrente [A]');  expandaxes(fig); grid on;
savefig([fsave 'AvgErrA.fig']);
export_fig([fsave 'AvgErrA'],'-pdf','-transparent');
close
