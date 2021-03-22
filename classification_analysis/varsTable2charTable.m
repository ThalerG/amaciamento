function [ctable] = varsTable2charTable(vtable)

names = table2array(vtable(:,1));
n = {};

for k = 1:length(names)
    n = unique([n, names{k}]);
end

for kn = 1:length(n)
    for k = 1:length(names)
        if ~any(strcmp(names{k},n{kn}))
            C(k,kn) = ' ';
        else
            C(k,kn) = 'X';
        end
    end
end

C = array2table(C); 
C.Properties.VariableNames = n;
ctable = [C,vtable(:,2:end)];

end

