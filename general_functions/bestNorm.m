function [ind,thrInd,TPRMax,FPRMin] = bestNorm(Res)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sz = size(Res);

Best = nan(1,numel(Res));
Besti = nan(1,numel(Res));

parfor k = 1:numel(Res)
    norma2 = arrayfun(@(x,y) sqrt((1-x)^2+y^2),Res(k).TPR,Res(k).FPR);
    [Best(k),Besti(k)] = min(norma2);
end

[~,ind] = min(Best);
thrInd = Besti(ind);
TPRMax = Res(ind).TPR(thrInd);
FPRMin = Res(ind).FPR(thrInd);

end

