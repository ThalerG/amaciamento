%% Parameter analysis for run-in detection using linear regression

clear; close all; clc;

rt = 'D:\Documentos\Amaciamento\'; % Root folder

% Create new folder for generated files
c = clock;
fsave = [rt 'Ferramentas\Arquivos Gerados\linRegression_parameters' num2str(c(1)-2000) num2str(c(2),'%02d') num2str(c(3),'%02d') '_' num2str(c(4),'%02d') num2str(c(5),'%02d') '\'];
mkdir(fsave); clear rt c;

% fsm: Test data folder 
% tEst: Manually inputed estimated run-in time

load('EnDataA.mat');

conjVal = [2,1;4,2;5,3]; % Ensaios reservados para conjunto de valida��o [Amostra, ensaio]

% Tempos de amaciamento esperados:

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

       
for k1 = 1:size(conjVal,1) % Apaga os valores dos conjuntos de valida��o
    tEst{conjVal(k1,1)}(conjVal(k1,2)) = [];
    EnData{conjVal(k1,1)}(conjVal(k1,2)) = [];
end      
       
path = cell(length(fsm),1); % Cell array for the data file path
tAmac = cell(length(fsm),1); % Cell array for the run-in instant

N = 5:5:100; % Sample window for linear regression
D = 5:5:100; % Sample window for linear regression
M = [1,5:5:120]; % Moving average filter window
ALPHA = 0:0.01:1; % Significance level

lenN = length(N);
lenM = length(M);
lenD = length(D);
lenAlpha = length(Alpha);

r.TPR = NaN; r.FPR = NaN;
Res = repmat(r,lenN,lenM,lenD);

%% Sample processing

totalIt = 0; % Number of iterations
for k1 = 1:length(tAmac)
    totalIt = totalIt+length(tAmac{k1});
end
totalIt = totalIt*lenN*lenM*lenD;

parfor n = 1:lenN
    for d = 1:lenD
        for m = 1:lenM
            classAmac = [];
            classCor = [];
            if ((N(n)-1)*D(d)/60)>wmax
                Res(n,m,d).TPR = nan(1,length(thr));
                Res(n,m,d).FPR = nan(1,length(thr));
                continue
            end
            
            for k1 = 1:length(EnData)
                for k2 = 1:length(EnData{k1})
                    [cor,tempo] = mkTrainData(EnData{k1}(k2).cRMS,EnData{k1}(k2).tempo,N(n),M(m),D(d),tEst{k1}(k2), minT);
                    
                    classTemp = strings(length(cor(:,1)),1);
                    classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
                    classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
                    classCor = [classCor;cor];
                    classAmac = [classAmac;classTemp];
                end
            end
            
            pVal = arrayfun(@(ROWIDX) lrPValue(classCor(ROWIDX,:)), (1:size(classCor,1)).');
            classAmac = classAmac == 'amaciado';

            Res(n,m,d).TPR = nan(1,length(thr));
            Res(n,m,d).FPR = nan(1,length(thr));
            
            for k = 1:lenAlpha
                gtest = pVal>=ALPHA(k);
                cMat = confusionmat(classAmac,gtest);
                
                Res(n,m,d).TPR(k) = cMat(1,1)/sum(cMat(:,1));
                Res(n,m,d).FPR(k) = cMat(1,2)/sum(cMat(:,2));
            end
            ppm.increment();
        end
    end
end

save([fsave,'Results.mat'],'Res','ALPHA','maxTPR','N','M','D','maxInd','tEst','EnData','conjVal');

clear count time fsm

%% Difference between the estimated and detected run-in instant

dif = cell(length(tAmac),1);

for k1 = 1:length(dif)
    dif{k1} = cell(length(tAmac{k1}),1);
    for k2 = 1:length(tAmac{k1})
        dif{k1}{k2} = tAmac{k1}{k2}-tEst{k1}(k2);
        tAmac{k1}{k2} = []; % Frees some space in memory
    end
end

clear tAmac

save([fsave,'dif.mat'],'dif','tEst','-v7.3');

%% Cost function (quadratic error)

J = zeros(length(N),length(ALPHA),length(R),length(F));

for k1 = 1:length(dif)
    for k2 = 1:length(dif{k1})
        J = J+dif{k1}{k2}.^2;
    end
end

save([fsave,'J.mat'],'J','tEst','-v7.3');

%% Minimum values

[minval, minidx] = min(abs(J(:)));
[minInd(1), minInd(2), minInd(3), minInd(4)] = ind2sub( size(J), minidx);
wmin = N(minInd(1))
alphamin = ALPHA(minInd(2))
rmin = R(minInd(3))
fmin = F(minInd(4))

cmin = min(abs(J(:)))
cmax = max(abs(J(:)));

nameVar = {'$w$','$\alpha$','$r$','$f$'};
nvar = 4;
param = {N,ALPHA,R,F};

figure;
sz = 700; r = 1; gap = 20; marg_h = [45 10]; marg_w = [50 50];
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
        
        line(x([1 end]),[yMin yMin],[cmax cmax],'color','r','LineWidth',1); % Lines at global minima
        line([xMin xMin],y([1 end]),[cmax cmax],'color','r','LineWidth',1);
        xlim(x([1 end])); ylim(y([1 end]));
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

savefig([fsave,'lr_custo_parametros.fig']);
vecrast(gcf,[fsave,'lr_custo_parametros'],800,'bottom','pdf');