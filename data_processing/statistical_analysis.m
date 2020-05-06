%% Parameter analysis for run-in detection using R-statistics and unknown Rc

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
fpr = [rt 'Dados Processados\']; % General rocessed data folder (see documentation for data format)

% Create new folder for generated files
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\statisticalValues' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;

% fsm: Test data folder 
% tEst: Manually inputed estimated run-in time

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

       
path = cell(length(fsm),1); % Cell array for the data file path
avg = cell(length(fsm),1); % Cell array for the run-in instant
stdDev = cell(length(fsm),1);
dat = [];
g = [];
N = [];

for k1 = 1:length(fsm)
    path{k1} = strcat(fpr,fsm{k1},'corrente_RMS.mat');
    avg{k1} = NaN(length(fsm{k1}),1);
    stdDev{k1} = NaN(length(fsm{k1}),1);
end

%% Sample processing

for k1 = 1:length(path) % For every sample
    for k2 = 1:length(path{k1}) % For every test of the sample
        load(path{k1}{k2}); % Loads the RMS current data
        dataF = cRMS.data(cRMS.t>(tEst{k1}(k2)+2) & cRMS.t<(max(cRMS.t)-0.5));
        stdDev{k1}(k2) = std(dataF);
        avg{k1}(k2) = mean(dataF);        
        dat = [dat;dataF];
        if k2 == 1
            name = {[num2str(k1) 'N']};
        else
            name = {[num2str(k1) 'A' num2str(k2-1)]};
        end
        g = [g;repmat(name,length(dataF),1)];
        N = [N,name];
    end
end

save([fsave,'mean.mat'],'avg','-v7.3');
save([fsave,'stdDev.mat'],'stdDev','-v7.3');

%% Plot
figure;
boxplot(dat,g);
yl = ylim();
ylabel('Corrente [A]'); xlabel('Ensaio');
grid on

savefig([fsave 'boxplot.fig']);
export_fig([fsave 'boxplot.fig'],'-pdf','-transparent');
    
figure;
data = vertcat(avg{:});
x = 1:length(data);
errhigh = (vertcat(stdDev{:}))';
errlow  = (vertcat(stdDev{:}))';
scatter(x,data)                
hold on
er = errorbar(x,data,errlow,errhigh);    
hold off
ylim(yl);
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
xticks(x); xticklabels(N);
ylabel('Corrente [A]'); xlabel('Ensaio');
grid on;
xlim([x(1)-0.5 x(end)+0.5]);
savefig([fsave 'meanStd.fig']);
export_fig([fsave 'meanStd.fig'],'-pdf','-transparent');
