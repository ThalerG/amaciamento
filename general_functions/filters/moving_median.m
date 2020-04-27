function xF = moving_median(x,n)

L = length(x);
xF = zeros(1,L);

n2 = floor(n/2);

for k = 1:L
    if (k<=n2) && (k>(L-n2))
        xF(k) = median(x);
    elseif k<=n2
        xF(k) = median(x(1:(k+n2)));
    elseif k>(L-n2)
        xF(k) = median(x((k-n2):end));
    else
        xF(k) = median(x((k-n2):(k+n2)));
    end
end