szStruct = size(spcDifAn);

nameVar = {'$M$','$D$','$\bar{d}$'};
nvar = length(nameVar);
param = {M,D,dMax};

%%% MMC Train

MMC_Train = [spcDifAn.MMC_Train]; MMC_Train = reshape(MMC_Train,szStruct);

[~, maxidx] = max(MMC_Train(:));
[maxInd(1), maxInd(2), maxInd(3), maxInd(4)] = ind2sub( size(MMC_Train), maxidx);

MMC_Train = squeeze(MMC_Train(:,:,maxInd(3),:)); clear maxInd;
[~, maxidx] = max(MMC_Train(:));
[maxInd(1), maxInd(2), maxInd(3)] = ind2sub( size(MMC_Train), maxidx);

cmax = max(MMC_Train(:));
cmin = min(MMC_Train(:));

figure;
sz = 16; r = 1; gap = 0.4; marg_h = [1.2 0.1]; marg_w = [1.2 1.2];
ha = tightPlots(nvar, nvar, sz, [1 r], gap, marg_h, marg_w,'centimeters');
ha = reshape(ha,nvar,nvar)';

if ~isnan(cmax)

for kx = 1:nvar
    for ky = 1:nvar
        axes(ha(ky,kx));
        ind = num2cell(maxInd);
        ind{kx} = ':'; ind{ky} = ':';
        x = param{kx}; y = param{ky}; xmax = x(maxInd(kx)); ymax = y(maxInd(ky));
        
        if kx == ky % Empty diagonal graphs
            z = [];
            set(gca,'Color','k','XTickMode','auto','XTickLabelMode','auto','YTickMode','auto','YTickLabelMode','auto')
        elseif kx > ky % Invert rows and columns in case of the upper graphs
            z = squeeze(MMC_Train(ind{:}));
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        else
            z = squeeze(MMC_Train(ind{:}))';
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        end        
        
        line(x([1 end]),[ymax ymax],[cmax cmax],'color','r','LineWidth',1); % Lines at global maxima
        line([xmax xmax],y([1 end]),[cmax cmax],'color','r','LineWidth',1);
        xlim(x([1 end])); ylim(y([1 end]));
        if kx == 1
            ylabel(nameVar{ky},'interpreter','latex'); % Sets label for rightmost column
        end
        
        if ky == nvar
            xlabel(nameVar{kx},'interpreter','latex'); % Sets label for lowest row
        end
        
        if ky == 3
            set(gca,'YScale','log');
        end
        if kx == 3
            set(gca,'XScale','log');
        end
    end
end

end

set(ha(:,:), 'fontname', 'Times', 'fontsize', 11,'Units','normalized');
set(ha(1:end-1,:), 'xticklabel', '', 'xtick',[]);
set(ha(:,2:end), 'yticklabel', '', 'ytick',[]);
lFig = get(ha(1,1),'Position'); lFig = lFig(4); 
gapFig = (1-lFig*nvar)/(nvar-1+(marg_h(1)+marg_h(2))/gap); % Normalized units
topFig = marg_h(2)*gapFig/gap;

cbh = colorbar(ha(nvar-1,nvar)); % Sets the colorbar and adjustments
cbh.Position(3) = cbh.Position(3)*2;
cbh.Position(1) = .96-cbh.Position(3);
cbh.Position(4) = lFig*nvar+gapFig*(nvar-1);
cbh.Position(2) = 1-topFig-(gapFig*(nvar-1)+lFig*nvar)/2-cbh.Position(4)/2;

savefig([fsave_spcDif,'spcDif_graph_MMC_Train.fig']);
vecrast(gcf,[fsave_spcDif,'spcDif_graph_MMC_Train'],800,'bottom','pdf');
close all;

clear MMC_Train maxidx cmax cmin sz r gap marg_h marg_w ha ind x y xmax ymax z lFig gapFig topFig cbh

%%% ROC_AUC Train

AUC_Train = [spcDifAn.ROC_AUC_Train]; AUC_Train = reshape(AUC_Train,szStruct);

[~, maxidx] = max(AUC_Train(:));
[maxInd(1), maxInd(2), maxInd(3), maxInd(4)] = ind2sub( size(AUC_Train), maxidx);

AUC_Train = squeeze(AUC_Train(:,:,maxInd(3),:)); clear maxInd;
[~, maxidx] = max(AUC_Train(:));
[maxInd(1), maxInd(2), maxInd(3)] = ind2sub( size(AUC_Train), maxidx);

cmax = max(AUC_Train(:));
cmin = min(AUC_Train(:));

