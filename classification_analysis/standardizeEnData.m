function [EnStd] = standardizeEnData(EnData,vars)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

allVars = [];
EnStd = EnData;

for k1 = 1:length(EnData)
    for k2 = 1:length(EnData{k1})
        temp = nan(length(EnData{k1}(k2).tempo),length(vars)+2);
        for k3 = 1:length(vars)
            temp(:,k3) = EnData{k1}(k2).(vars{k3});
        end
        temp(:,length(vars)+1) = k1;
        temp(:,length(vars)+2) = k2;
        allVars = [allVars;temp];
    end
end

allVars(:,1:(end-2)) = normalize(allVars(:,1:(end-2)));

for k1 = 1:length(EnData)
    for k2 = 1:length(EnData{k1})
        for k3 = 1:length(vars)
            EnStd{k1}(k2).(vars{k3}) = allVars((allVars(:,end-1)==k1)&(allVars(:,end)==k2),k3);
        end
    end
end

end

