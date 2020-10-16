function [input,output] = mkTrainData_lr(dataInit, tInit, W, M, tEst, minT)

t = tInit(tInit>0);
dataInit = dataInit(tInit>0);


t = t(((W-1)*D+1):end);
if tEst > minT
    L = length(nonzeros(t<=tEst));
    t = t(1:2*L);
else
    t = t(t<minT);
end

dataInit = movmean(dataInit,[M-1,0]);

data = nan(length(dataInit)-(W-1)*D,W);

for n = 1:W
    data(:,n) = dataInit(((W-n)*D+1):(end-(n-1)*D));
end

data = data(1:length(t),:);

end


end

