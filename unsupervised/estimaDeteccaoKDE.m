clear; clc; close all;

%%

% Carrega dados de métodos aprovados para 
load('D:\Documentos\Amaciamento\DadosMat\aprovadosA_expanded.mat');
load('D:\Documentos\Amaciamento\DadosMat\aprovadosB_expanded.mat');
%fsave = 'D:\Documentos\Amaciamento\Apresentações\2021_12_16 - Artigo IEEE\';

ggGrA = ggGrA((ggGrA.TempoAmac(:,2)>=6)&(ggGrA.TempoAmac(:,4)>=6),:);

UnidadesA = ggGrA{1,"Unidade"}{1};

for k = 1:height(ggGrA)
    UnidadesA = unique([UnidadesA,ggGrA{k,"Unidade"}{1}]);
end

UnidadesB = ggGrB{1,"Unidade"}{1};

for k = 1:height(ggGrB)
    UnidadesB = unique([UnidadesB,ggGrB{k,"Unidade"}{1}]);
end

TimeA = cell(size(UnidadesA));

for k = 1:height(ggGrA)
    for k2 = 1:length(ggGrA{k,"Unidade"}{1})
        TimeA{strcmp(ggGrA{k,"Unidade"}{1}{k2},UnidadesA)} = [TimeA{strcmp(ggGrA{k,"Unidade"}{1}{k2},UnidadesA)};ggGrA{k,"TimeDetect"}{1}{k2}(:)'];
    end
end

TimeB = cell(size(UnidadesB));

for k = 1:height(ggGrB)
    for k2 = 1:length(ggGrB{k,"Unidade"}{1})
        TimeB{strcmp(ggGrB{k,"Unidade"}{1}{k2},UnidadesB)} = [TimeB{strcmp(ggGrB{k,"Unidade"}{1}{k2},UnidadesB)},ggGrB{k,"TimeDetect"}{1}{k2}(:)'];
    end
end

%% Estima KDE

Band = 0.5;

for ken = 1:3
    figure;
    ha = tightPlots(ceil(length(UnidadesA)/2), 2, 16, [5 3], [0.6 1.5], [1 0.5], [1.5 0.6], 'centimeters');
    tend = 40; xi = 0:0.01:tend;
    for k1 = 1:length(UnidadesA)
        f = ksdensity(TimeA{k1}(:,ken),xi,'Bandwidth',Band);
        axes(ha(k1))
        plot(xi,f);

        if k1 < (length(UnidadesA)-1)
            xticklabels("");
        else
            xlabel('Instante de transição [h]'); 
        end

        ylabel('PDF estimada');
        title(['Amostra ',UnidadesA{k1}]);
        xlim([0,tend]);

        [~,I] = max(f);
        TimeDetectA(k1,ken) = xi(I);
    end
end
% 
% savefig(strcat(fsave,'PDF_A.fig'));
% export_fig(strcat(fsave,'PDF_A'),'-pdf','-transparent');


for ken = 1:3
    figure;
    ha = tightPlots(ceil(length(UnidadesB)/2), 2, 16, [5 3], [0.6 1.5], [1 0.5], [1.5 0.6], 'centimeters');
    tend = 40; xi = 0:0.05:tend;
    for k1 = 1:length(UnidadesB)
        f = ksdensity(TimeB{k1}(:,ken),xi,'Bandwidth',Band);
        axes(ha(k1))
        plot(xi,f);

        if k1 < (length(UnidadesB)-1)
            xticklabels("");
        else
            xlabel('Instante de transição [h]'); 
        end

        ylabel('PDF estimada'); title(['Amostra ',UnidadesB{k1}]);
        xlim([0,tend]);

        [~,I] = max(f);
        TimeDetectB(k1,ken) = xi(I);
    end
end
% 
% savefig(strcat(fsave,'PDF_B.fig'));
% export_fig(strcat(fsave,'PDF_B'),'-pdf','-transparent');

%% Norm

for k1 = 1:height(ggGrA)
    for k2 = 1:length(ggGrA{k1,"Unidade"}{1})
        N(k2) = ggGrA{k1,"TimeDetect"}{1}{k2}(1)-TimeDetectA(strcmp(ggGrA{k1,"Unidade"}{1}{k2},UnidadesA));
    end
    NormaA(k1) = norm(N);
end

ggGrA = addvars(ggGrA,NormaA','NewVariableNames',{'Norm2'});
TopA = sortrows(ggGrA,"Norm2");

for k1 = 1:height(ggGrB)
    for k2 = 1:length(ggGrB{k1,"Unidade"}{1})
        N(k2) = ggGrB{k1,"TimeDetect"}{1}{k2}(1)-TimeDetectB(strcmp(ggGrB{k1,"Unidade"}{1}{k2},UnidadesB));
    end
    NormaB(k1) = norm(N);
end

ggGrB = addvars(ggGrB,NormaB','NewVariableNames',{'Norm2'});
TopB = sortrows(ggGrB,"Norm2");