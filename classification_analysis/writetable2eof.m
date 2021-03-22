function writetable2eof(fid,table)
% WRITETABLE2EOF Formata e salva uma tabela em um arquivo aberto

varNames = table.Properties.VariableNames; % Extrai nomes da tabela


% Primeira coluna
hd = varNames{1};
val = table2array(table(:,1)); % Extrai valores da tabela
if isnumeric(val)
    val = num2str(val);
elseif iscell(val)
    val = char(val);
end

szMax = max([size(val,2),size(hd,2)]);
tr = repmat('_',1,szMax); % Traço horizontal para separar cabeçalho
col = char(hd,tr,val);
cel = cellstr(col); cel = strrep(cel,' ','');

for kel = 1:size(col,1) % Formata linhas e espaçamento
    cel{kel} = [repmat(' ',1,floor((szMax-length(cel{kel}))/2)+1),cel{kel},repmat(' ',1,ceil((szMax-length(cel{kel}))/2)+1)];
end

tbStr = char(cel);

% Próximas colunas
for k = 2:length(varNames)
    hd = varNames{k};
    
    val = table2array(table(:,k)); % Extrai valores da tabela
    if isnumeric(val)
        val = num2str(val);
    elseif iscell(val)
        val = char(val);
    end
    
    szMax = max([size(val,2),size(hd,2)]);
    tr = repmat('_',1,max([size(val,2),size(hd,2)]));  % Traço horizontal para separar cabeçalho
    col = char(hd,tr,val);
    
    cel = cellstr(col); cel = strrep(cel,' ','');

    for kel = 1:size(col,1) % Formata linhas e espaçamento
        cel{kel} = ['| ', repmat(' ',1,ceil((szMax-length(cel{kel}))/2)),cel{kel},repmat(' ',1,floor((szMax-length(cel{kel}))/2)+1)];
    end
    
    tbStr = [tbStr,char(cel)];
end

tbStr = strcat(tbStr,'\n'); % Fim das linhas

fprintf(fid,reshape(tbStr',1,[])); % Formata em uma linha só e salva no arquivo

end

