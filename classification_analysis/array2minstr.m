function str = array2minstr(array)
%ARRAY2MINSTR Converte array sequencial para uma string reduzindo
% espašamentos iguais

array = sort(array);
d0 = array(2) - array(1);

str = ['[',num2str(array(1))];


f = 0;

for k = 2:(length(array))
    
    if k == (length(array))
        if f == 0
            str = [str, ', ', num2str(array(k)), ']'];
        elseif f == 1
            str = [str, ', ', num2str(array(k-1)), ', ', num2str(array(k)) ']'];
        else
            str = [str, ':', num2str(d0), ':', num2str(array(k)),']'];
        end
        break
    end
    
    d = array(k+1)-array(k);
    
    if d == d0
        if f <2
            f = f + 1;
        end
    else
        if f == 0
            str = [str, ', ', num2str(array(k))];
        elseif f == 1
            str = [str, ', ', num2str(array(k-1)), ', ', num2str(array(k))];
        else
            str = [str, ':', num2str(d0), ':', num2str(array(k)), ', ', num2str(array(k+1))];
        end
        f = 0;
    end
    d0 = d;
end

