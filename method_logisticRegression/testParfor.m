for k = 1:1
    [B,dev,stats] = mnrfit(classCor,classAmac);
end
%%

parfor k = 1:1
    [Bpar,devpar,statspar] = mnrfit(classCor,classAmac);
    parsave('method_logisticRegression\Bpar.mat',Bpar);
end