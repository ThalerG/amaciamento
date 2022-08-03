clc; clear; close all;

N = 2; M = 1; D = 5; 

% var = {'cRMS', 'cKur', 'vInfRMS', 'vInfKur', 'vSupRMS', 'vSupKur', 'vaz'};
var = {'cRMS'};

load('EnDataA_Dissertacao.mat');
minT = 20;

TEstA = {};
for k = 1:length(EnDataA)
    TEstA{k} = 10*ones(size(EnDataA));
end

figure;

[XA,YA,tA] = preTrain(EnDataA,TEstA,N,M,D,minT,var);
scatter(XA(:,1), XA(:,2))
coef = pca(XA);
XF = XA*coef;
XF = normalize(XF);
figure;
scatter(XF(:,1), XF(:,2));
cov(XF)
%%
[~,IA] = sort(tA); cor = parula(max(IA));
scatter3(XA(:,1), XA(:,2), XA(:,3), 36, tA); aColorbar = colorbar; xl = xlim(); yl = ylim(); zl = zlim();
line([0,100],[0,100],[0,100],'LineStyle','--','color','k');
xlim(xl); ylim(yl), zlim(zl);
xlabel([var{1},'(k)']); ylabel([var{1},'(k-', num2str(D), ')']); zlabel([var{1},'(k-', num2str(2*D), ')']); aColorbar.Label.String = {'Time [h]'};

figure;
scatter(tA,std(XA'));


load('EnDataB_DissertacaoA.mat');
minT = 40;

TEstB = {};
for k = 1:length(EnDataB)
    TEstB{k} = 10*ones(size(EnDataB));
end

figure;
[XB,YB,tB] = preTrain(EnDataB,TEstB,N,M,D,minT,var);
[~,IB] = sort(tB); cor = parula(max(IA));
scatter3(XB(:,1), XB(:,2), XB(:,3), 36, tB); bColorbar = colorbar; xl = xlim(); yl = ylim(); zl = zlim();
line([0,100],[0,100],[0,100],'LineStyle','--','color','k');
xlim(xl); ylim(yl), zlim(zl);
xlabel([var{1},'(k)']); ylabel([var{1},'(k-', num2str(D), ')']); zlabel([var{1},'(k-', num2str(2*D), ')']); bColorbar.Label.String = {'Time [h]'};

figure;
ha = tightPlots(4, 2, 16, [2 1], [0.5 0.5], [0.9 0.4], [1.2 0.1], 'centimeters');
for k1 = 1:length(EnDataB)
    axes(ha(k1));
    hold on;
    for k2 = 1:length(EnDataB{k1})
        EnDataTemp{1}(1) = EnDataB{k1}(k2);
        [XB,YB,tB] = preTrain(EnDataTemp,[],N,M,D,minT,var);
        if ~isempty(tB)
            plot(tB,std(XB'));
        end
    end
    grid;
    xticklabels('auto');
    hold off;
end