figure;
sz = 16; r = 1; gap = 0.4; marg_h = [1.2 0.1]; marg_w = [1.2 1.2];
ha = tightPlots(nvar, nvar, sz, [1 r], gap, marg_h, marg_w,'centimeters');
ha = reshape(ha,nvar,nvar)';

if ~isnan(cmax)

for kx = 1:nvar
    for ky = 1:nvar
        axes(ha(ky,kx));
        ind = num2cell(maxInd);
        ind{kx} = ':'; ind{ky} = ':';
        x = param{kx}; y = param{ky}; xmax = x(maxInd(kx)); ymax = y(maxInd(ky));
        
        if kx == ky % Empty diagonal graphs
            z = [];
            set(gca,'Color','k','XTickMode','auto','XTickLabelMode','auto','YTickMode','auto','YTickLabelMode','auto')
        elseif kx > ky % Invert rows and columns in case of the upper graphs
            z = squeeze(AUC_Train(ind{:}));
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        else
            z = squeeze(AUC_Train(ind{:}))';
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        end        
        
        line(x([1 end]),[ymax ymax],[cmax cmax],'color','r','LineWidth',1); % Lines at global maxima
        line([xmax xmax],y([1 end]),[cmax cmax],'color','r','LineWidth',1);
        xlim(x([1 end])); ylim(y([1 end]));
        if kx == 1
            ylabel(nameVar{ky},'interpreter','latex'); % Sets label for rightmost column
        end
        
        if ky == nvar
            xlabel(nameVar{kx},'interpreter','latex'); % Sets label for lowest row
        end
        
        if ky == 3
            set(gca,'YScale','log');
        end
        if kx == 3
            set(gca,'XScale','log');
        end
    end
end

end

set(ha(:,:), 'fontname', 'Times', 'fontsize', 11,'Units','normalized');
set(ha(1:end-1,:), 'xticklabel', '', 'xtick',[]);
set(ha(:,2:end), 'yticklabel', '', 'ytick',[]);
lFig = get(ha(1,1),'Position'); lFig = lFig(4); 
gapFig = (1-lFig*nvar)/(nvar-1+(marg_h(1)+marg_h(2))/gap); % Normalized units
topFig = marg_h(2)*gapFig/gap;

cbh = colorbar(ha(nvar-1,nvar)); % Sets the colorbar and adjustments
cbh.Position(3) = cbh.Position(3)*2;
cbh.Position(1) = .96-cbh.Position(3);
cbh.Position(4) = lFig*nvar+gapFig*(nvar-1);
cbh.Position(2) = 1-topFig-(gapFig*(nvar-1)+lFig*nvar)/2-cbh.Position(4)/2;

savefig([fsave_spcDif,'spcDif_graph_ROCAUC_Train.fig']);
vecrast(gcf,[fsave_spcDif,'spcDif_graph_ROCAUC_Train'],800,'bottom','pdf');
close all;

clear AUC_Train maxidx cmax cmin sz r gap marg_h marg_w ha ind x y xmax ymax z lFig gapFig topFig cbh

%%% fBeta Train

fBeta_Train = [spcDifAn.fselBeta_Train]; fBeta_Train = reshape(fBeta_Train,szStruct);

[~, maxidx] = max(fBeta_Train(:));
[maxInd(1), maxInd(2), maxInd(3), maxInd(4)] = ind2sub( size(fBeta_Train), maxidx);

fBeta_Train = squeeze(fBeta_Train(:,:,maxInd(3),:)); clear maxInd;
[~, maxidx] = max(fBeta_Train(:));
[maxInd(1), maxInd(2), maxInd(3)] = ind2sub( size(fBeta_Train), maxidx);

cmax = max(fBeta_Train(:));
cmin = min(fBeta_Train(:));

figure;
sz = 16; r = 1; gap = 0.4; marg_h = [1.2 0.1]; marg_w = [1.2 1.2];
ha = tightPlots(nvar, nvar, sz, [1 r], gap, marg_h, marg_w,'centimeters');
ha = reshape(ha,nvar,nvar)';

if ~isnan(cmax)

