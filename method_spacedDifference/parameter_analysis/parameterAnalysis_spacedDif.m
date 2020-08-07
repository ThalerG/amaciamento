%% Parameter analysis for run-in detection using filtered difference

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder
fpr = [rt 'Dados Processados\']; % General rocessed data folder (see documentation for data format)

% Create new folder for generated files
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\spacedDif_parameters_' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;

% fsm: Test data folder 
% tEst: Manually inputed estimated run-in time

fsm{1} = {'Amostra 1\N_2019-07-01\'};

tEst{1} = 4;

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
      
tEst{4} = [5.5;
           2;
           2;
           2];

fsm{5} = {'Amostra 5\N_2020-01-22\';
          'Amostra 5\A_2020-01-27\';
          'Amostra 5\A_2020-01-28\'};

tEst{5} = [12.5;
           2;
           2];      

path = cell(length(fsm),1); % Cell array for the data file path
tAmac = cell(length(fsm),1); % Cell array for the run-in instant

R = 1:70; % Sample relevance
W = [1,5:5:50]; % Sample window for the data filter
N = [1,5:5:100]; % Space between differenced samples
S = 1e-4:1e-4:5e-2; % Maximum tolerated difference
F = 0:5; % Sample tolerance

for k1 = 1:length(fsm)
    path{k1} = strcat(fpr,fsm{k1},'corrente_RMS.mat');
    tAmac{k1} = cell(length(fsm{k1}),1); % For every test (A1)
%    tAmac{k1} = cell(1,1); % For every run-in test (A2)
    for k2 = 1:length(tAmac{k1})
        tAmac{k1}{k2} = zeros(length(W),length(N),length(S),length(R),length(F));
    end
end


%% Sample processing

totalIt = 0; % Number of iterations
for k1 = 1:length(tAmac)
    totalIt = totalIt+length(tAmac{k1});
end
totalIt = totalIt*length(W)*length(N);

it = 0;

for k1 = 1:length(tAmac) % For every sample
    for k2 = 1:length(tAmac{k1})
        load(path{k1}{k2}); % Loads the RMS current data
        count = zeros(length(cRMS.data(cRMS.t>0)),1); % Counts the number of samples where the null hypothesis is valid
        time = cRMS.t(cRMS.t>0);
        for w = 1:length(W) % For every window length size
            for n = 1:length(N)  % For every window length size
                it=it+1;
                prog = ['Progresso:' num2str(100*it/totalIt),'%' newline...
                        'Amostra:' num2str(k1) '/' num2str(length(path)) newline...
                        'Ensaio:' num2str(k2) '/' num2str(length(path{k1})) newline...
                        'w :' num2str(w) '/' num2str(length(W)) newline...
                        'n :' num2str(n) '/' num2str(length(N))]; display(prog); % Displays the current progress

                for s = 1:length(S)  % For every maximum tolerance
                    
                    dataF = spacedDiff(cRMS.data(cRMS.t>0),W(w),N(n));

                    flag = 0;
                    for f = 1:length(F)
                        for m = 2:length(dataF) % Counts the number of samples where the difference is smaller than the tolerated value
                            if abs(dataF(m))<S(s)
                                count(m) = count(m-1)+1;
                            else
                                if flag<F(f)
                                    flag = flag+1;
                                else
                                    flag = 0;
                                    count(m) = 0;
                                end
                            end
                        end
                        for r = 1:length(R)
                            temp = min(time(count>R(r)));
                            if isempty(temp)
                                tAmac{k1}{k2}(w,n,s,r:end,f) = NaN;
                                break
                            else
                                tAmac{k1}{k2}(w,n,s,r,f) = temp;
                            end
                        end
                    end
                end
            end
        end
    end
end

save([fsave,'tAmac.mat'],'fsm','tAmac','-v7.3');
save([fsave,'parameters.mat'],'W','N','R','S','F','-v7.3');

clear count time fsm

%% Difference between the estimated and detected run-in instant

dif = cell(length(tAmac),1);
for k1 = 1:length(dif)
    dif{k1} = cell(length(tAmac{k1}),1);
    for k2 = 1:length(tAmac{k1})
        dif{k1}{k2} = tAmac{k1}{k2}-tEst{k1}(k2);
        tAmac{k1}{k2} = []; % Frees memory
    end
    tAmac{k1} = [];
end

clear tAmac

save([fsave,'dif.mat'],'dif','tEst','-v7.3');

%% Cost function (quadratic error)

J = zeros(length(W),length(N),length(S),length(R),length(F));

for k1 = 1:length(dif)
    for k2 = 1:length(dif{k1})
        J = J+dif{k1}{k2}.^2;
    end
end

clear dif;

save([fsave,'J.mat'],'J','tEst','-v7.3');

%% Minimum values

[minval, minidx] = min(abs(J(:)));
[minInd(1), minInd(2), minInd(3), minInd(4), minInd(5)] = ind2sub( size(J), minidx);
wmin = W(minInd(1))
nmin = N(minInd(2))
smin = S(minInd(3))
rmin = R(minInd(4))
fmin = F(minInd(5))

cmin = min(abs(J(:)))
cmax = max(abs(J(:)));

nameVar = {'$w$','$n$','$\bar{d}$','$r$','$f$'};
nvar = 5;
param = {W,N,S,R,F};

figure;
sz = 700; r = 1; gap = 20; marg_h = [45 10]; marg_w = [55 50];
ha = tightPlots(nvar, nvar, sz, [1 r], gap, marg_h, marg_w,'pixels');
ha = reshape(ha,nvar,nvar)';

for kx = 1:nvar
    for ky = 1:nvar
        axes(ha(ky,kx));
        ind = num2cell(minInd);
        ind{kx} = ':'; ind{ky} = ':';
        x = param{kx}; y = param{ky}; xMin = x(minInd(kx)); yMin = y(minInd(ky));
        
        if kx == ky % Empty diagonal graphs
            z = [];
            set(gca,'Color','k','XTickMode','auto','XTickLabelMode','auto','YTickMode','auto','YTickLabelMode','auto')
        elseif kx > ky % Invert rows and columns in case of the upper graphs
            z = squeeze(J(ind{:}));
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','log')
        else
            z = squeeze(J(ind{:}))';
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','log')
        end
        
        xlim(x([1 end])); ylim(y([1 end]));
        line(x([1 end]),[yMin yMin],[cmax cmax],'color','r','LineWidth',1); % Lines at global minima
        line([xMin xMin],y([1 end]),[cmax cmax],'color','r','LineWidth',1);
        grid on;
        
        if kx == 1
            ylabel(nameVar{ky},'interpreter','latex'); % Sets label for rightmost column
        end
        
        if ky == nvar
            xlabel(nameVar{kx},'interpreter','latex'); % Sets label for lowest row
        end
    end
end

set(ha(:,:), 'fontname', 'Times', 'fontsize', 11,'Units','normalized');
set(ha(1:end-1,:), 'xticklabel', '', 'xtick',[]);
set(ha(:,2:end), 'yticklabel', '', 'ytick',[]);
lFig = get(ha(1,1),'Position'); lFig = lFig(4); 
gapFig = (1-lFig*nvar)/(nvar-1+(marg_h(1)+marg_h(2))/gap); % Normalized units
topFig = marg_h(2)*gapFig/gap;

cbh = colorbar(ha(3,4)); % Sets the colorbar and adjustments
cbh.Position(3) = cbh.Position(3)*2;
cbh.Position(1) = .96-cbh.Position(3);
cbh.Position(4) = lFig*nvar+gapFig*(nvar-1);
cbh.Position(2) = 1-topFig-(gapFig*(nvar-1)+lFig*nvar)/2-cbh.Position(4)/2;

savefig([fsave,'spacedDif_custo_parametros.fig']);
vecrast(gcf,[fsave,'spacedDif_custo_parametros'],800,'bottom','pdf');