clear; close all;

%% Modelo A

load('D:\Documentos\Amaciamento\Apresentações\00_Dissertacao\NaoSupervisionado\resultadosAprovadosA.mat');
sv = 'D:\Documentos\Amaciamento\Apresentações\00_Dissertacao\';

% Grandeza
Gr = unique(ggGrA.Grandeza); Gr = sort(Gr);
for k = 1:length(Gr)
    Grper(k) = nnz(strcmp(ggGrA.Grandeza,Gr(k)));
end

% Method
Met = unique(ggGrA.Method); Met = sort(Met);
for k = 1:length(Met)
    Metper(k) = nnz(strcmp(ggGrA.Method,Met(k)));
end

% W
W = unique(ggGrA.Window); W = sort(W);
for k = 1:length(W)
    Wper(k) = nnz(ggGrA.Window==W(k));
end

% N
N = unique(ggGrA.N); N = sort(N);
for k = 1:length(N)
    Nper(k) = nnz(ggGrA.N==N(k));
end

% D
D = unique(ggGrA.D); D = sort(D);
for k = 1:length(D)
    Dper(k) = nnz(ggGrA.D==D(k));
end

% M
M = unique(ggGrA.M); M = sort(M);
for k = 1:length(M)
    Mper(k) = nnz(ggGrA.M==M(k));
end

figure;
ha = tightPlots(2, 3, 16, [1.5 1], [0.5 0.2], [1.1 0.6], [1.5 0.1], 'centimeters');
axes(ha(1));
pie(Grper); title('Grandeza');

axes(ha(2));
pie(Metper); title('Método');

axes(ha(3));
pie(Wper); title('$W$');

axes(ha(4));
pie(Nper); title('$N$');

axes(ha(5));
pie(Dper); title('$D$');

axes(ha(6));
pie(Mper); title('$M$');

set(gcf,'Renderer','painters');
savefig(strcat(sv,'pieA.fig'));
% export_fig(strcat(sv,'pieA'),'-pdf','-transparent');
saveas(gcf,strcat(sv,'pieA.pdf'));

% Legendas

axes(ha(1));
legend(Gr,'location','bestoutside');

axes(ha(2));
legend(Met,'location','bestoutside');

axes(ha(3));
legend(string(W),'location','bestoutside');

axes(ha(4));
legend(string(N),'location','bestoutside');

axes(ha(5));
legend(string(D),'location','bestoutside');

axes(ha(6));
legend(string(M),'location','bestoutside');

savefig(strcat(sv,'legendaPieA.fig'));
% export_fig(strcat(sv,'legendaPieA'),'-pdf','-transparent');
saveas(gcf,strcat(sv,'legendaPieA.pdf'));
%% Modelo B

clear; close all;

load('D:\Documentos\Amaciamento\Apresentações\00_Dissertacao\NaoSupervisionado\resultadosAprovadosB.mat');
sv = 'D:\Documentos\Amaciamento\Apresentações\00_Dissertacao\';

% Grandeza
Gr = unique(ggGrB.Grandeza); Gr = sort(Gr);
for k = 1:length(Gr)
    Grper(k) = nnz(strcmp(ggGrB.Grandeza,Gr(k)));
end

% Method
Met = unique(ggGrB.Method); Met = sort(Met);
for k = 1:length(Met)
    Metper(k) = nnz(strcmp(ggGrB.Method,Met(k)));
end

% W
W = unique(ggGrB.Window); W = sort(W);
for k = 1:length(W)
    Wper(k) = nnz(ggGrB.Window==W(k));
end

% N
N = unique(ggGrB.N); N = sort(N);
for k = 1:length(N)
    Nper(k) = nnz(ggGrB.N==N(k));
end

% D
D = unique(ggGrB.D); D = sort(D);
for k = 1:length(D)
    Dper(k) = nnz(ggGrB.D==D(k));
end

% M
M = unique(ggGrB.M); M = sort(M);
for k = 1:length(M)
    Mper(k) = nnz(ggGrB.M==M(k));
end

figure;
ha = tightPlots(2, 3, 16, [1.5 1], [0.5 0.2], [1.1 0.6], [1.5 0.1], 'centimeters');
axes(ha(1));
pie(Grper); title('Grandeza');

axes(ha(2));
pie(Metper); title('Método');

axes(ha(3));
pie(Wper); title('$W$');

axes(ha(4));
pie(Nper); title('$N$');

axes(ha(5));
pie(Dper); title('$D$');

axes(ha(6));
pie(Mper); title('$M$');

set(gcf,'Renderer','painters');
savefig(strcat(sv,'pieB.fig'));
% export_fig(strcat(sv,'pieB'),'-pdf','-transparent');
saveas(gcf,strcat(sv,'pieB.pdf'));

% Legendas

axes(ha(1));
legend(Gr,'location','bestoutside');

axes(ha(2));
legend(Met,'location','bestoutside');

axes(ha(3));
legend(string(W),'location','bestoutside');

axes(ha(4));
legend(string(N),'location','bestoutside');

axes(ha(5));
legend(string(D),'location','bestoutside');

axes(ha(6));
legend(string(M),'location','bestoutside');

savefig(strcat(sv,'legendaPieB.fig'));
% export_fig(strcat(sv,'legendaPieB'),'-pdf','-transparent');
saveas(gcf,strcat(sv,'legendaPieB.pdf'));