for kx = 1:nvar
    for ky = 1:nvar
        axes(ha(ky,kx));
        ind = num2cell(maxInd);
        ind{kx} = ':'; ind{ky} = ':';
        x = param{kx}; y = param{ky}; xmax = x(maxInd(kx)); ymax = y(maxInd(ky));
        
        if kx == ky % Empty diagonal graphs
            z = [];
            set(gca,'Color','k','XTickMode','auto','XTickLabelMode','auto','YTickMode','auto','YTickLabelMode','auto')
        elseif kx > ky % Invert rows and columns in case of the upper graphs
            z = squeeze(fBeta_Train(ind{:}));
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        else
            z = squeeze(fBeta_Train(ind{:}))';
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        end        
        
        line(x([1 end]),[ymax ymax],[cmax cmax],'color','r','LineWidth',1); % Lines at global maxima
        line([xmax xmax],y([1 end]),[cmax cmax],'color','r','LineWidth',1);
        xlim(x([1 end])); ylim(y([1 end]));
        if kx == 1
            ylabel(nameVar{ky},'interpreter','latex'); % Sets label for rightmost column
        end
        
        if ky == nvar
            xlabel(nameVar{kx},'interpreter','latex'); % Sets label for lowest row
        end
        
        if ky == 3
            set(gca,'YScale','log');
        end
        if kx == 3
            set(gca,'XScale','log');
        end
    end
end

end
set(ha(:,:), 'fontname', 'Times', 'fontsize', 11,'Units','normalized');
set(ha(1:end-1,:), 'xticklabel', '', 'xtick',[]);
set(ha(:,2:end), 'yticklabel', '', 'ytick',[]);
lFig = get(ha(1,1),'Position'); lFig = lFig(4); 
gapFig = (1-lFig*nvar)/(nvar-1+(marg_h(1)+marg_h(2))/gap); % Normalized units
topFig = marg_h(2)*gapFig/gap;

cbh = colorbar(ha(nvar-1,nvar)); % Sets the colorbar and adjustments
cbh.Position(3) = cbh.Position(3)*2;
cbh.Position(1) = .96-cbh.Position(3);
cbh.Position(4) = lFig*nvar+gapFig*(nvar-1);
cbh.Position(2) = 1-topFig-(gapFig*(nvar-1)+lFig*nvar)/2-cbh.Position(4)/2;

savefig([fsave_spcDif,'spcDif_graph_fBeta_Train.fig']);
vecrast(gcf,[fsave_spcDif,'spcDif_graph_fBeta_Train'],800,'bottom','pdf');
close all;

clear fBeta_Train maxidx cmax cmin sz r gap marg_h marg_w ha ind x y xmax ymax z lFig gapFig topFig cbh

%%% MMC Test

MMC_Test = [spcDifAn.MMC_Test]; MMC_Test = reshape(MMC_Test,szStruct);

[~, maxidx] = max(MMC_Test(:));
[maxInd(1), maxInd(2), maxInd(3), maxInd(4)] = ind2sub( size(MMC_Test), maxidx);

MMC_Test = squeeze(MMC_Test(:,:,maxInd(3),:)); clear maxInd;
[~, maxidx] = max(MMC_Test(:));
[maxInd(1), maxInd(2), maxInd(3)] = ind2sub( size(MMC_Test), maxidx);

cmax = max(MMC_Test(:));
cmin = min(MMC_Test(:));

figure;
sz = 16; r = 1; gap = 0.4; marg_h = [1.2 0.1]; marg_w = [1.2 1.2];
ha = tightPlots(nvar, nvar, sz, [1 r], gap, marg_h, marg_w,'centimeters');
ha = reshape(ha,nvar,nvar)';

if ~isnan(cmax)
    
for kx = 1:nvar
    for ky = 1:nvar
        axes(ha(ky,kx));
        ind = num2cell(maxInd);
        ind{kx} = ':'; ind{ky} = ':';
        x = param{kx}; y = param{ky}; xmax = x(maxInd(kx)); ymax = y(maxInd(ky));
        
        if kx == ky % Empty diagonal graphs
            z = [];
            set(gca,'Color','k','XTickMode','auto','XTickLabelMode','auto','YTickMode','auto','YTickLabelMode','auto')
        elseif kx > ky % Invert rows and columns in case of the upper graphs
            z = squeeze(MMC_Test(ind{:}));
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        else
            z = squeeze(MMC_Test(ind{:}))';
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        end        
        
        line(x([1 end]),[ymax ymax],[cmax cmax],'color','r','LineWidth',1); % Lines at global maxima
        line([xmax xmax],y([1 end]),[cmax cmax],'color','r','LineWidth',1);
        xlim(x([1 end])); ylim(y([1 end]));
        if kx == 1
            ylabel(nameVar{ky},'interpreter','latex'); % Sets label for rightmost column
        end
        
        if ky == nvar
            xlabel(nameVar{kx},'interpreter','latex'); % Sets label for lowest row
        end
        
        if ky == 3
            set(gca,'YScale','log');
        end
        if kx == 3
            set(gca,'XScale','log');
        end
    end
