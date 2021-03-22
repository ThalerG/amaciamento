data2table;

YrFS = double(Yres);
YrFS(YrFS==0) = -1;
alpha = 0.5; sup = 1;
numF = size(Xobs,2);

% % infFS
% [ranking, w] = infFS( Xobs , YrFS , alpha , sup , 0 );

% % fisher
% ranking = spider_wrapper(Xobs,YrFS,numF,'fisher');

% % mRMR
ranking = mRMR(Xobs,YrFS,numF);

rankedVar = varnames(ranking);

trainFineTree

