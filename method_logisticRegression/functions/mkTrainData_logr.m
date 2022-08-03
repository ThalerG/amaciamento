function [data,t] = mkTrainData_logr(dataInit, tInit, N, M, D, tEst, minT)

t = tInit(tInit>0);
dataCut = dataInit(tInit>0);
dataCut = dataCut(t<=minT);

t = t(((N-1)*D+1):end);
% if tEst > minT
%     L = length(nonzeros(t<=tEst));
%     t = t(1:2*L);
% else
    t = t(t<=minT);
% end

dataCut = movmean(dataCut,[M-1,0]);

data = nan(length(dataCut)-(N-1)*D,N);

for n = 1:N
    data(:,n) = dataCut(((N-n)*D+1):(end-(n-1)*D));
end

data = data(1:length(t),:);

end