end

end
set(ha(:,:), 'fontname', 'Times', 'fontsize', 11,'Units','normalized');
set(ha(1:end-1,:), 'xticklabel', '', 'xtick',[]);
set(ha(:,2:end), 'yticklabel', '', 'ytick',[]);
lFig = get(ha(1,1),'Position'); lFig = lFig(4); 
gapFig = (1-lFig*nvar)/(nvar-1+(marg_h(1)+marg_h(2))/gap); % Normalized units
topFig = marg_h(2)*gapFig/gap;

cbh = colorbar(ha(nvar-1,nvar)); % Sets the colorbar and adjustments
cbh.Position(3) = cbh.Position(3)*2;
cbh.Position(1) = .96-cbh.Position(3);
cbh.Position(4) = lFig*nvar+gapFig*(nvar-1);
cbh.Position(2) = 1-topFig-(gapFig*(nvar-1)+lFig*nvar)/2-cbh.Position(4)/2;

savefig([fsave_spcDif,'spcDif_graph_MMC_Test.fig']);
vecrast(gcf,[fsave_spcDif,'spcDif_graph_MMC_Test'],800,'bottom','pdf');
close all;

clear MMC_Test maxidx cmax cmin sz r gap marg_h marg_w ha ind x y xmax ymax z lFig gapFig topFig cbh

%%% AUC Test

AUC_Test = [spcDifAn.ROC_AUC_Test]; AUC_Test = reshape(AUC_Test,szStruct);

[~, maxidx] = max(AUC_Test(:));
[maxInd(1), maxInd(2), maxInd(3), maxInd(4)] = ind2sub( size(AUC_Test), maxidx);

AUC_Test = squeeze(AUC_Test(:,:,maxInd(3),:)); clear maxInd;
[~, maxidx] = max(AUC_Test(:));
[maxInd(1), maxInd(2), maxInd(3)] = ind2sub( size(AUC_Test), maxidx);

cmax = max(AUC_Test(:));
cmin = min(AUC_Test(:));

figure;
sz = 16; r = 1; gap = 0.4; marg_h = [1.2 0.1]; marg_w = [1.2 1.2];
ha = tightPlots(nvar, nvar, sz, [1 r], gap, marg_h, marg_w,'centimeters');
ha = reshape(ha,nvar,nvar)';

if ~isnan(cmax)

for kx = 1:nvar
    for ky = 1:nvar
        axes(ha(ky,kx));
        ind = num2cell(maxInd);
        ind{kx} = ':'; ind{ky} = ':';
        x = param{kx}; y = param{ky}; xmax = x(maxInd(kx)); ymax = y(maxInd(ky));
        
        if kx == ky % Empty diagonal graphs
            z = [];
            set(gca,'Color','k','XTickMode','auto','XTickLabelMode','auto','YTickMode','auto','YTickLabelMode','auto')
        elseif kx > ky % Invert rows and columns in case of the upper graphs
            z = squeeze(AUC_Test(ind{:}));
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        else
            z = squeeze(AUC_Test(ind{:}))';
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        end        
        
        line(x([1 end]),[ymax ymax],[cmax cmax],'color','r','LineWidth',1); % Lines at global maxima
        line([xmax xmax],y([1 end]),[cmax cmax],'color','r','LineWidth',1);
        xlim(x([1 end])); ylim(y([1 end]));
        if kx == 1
            ylabel(nameVar{ky},'interpreter','latex'); % Sets label for rightmost column
        end
        
        if ky == nvar
            xlabel(nameVar{kx},'interpreter','latex'); % Sets label for lowest row
        end
        
        if ky == 3
            set(gca,'YScale','log');
        end
        if kx == 3
            set(gca,'XScale','log');
        end
    end
end

end
set(ha(:,:), 'fontname', 'Times', 'fontsize', 11,'Units','normalized');
set(ha(1:end-1,:), 'xticklabel', '', 'xtick',[]);
set(ha(:,2:end), 'yticklabel', '', 'ytick',[]);
lFig = get(ha(1,1),'Position'); lFig = lFig(4); 
gapFig = (1-lFig*nvar)/(nvar-1+(marg_h(1)+marg_h(2))/gap); % Normalized units
topFig = marg_h(2)*gapFig/gap;

