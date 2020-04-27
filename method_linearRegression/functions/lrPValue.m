function p = lrPValue(x,w)
%lrPValue Returns the p-values of the linear regression of x with window
%length w
%   

t = 1:length(x);
p = zeros(1,length(x));

for k = w:length(x)
    [~,~,~,~,stats] = regress(t((k-w+1):k)',[ones(w,1), x((k-w+1):k)]);
    p(k) = stats(3);
end

end

