function p = lrPValue(x)
%lrPValue Returns the p-values of the linear regression of x with window
%length w
%   

t = 1:length(x);

[~,~,~,~,stats] = regress(t',[ones(length(x),1), x']);
p = stats(3);

end

