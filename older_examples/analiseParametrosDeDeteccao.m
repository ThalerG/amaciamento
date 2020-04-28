%% Analise de parametros de deteccao

clear; close all; clc;
addpath('C:\Users\G. Thaler\Documents\Projeto Amaciamento\Ferramentas');

fpr = 'C:\Users\G. Thaler\Documents\Projeto Amaciamento\Dados Processados\';
fsave = 'C:\Users\G. Thaler\Documents\Projeto Amaciamento\Apresentações\fev-2020\';

fsm3 = {'Amostra 3\N_2019-12-04\';
        'Amostra 3\A_2019-12-09\';
        'Amostra 3\A_2019-12-11\'};

fsm4 = {'Amostra 4\N_2019-12-16\';
        'Amostra 4\A_2019-12-19\';
        'Amostra 4\A_2020-01-06\';
        'Amostra 4\A_2020-01-13\'};

fsm5 = {'Amostra 5\N_2020-01-22\';
        'Amostra 5\A_2020-01-27\';
        'Amostra 5\A_2020-01-28\';};

fpath3 = strcat(fpr,fsm3); t3 = 4; % Tempo mínimo de amaciamento esperado
fpath4 = strcat(fpr,fsm4); t4 = 0; % Tempo mínimo de amaciamento esperado
fpath5 = strcat(fpr,fsm5); t5 = 0; % Tempo mínimo de amaciamento esperado

flagLim = 0;

r = 5:1:60;
w = 10:5:45;
s = 1e-4:1e-5:5e-3;

dif = cell(3,1);

dif{1} = zeros(length(w),length(r),length(s));
dif{2} = zeros(length(w),length(r),length(s));
dif{3} = zeros(length(w),length(r),length(s));


%% Amostra 3

loadPath = strcat(fpath3,'corrente_RMS.mat');

count = cell(length(loadPath),1);
t = cell(length(loadPath),1);

for k = 1:length(loadPath)
    load(loadPath{k});
    count{k} = zeros(length(w),length(s),length(cRMS.data(cRMS.t>0)));
    for b = 1:length(w)
        for c = 1:length(s)
            dataF = singleAvgDerivative(cRMS.data(cRMS.t>0),w(b));
            
            % Faz a contagem de acordo com os parametros
            
            if abs(dataF(1))<s(c)
                count{k}(b,c,1) = 1;
            else
                count{k}(b,c,1) = 0;
            end
            
            flag = 0;
            
            for n = 2:length(dataF) 
                if abs(dataF(n))<s(c)
                    count{k}(b,c,n) = count{k}(b,c,n-1)+1;
                else
                    if flag<flagLim
                        flag = flag+1;
                    else
                        flag = 0;
                        count{k}(b,c,n) = 0;
                    end
                end
            end
            
            prog = ['Amostra 3:' newline...
                    'k :' num2str(k) '/' num2str(length(loadPath)) newline...
                    'b :' num2str(b) '/' num2str(length(w)) newline ...
                    'c :' num2str(c) '/' num2str(length(s))]; display(prog); % Mostra o processo
        end 
    end
    t{1,k} = cRMS.t(cRMS.t>0);
end

A = length(r);
B = length(w);
C = length(s);

difTemp = zeros(length(w),length(r),length(s));

for a = 1:A
    for b = 1:B
        for c = 1:C
            temp = min(t{1,1}(count{1}(b,c,:)>r(a)))-max([min(t{1,2}(count{2}(b,c,:)>r(a))),min(t{1,3}(count{3}(b,c,:)>r(a)))]);
            if isempty(temp)||(temp<t3)
                temp = NaN;
            end
            difTemp(b,a,c) = temp;
        end
    end
end

dif{1} = difTemp;



%% Amostra 4

loadPath = strcat(fpath4,'corrente_RMS.mat');

count = cell(length(loadPath),1);
t = cell(length(loadPath),1);

for k = 1:length(loadPath)
    load(loadPath{k});
    count{k} = zeros(length(w),length(s),length(cRMS.data(cRMS.t>0)));
    for b = 1:length(w)
        for c = 1:length(s)
            dataF = singleAvgDerivative(cRMS.data(cRMS.t>0),w(b));
            
            % Faz a contagem de acordo com os parametros
            
            if abs(dataF(1))<s(c)
                count{k}(b,c,1) = 1;
            else
                count{k}(b,c,1) = 0;
            end
            
            flag = 0;
            
            for n = 2:length(dataF) 
                if abs(dataF(n))<s(c)
                    count{k}(b,c,n) = count{k}(b,c,n-1)+1;
                else
                    if flag<flagLim
                        flag = flag+1;
                    else
                        flag = 0;
                        count{k}(b,c,n) = 0;
                    end
                end
            end
            
            prog = ['Amostra 4:' newline...
                    'k :' num2str(k) '/' num2str(length(loadPath)) newline...
                    'b :' num2str(b) '/' num2str(length(w)) newline ...
                    'c :' num2str(c) '/' num2str(length(s))]; display(prog); % Mostra o processo
        end
    end
    t{2,k} = cRMS.t(cRMS.t>0);
end

A = length(r);
B = length(w);
C = length(s);

difTemp = zeros(length(w),length(r),length(s));

for a = 1:A
    for b = 1:B
        for c = 1:C
            temp = min(t{2,1}(count{1}(b,c,:)>r(a)))-max([min(t{2,2}(count{2}(b,c,:)>r(a))),min(t{2,3}(count{3}(b,c,:)>r(a)))]);
            if isempty(temp)||(temp<t4)
                temp = NaN;
            end
            difTemp(b,a,c) = temp;
        end
    end
end

dif{2} = difTemp;

%% Amostra 5

loadPath = strcat(fpath5,'corrente_RMS.mat');

tend = inf;

count = cell(length(loadPath),1);
t = cell(length(loadPath),1);

for k = 1:length(loadPath)
    load(loadPath{k});
    count{k} = zeros(length(w),length(s),length(cRMS.data(cRMS.t>0)));
    for b = 1:length(w)
        for c = 1:length(s)
            dataF = singleAvgDerivative(cRMS.data(cRMS.t>0),w(b));
            
            % Faz a contagem de acordo com os parametros
            
            if abs(dataF(1))<s(c)
                count{k}(b,c,1) = 1;
            else
                count{k}(b,c,1) = 0;
            end
            
            flag = 0;
            
            for n = 2:length(dataF) 
                if abs(dataF(n))<s(c)
                    count{k}(b,c,n) = count{k}(b,c,n-1)+1;
                else
                    if flag<flagLim
                        flag = flag+1;
                    else
                        flag = 0;
                        count{k}(b,c,n) = 0;
                    end
                end
            end
            
            prog = ['Amostra 5:' newline...
                    'k :' num2str(k) '/' num2str(length(loadPath)) newline...
                    'b :' num2str(b) '/' num2str(length(w)) newline ...
                    'c :' num2str(c) '/' num2str(length(s))]; display(prog); % Mostra o processo
        end
    end
    t{3,k} = cRMS.t(cRMS.t>0);
end

A = length(r);
B = length(w);
C = length(s);

difTemp = zeros(length(w),length(r),length(s));

for a = 1:A
    for b = 1:B
        for c = 1:C
            temp = min(t{3,1}(count{1}(b,c,:)>r(a)))-max([min(t{3,2}(count{2}(b,c,:)>r(a))),min(t{3,3}(count{3}(b,c,:)>r(a)))]);
            if isempty(temp)||(temp<t5)
                temp = NaN;
            end
            difTemp(b,a,c) = temp;
        end
    end
end

dif{3} = difTemp;

%% Mapa de possibilidades

pos = ones(length(w),length(r),length(s));


for b = 1:length(w)
    for k = 1:length(dif)
        pos(b,:,:) = squeeze(pos(b,:,:))&(squeeze(dif{k}(b,:,:)>0));
    end
end

figure;

for b = 1:length(w)
    subplot(B/2,2,b);
    surf(s,r,squeeze(pos(b,:,:)),'EdgeColor','none');
    xlabel('s');
    ylabel('r');
    title(['Possibilidades, Média = ' num2str(w(b))]);
    c = colorbar;
    c.Label.String = 'Tempo [h]';
    view(2)
    caxis([0 1]);
end

%% Figuras
pos(pos==0)=NaN;

figure;

for b = 1:length(w)
    subplot(B/2,2,b);
    surf(s,r,squeeze(dif{1}(b,:,:)).*squeeze(pos(b,:,:)),'EdgeColor','none');
    xlabel('s');
    ylabel('r');
    title(['Amostra 3, Média = ' num2str(w(b))]);
    c = colorbar;
    c.Label.String = 'Tempo [h]';
    view(2)
end

figure;

for b = 1:length(w)
    subplot(B/2,2,b);
    surf(s,r,squeeze(dif{2}(b,:,:)).*squeeze(pos(b,:,:)),'EdgeColor','none');
    xlabel('s');
    ylabel('r');
    title(['Amostra 4, Média = ' num2str(w(b))]);
    c = colorbar;
    c.Label.String = 'Tempo [h]';
    view(2)
end

figure;

for b = 1:length(w)
    subplot(B/2,2,b);
    surf(s,r,squeeze(dif{3}(b,:,:)).*squeeze(pos(b,:,:)),'EdgeColor','none');
    xlabel('s');
    ylabel('r');
    title(['Amostra 5, Média = ' num2str(w(b))]);
    c = colorbar;
    c.Label.String = 'Tempo [h]';
    view(2)
end