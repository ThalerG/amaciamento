% An�lise automatizada de m�todos n�o-supervisionados

clear; close all;

fold = 'D:\Documentos\Amaciamento\Clusteriza��es\Dissertacao - Modelo A\';
fold = dir(fold); fold = fold(3:end);
am = regexp({fold.name},'.\d*_','match'); am = unique([am{:}]);

results = cell(length(am),1);

for k1 = 1:length(am)
    names = regexp({fold.name},strcat(am(k1),'.*'),'match');
    am{k1} = upper(am{k1}(1:(end-1)));
    names = [names{:}];
    for k2 = 1:length(names)
        if ~isempty(names(k2))
            N = regexp(names{k2},'_N.*.csv','match');
            N = str2double(N{1}(3:(end-4)));
            F = strcat(fold(1).folder,'\',names{k2});
            r = importClustersV2(F,am{k1},N);
            results{k1} = [results{k1};r];
        end
    end
end

clear r N F r names fold;

% N�mero de clusters
nClus = 3;

% Janela p/ propor��o
windows = [0.5,1,1.5,2];

% M�todos de detec��o
methods = {'GThr','LThr','Dom','First'};  

% Par�metros de busca para cada m�todo
paramMethod = [{0.1:0.1:1},{0:0.1:0.9},{NaN},{0:0.1:0.9}];

resultadosTotal.Grandeza = ''; resultadosTotal.N = NaN; resultadosTotal.M = NaN; resultadosTotal.D = NaN; resultadosTotal.Window = NaN;
resultadosTotal.Param = []; resultadosTotal.Pass = false; resultadosTotal.Method = ''; resultadosTotal.TimeDetect = {}; resultadosTotal.Obs = {}; resultadosTotal.Cluster = NaN;
resultadosTotal = struct2table(resultadosTotal,'AsArray',true); resultadosTotal(1,:) = [];

numIt = 1;

for k = 1:length(methods)
    numIt = numIt + length(paramMethod{k});
end

numIt = numIt*height(results{1})*length(windows)*nClus;
it = 0;

f = waitbar(0);

for kgr = 1:height(results{1}) % Para cada grandeza
    
    rOr = table2struct(results{1}(1,:));
    rOr = repmat(rOr,length(results),1); % Valores originais
    
    for kam = 1:length(results) % Para cada amostra
        rOr(kam) = table2struct(results{kam}(kgr,:));
    end
    
    for kw = 1:length(windows) % Para cada janelamento
        w = windows(kw);
        
        res.Pass = false; res.TimeDetect = []; res.Obs = ''; res.Cluster = []; % Formato da an�lise
        res.Method = ''; res.Param = [];
        
        for km = 1:length(methods)
            for kp = 1:length(paramMethod{km})
                for kc = 1:nClus
                    for kam = 1:length(rOr)
                        [~,~,prop] = orderClusters(rOr(kam),w);
                        switch methods{km}
                            case 'GThr'
                                resP(kam) = detect_GThr(prop.Proportion,prop.Time,prop.Ensaio,kc,paramMethod{km}(kp));
                            case 'LThr'
                                resP(kam) = detect_LThr(prop.Proportion,prop.Time,prop.Ensaio,kc,paramMethod{km}(kp));
                            case 'Dom'
                                resP(kam) = detect_Dom(prop.Proportion,prop.Time,prop.Ensaio,kc);
                            case 'First'
                                resP(kam) = detect_First(prop.Proportion,prop.Time,prop.Ensaio,kc,paramMethod{km}(kp));
                            otherwise
                                error('M�todo desconhecido')
                        end
                        r.TimeDetect{kam} = resP(kam).TimeDetect;
                        r.Obs{kam} = resP(kam).Obs;
                    end
                    r.Pass = all([resP.Pass]);
                    r.Method = methods{km}; r.Param = paramMethod{km}(kp);
                    r.Window = w; r.N = rOr(1).N; r.M = rOr(1).M; r.D = rOr(1).D;
                    r.Grandeza = rOr.Grandeza;          
                    r.Cluster = kc;
                    
                    r = struct2table(r);
                    resultadosTotal = [resultadosTotal;r];
                    clear r;
                    
                    it = it + 1;
                    waitbar(it/numIt);
                end
            end
        end
        
    end
end
temp = table(repmat({am},height(resultadosTotal),1), 'VariableNames', {'Amostra'});
resultadosTotal = [resultadosTotal,temp];
gg = resultadosTotal(resultadosTotal.Pass == true,:);

tAmac = nan(height(gg),length(resultadosTotal.TimeDetect(1)));
tJaAmac = nan(height(gg),length(resultadosTotal.TimeDetect(1)));

for k1 = 1:height(gg)
    TDec = gg.TimeDetect(k1,:);
    for k2 = 1:length(TDec)
        TimeAmac = TDec{k2};
        tAmac(k1,k2) = TimeAmac(1);
        tJaAmac(k1,k2) = max(TimeAmac(2:3));
    end
end

ggGr = gg(min(tAmac,[],2)>=4,:);
tAmacGr = tAmac(min(tAmac,[],2)>=4,:);