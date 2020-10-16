clear; % close all;

load('D:\Documentos\Amaciamento\Ferramentas\ProjetoMatlab\method_logisticRegression\test_2020_09_25\EnData.mat');

conjVal = [2,1;4,2;5,3]; % Ensaios reservados para conjunto de validação [Amostra, ensaio]

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

       
for k1 = 1:size(conjVal,1) % Apaga os valores dos conjuntos de validação
    tEst{conjVal(k1,1)}(conjVal(k1,2)) = [];
    EnData{conjVal(k1,1)}(conjVal(k1,2)) = [];
end

N = 9;
M = 90;
D = 15;
thr = 0.4750;

minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)

B = [12771.6997638537;
392.457775552141;
-257.685018636316;
107.076481313842;
89.0547898656484;
-976.529280223602;
1597.87937539045;
-12.2063258488948;
877.081536621744;
-1285.70777798890;
-925.954178558473;
-3381.42748779433;
-258.916446950981;
-2606.35999603357;
-544.943641770681;
-3786.21733805390;
1124.03805340895;
-3950.36685532856;
5559.32033420557;
-277.143514558431;
666.488700239053;
-954.759128726748;
-9.01625333548548;
297.125608648134;
-187.831722412460;
-213.744739117790;
1152.65960406920;
-885.917580365803;
7.66412385440887;
-11.8481291344444;
-17.6013146839229;
23.0489898917924;
3.53321519724754;
-7.83192728846659;
-1.72055535687440;
-30.1037347111254;
20.9416442020404;
-304.087501254857;
-1459.17002770346;
2392.57346812316;
-128.068648251818;
-151.721056453933;
16.8933829751206;
101.361459060100;
-2272.40930022316;
2250.67840681950;
9.68209463817577;
4.16188048552100;
3.90750946367891;
-10.0510764828990;
14.6640514871650;
-16.2626884341644;
16.4286876247965;
0.494615527872454;
4.05251739773159;
9.96418891853719;
3.14096302681738;
4.96566158779484;
-2.92007797634099;
5.47047846951205;
20.5989353109863;
16.2520978608472;
5.41546791165076;
4.44454266387616];

for k1 = 1:length(EnData)
    figure;
    
    for k2 = 1:length(EnData{k1})
        temp = [];
        [temp(:,1:N),~] = mkTrainData(EnData{k1}(k2).cRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*1+1:N*2),~] = mkTrainData(EnData{k1}(k2).cKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*2+1:N*3),~] = mkTrainData(EnData{k1}(k2).vInfRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*3+1:N*4),~] = mkTrainData(EnData{k1}(k2).vInfKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*4+1:N*5),~] = mkTrainData(EnData{k1}(k2).vSupRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*5+1:N*6),~] = mkTrainData(EnData{k1}(k2).vSupKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
        [temp(:,N*6+1:N*7),tempo] = mkTrainData(EnData{k1}(k2).vaz,EnData{k1}(k2).tempo,N,1,D,tEst{k1}(k2), minT);
        classTemp = strings(length(temp(:,1)),1);
        classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
        classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
        subplot(length(EnData{k1}),1,k2)
        classCor = temp;
        prob = mnrval(B,classCor);
        prob = prob(:,2);
        plot(tempo,prob)
        line([tEst{k1}(k2),tEst{k1}(k2)],[0,1],'Color','black','LineStyle','--');
        line([tempo(1),tempo(end)],[thr,thr],'Color','red','LineStyle','--');
        xlim([tempo(1), tempo(end)]); ylim([0,1]);
    end
    sgtitle(['Amostra ',num2str(k1)]);
end
