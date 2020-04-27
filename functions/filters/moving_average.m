function xF = moving_average(x,n)

L = length(x);
xF = zeros(1,L);

n2 = floor(n/2);

for k = 1:L
    if (k<=n2) && (k>(L-n2))
        xF(k) = mean(x);
    elseif k<=n2
        xF(k) = mean(x(1:(k+n2)));
    elseif k>(L-n2)
        xF(k) = mean(x((k-n2):end));
    else
        xF(k) = mean(x((k-n2):(k+n2)));
    end
end