cbh = colorbar(ha(nvar-1,nvar)); % Sets the colorbar and adjustments
cbh.Position(3) = cbh.Position(3)*2;
cbh.Position(1) = .96-cbh.Position(3);
cbh.Position(4) = lFig*nvar+gapFig*(nvar-1);
cbh.Position(2) = 1-topFig-(gapFig*(nvar-1)+lFig*nvar)/2-cbh.Position(4)/2;

savefig([fsave_spcDif,'spcDif_graph_AUC_Test.fig']);
vecrast(gcf,[fsave_spcDif,'spcDif_graph_AUC_Test'],800,'bottom','pdf');
close all;

clear AUC_Test maxidx cmax cmin sz r gap marg_h marg_w ha ind x y xmax ymax z lFig gapFig topFig cbh

%%% fBeta Test

fBeta_Test = [spcDifAn.fselBeta_Test]; fBeta_Test = reshape(fBeta_Test,szStruct);

[~, maxidx] = max(fBeta_Test(:));
[maxInd(1), maxInd(2), maxInd(3), maxInd(4)] = ind2sub( size(fBeta_Test), maxidx);

fBeta_Test = squeeze(fBeta_Test(:,:,maxInd(3),:)); clear maxInd;
[~, maxidx] = max(fBeta_Test(:));
[maxInd(1), maxInd(2), maxInd(3)] = ind2sub( size(fBeta_Test), maxidx);

cmax = max(fBeta_Test(:));
cmin = min(fBeta_Test(:));

figure;
sz = 16; r = 1; gap = 0.4; marg_h = [1.2 0.1]; marg_w = [1.2 1.2];
ha = tightPlots(nvar, nvar, sz, [1 r], gap, marg_h, marg_w,'centimeters');
ha = reshape(ha,nvar,nvar)';

if ~isnan(cmax)
    
for kx = 1:nvar
    for ky = 1:nvar
        axes(ha(ky,kx));
        ind = num2cell(maxInd);
        ind{kx} = ':'; ind{ky} = ':';
        x = param{kx}; y = param{ky}; xmax = x(maxInd(kx)); ymax = y(maxInd(ky));
        
        if kx == ky % Empty diagonal graphs
            z = [];
            set(gca,'Color','k','XTickMode','auto','XTickLabelMode','auto','YTickMode','auto','YTickLabelMode','auto')
        elseif kx > ky % Invert rows and columns in case of the upper graphs
            z = squeeze(fBeta_Test(ind{:}));
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        else
            z = squeeze(fBeta_Test(ind{:}))';
            surf(x,y,z,'edgecolor','none'); view(2);
            caxis([cmin cmax])
            set(gca,'ColorScale','lin')
        end        
        
        line(x([1 end]),[ymax ymax],[cmax cmax],'color','r','LineWidth',1); % Lines at global maxima
        line([xmax xmax],y([1 end]),[cmax cmax],'color','r','LineWidth',1);
        xlim(x([1 end])); ylim(y([1 end]));
        if kx == 1
            ylabel(nameVar{ky},'interpreter','latex'); % Sets label for rightmost column
        end
        
        if ky == nvar
            xlabel(nameVar{kx},'interpreter','latex'); % Sets label for lowest row
        end
        
        if ky == 3
            set(gca,'YScale','log');
        end
        if kx == 3
            set(gca,'XScale','log');
        end
    end
end

end
set(ha(:,:), 'fontname', 'Times', 'fontsize', 11,'Units','normalized');
set(ha(1:end-1,:), 'xticklabel', '', 'xtick',[]);
set(ha(:,2:end), 'yticklabel', '', 'ytick',[]);
lFig = get(ha(1,1),'Position'); lFig = lFig(4); 
gapFig = (1-lFig*nvar)/(nvar-1+(marg_h(1)+marg_h(2))/gap); % Normalized units
topFig = marg_h(2)*gapFig/gap;

cbh = colorbar(ha(nvar-1,nvar)); % Sets the colorbar and adjustments
cbh.Position(3) = cbh.Position(3)*2;
cbh.Position(1) = .96-cbh.Position(3);
cbh.Position(4) = lFig*nvar+gapFig*(nvar-1);
cbh.Position(2) = 1-topFig-(gapFig*(nvar-1)+lFig*nvar)/2-cbh.Position(4)/2;

savefig([fsave_spcDif,'spcDif_graph_fBeta_Test.fig']);
vecrast(gcf,[fsave_spcDif,'spcDif_graph_fBeta_Test'],800,'bottom','pdf');
close all;

clear fBeta_Test maxidx cmax cmin sz r gap marg_h marg_w ha ind x y xmax ymax z lFig gapFig topFig cbh

%%% Limpeza final de variáveis

clear szStruct nameVar nvar param