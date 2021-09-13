function [classCor,classAmac,varargout] = preTrain(EnData,tEst,N,M,D,minT,varNames)

if isempty(tEst)
    for k = 1:length(EnData)
        tEst{k} = 10*ones(size(EnData{k}));
    end
end

if nargin <7
    varNames = {'cRMS', 'cKur', 'vInfRMS', 'vInfKur', 'vSupRMS', 'vSupKur', 'vaz'};
end
classAmac = [];
classCor = [];

for k1 = 1:length(EnData)

    for k2 = 1:length(EnData{k1})
        temp = []; c = 0;
        for v = 1:length(varNames)
            var = varNames{v};
            if ~(((strcmp(EnData{k1}(k2).name(1:10),"Amostra B5"))&&(strcmp(char(var),"vaz")))||... % Ensaios com falhas nos dados
                 ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B7"))&&(strcmp(char(var),"cRMS")))||...
                 ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(strcmp(char(var),"vInfRMS")))||...
                 ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(strcmp(char(var),"vInfKur")))||...
                 ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(strcmp(char(var),"vInfVar")))||...
                 ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(strcmp(char(var),"vSupRMS")))||...
                 ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(strcmp(char(var),"vSupKur")))||...
                 ((strcmp(EnData{k1}(k2).name(1:10),"Amostra B8"))&&(strcmp(char(var),"vSupVar"))))
                switch char(var)
                    case 'cRMS'
                        [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).cRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                    case 'cKur'
                        [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).cKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                    case 'cVar'
                        [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).cVar,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                    case 'vInfRMS'
                        [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vInfRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                    case 'vInfKur'
                        [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vInfKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                    case 'vInfVar'
                        [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vInfVar,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                    case 'vSupRMS'
                        [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vSupRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                    case 'vSupKur'
                        [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vSupKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                    case 'vSupVar'
                        [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vSupVar,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                    case 'vaz'
                        [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vaz,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                    otherwise
                        error([char(var) 'is not a valid variable name. Valid variable names include cRMS, cKur, vInfRMS, vInfKur, vSupRMS, vSupKur, vaz']);
                end
                c = c+1;
            end
        end
        
        if ~isempty(temp)
            classTemp = strings(length(temp(:,1)),1);
            classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
            classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
            classCor = [classCor;temp];
            classAmac = [classAmac;classTemp];
        end
    end

end

%classAmac = categorical(classAmac);
classAmac = strcmp(classAmac,'amaciado');

if nargout == 3
    varargout{1} = tempo;
end

end

