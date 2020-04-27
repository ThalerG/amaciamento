function xF = moving_stddeviation(x,w)

L = length(x);
xF = zeros(1,L);

n2 = floor(w/2);

for k = 1:L
    if (k<=n2) && (k>(L-n2))
        xF(k) = std(x);
    elseif k<=n2
        xF(k) = std(x(1:(k+n2)));
    elseif k>(L-n2)
        xF(k) = std(x((k-n2):end));
    else
        xF(k) = std(x((k-n2):(k+n2)));
    end
end