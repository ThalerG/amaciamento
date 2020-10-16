load('D:\Documentos\Amaciamento\Ferramentas\ProjetoMatlab\method_logisticRegression\test_2020_10_01\ResultsCat.mat');
sz = size(Res);
idThr = size(Res);
norm = NaN(sz);

for k1 = 1:sz(1)
    for k2 = 1:sz(2)
        for k3 = 1:sz(3)
            [norm(k1,k2,k3),idThr(k1,k2,k3)] = min(((1-Res(k1,k2,k3).TPR).^2 + (0-Res(k1,k2,k3).FPR).^2).^(1/2));
        end
    end
end

[minval, minidx] = min(norm(:));
[minInd(1), minInd(2), minInd(3)] = ind2sub(sz, minidx);
minInd(4) = thr(idThr(minInd(1),minInd(2),minInd(3)));


nameVar = {'$N$','$M$','$D$'};
nvar = 3;
param = {N,M,D};
cmin = min(norm(:));
cmax = max(norm(:));

fig = figure;
sz = 700; r = 1; gap = 20; marg_h = [45 10]; marg_w = [50 50];
ha = tightPlots(nvar, nvar, sz, [1 r], gap, marg_h, marg_w,'pixels');
ha = reshape(ha,nvar,nvar)';

for kx = 1:nvar
    for ky = 1:nvar
        axes(ha(ky,kx));
        ind = num2cell(minInd(1:3));
        ind{kx} = ':'; ind{ky} = ':';
        x = param{kx}; y = param{ky}; xMin = x(minInd(kx)); yMin = y(minInd(ky));
        
        if kx == ky % Empty diagonal graphs
            z = [];
            set(gca,'Color','k','XTickMode','auto','XTickLabelMode','auto','YTickMode','auto','YTickLabelMode','auto')
        elseif kx > ky % Invert rows and columns in case of the upper graphs
            z = squeeze(norm(ind{:}));
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','log')
        else
            z = squeeze(norm(ind{:}))';
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

cbh = colorbar(ha(2,3)); % Sets the colorbar and adjustments
cbh.Position(3) = cbh.Position(3);
cbh.Position(1) = .96-cbh.Position(3);
cbh.Position(4) = lFig*nvar+gapFig*(nvar-1);
cbh.Position(2) = 1-topFig-(gapFig*(nvar-1)+lFig*nvar)/2-cbh.Position(4)/2;