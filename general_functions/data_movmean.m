function [dataFilt] = data_movmean(Data,w)
t = Data.t(Data.t>0);
dataF = Data.data(Data.t>0);

dataFilt.data = movmean(dataF,[w-1,0]);
dataFilt.t = t;

end

