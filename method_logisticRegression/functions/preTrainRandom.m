function [classCor,classAmac,varargout] = preTrainRandom(EnData,tEst,N,M,D,minT,varNames,percTest)

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
            switch char(var)
                case 'cRMS'
                    [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).cRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                case 'cKur'
                    [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).cKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                case 'vInfRMS'
                    [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vInfRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                case 'vInfKur'
                    [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vInfKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                case 'vSupRMS'
                    [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vSupRMS,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                case 'vSupKur'
                    [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vSupKur,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                case 'vaz'
                    [temp(:,N*c+1:N*(c+1)),tempo] = mkTrainData_logr(EnData{k1}(k2).vaz,EnData{k1}(k2).tempo,N,M,D,tEst{k1}(k2), minT);
                otherwise
                    error([char(var) 'is not a valid variable name. Valid variable names include cRMS, cKur, vInfRMS, vInfKur, vSupRMS, vSupKur, vaz']);
            end
            c = c+1;
        end
        
        classTemp = strings(length(temp(:,1)),1);
        classTemp(tempo<tEst{k1}(k2)) = 'nao_amaciado';
        classTemp(tempo>=tEst{k1}(k2)) = 'amaciado';
        classCor = [classCor;temp];
        classAmac = [classAmac;classTemp];
    end

end

%classAmac = categorical(classAmac);
classAmac = classAmac == 'amaciado';

if nargout == 3
    varargout{1} = tempo;
end

end

