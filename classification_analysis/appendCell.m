function appended = appendCell(cell1,cell2)

Lx = length(cell1);
Ly = length(cell2);
appended = cell((Lx*Ly),1);

for kx = 1:Lx
    for ky = 1:Ly
        elx = cell1(kx);
        ely = cell2(ky);
        if isempty(elx{:}) && isempty(ely{:})
            appended{Ly*(kx-1)+ky} = {};
        elseif isempty(elx{:})
            appended{Ly*(kx-1)+ky} = cellstr(ely{:});
        elseif isempty(ely{:})
            appended{Ly*(kx-1)+ky} = cellstr(elx{:});
        else
            appended{Ly*(kx-1)+ky} = [cellstr(elx{:}),cellstr(ely{:})];
        end
    end
end