function [ind,thrInd,TPRMax,FPRMin] = bestByFPR(Res,maxFPR)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sz = size(Res);

BestTPR = zeros(1,numel(Res));
BestiTPR = nan(1,numel(Res));

parfor k = 1:numel(Res)
    for kt = 1:length(Res(k).FPR)
        
        if (Res(k).FPR(kt)<maxFPR)&&(Res(k).TPR(kt)>BestTPR(k))
            BestTPR(k) = Res(k).TPR(kt);
            BestiTPR(k) = kt;
        end
        
    end
end

if nnz(~isnan(BestiTPR))>0
    [~,ind] = max(BestTPR);
    thrInd = BestiTPR(ind);
    TPRMax = Res(ind).TPR(thrInd);
    FPRMin = Res(ind).FPR(thrInd);
else
    ind = NaN;
    thrInd = NaN;
    TPRMax = NaN;
    FPRMin = NaN;
end
end

