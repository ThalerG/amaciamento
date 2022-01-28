function [Rtrain,Ytrain,Rtest,Ytest, tTrain, tTest] = rStats_preproc_data(EnData,tEst,L1,L2,L3,conjVal,varName)

if isempty(tEst)
    for k = 1:length(EnData)
        tEst{k} = 10*ones(size(EnData{k}));
    end
end

for k1 = 1:size(conjVal,1) % Separa conjunto de treino e de teste
    tEstTest{1}(k1) = tEst{conjVal(k1,1)}(conjVal(k1,2));
    EnDataTest{1}(k1) = EnData{conjVal(k1,1)}(conjVal(k1,2));
    tEst{conjVal(k1,1)}(conjVal(k1,2)) = [];
    EnData{conjVal(k1,1)}(conjVal(k1,2)) = [];
end

[Rtrain,Ytrain,tTrain] = preTrainR(EnData,tEst,L1,L2,L3,varName);
[Rtest,Ytest,tTest] = preTrainR(EnDataTest,tEstTest,L1,L2,L3,varName);



end


function [R,Y,tempo] = preTrainR(EnData,tEst,L1,L2,L3,varName)

R = [];
Y = [];
tempo = [];
for k1 = 1:length(EnData)
    for k2 = 1:length(EnData{k1})
        var = varName{1};

        if ~(((strcmp(EnData{k1}(k2).name(1:10),"Amostra B5"))&&(any(strcmp(varName,"vaz"))))||... % Ensaios com falhas nos dados
             ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B7"))&&(any(strcmp(varName,"cRMS"))))||...
             ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(any(strcmp(varName,"vInfRMS"))))||...
             ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(any(strcmp(varName,"vInfKur"))))||...
             ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(any(strcmp(varName,"vInfVar"))))||...
             ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(any(strcmp(varName,"vSupRMS"))))||...
             ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(any(strcmp(varName,"vSupKur"))))||...
             ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(any(strcmp(varName,"vSupVar")))))
            t = EnData{k1}(k2).tempo;
            switch char(var)
                case 'cRMS'
                    x = EnData{k1}(k2).cRMS;
                case 'cKur'
                    x = EnData{k1}(k2).cKur;
                case 'cVar'
                    x = EnData{k1}(k2).cVar;
                case 'vInfRMS'
                    x = EnData{k1}(k2).vInfRMS;
                case 'vInfKur'
                    x = EnData{k1}(k2).vInfKur;
                case 'vInfVar'
                    x = EnData{k1}(k2).vInfVar;
                case 'vSupRMS'
                    x = EnData{k1}(k2).vSupRMS;
                case 'vSupKur'
                    x = EnData{k1}(k2).vSupKur;
                case 'vSupVar'
                    x = EnData{k1}(k2).vSupVar;
                case 'vaz'
                    x = EnData{k1}(k2).vaz;
                otherwise
                    error([char(var) 'is not a valid variable name. Valid variable names include cRMS, cKur, vInfRMS, vInfKur, vSupRMS, vSupKur, vaz']);
            end
            xf = zeros(length(x),1); % Weighted average data
            v = zeros(length(x),1); % Filtered difference between averaged and original data
            d = zeros(length(x),1); % Filtered difference between sequential data
            Rtemp = zeros(length(x),1); % Ratio of variances
            Ytemp = zeros(length(x),1);
            
            xf(1) = x(1); v(1) = 0; d(1) = 0; Rtemp(1) = 0;

            for k = 2:length(x)
                xf(k) = L1*x(k)+(1-L1)*xf(k-1);
                v(k) = L2*(x(k)-xf(k-1))^2+(1-L2)*v(k-1);
                d(k) = L3*(x(k)-x(k-1))^2+(1-L3)*d(k-1);
                Rtemp(k) = (2-L1)*v(k)/d(k);
            end

        end
        if ~isempty(Rtemp)
            Ytemp = strings(length(Rtemp),1);
            R = [R;Rtemp];
            Ytemp(t<tEst{k1}(k2)) = 'nao_amaciado';
            Ytemp(t>=tEst{k1}(k2)) = 'amaciado';
            Y = [Y;Ytemp];
            tempo = [tempo;t];
            Rtemp = [];
        end
    end

end

%Y = categorical(Y);
Y = strcmp(Y,'amaciado');

end

