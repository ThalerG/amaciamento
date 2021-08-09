% Análise automatizada de métodos não-supervisionados

clear; close all;

% Extrai dados dos arquivos
results{1} = importClusters('amostra3_clusters.csv',3);
results{2} = importClusters('amostra4_clusters.csv',4);
results{3} = importClusters('amostra5_clusters.csv',5);

% Número de clusters
nClus = 3;

% Janela p/ proporção
windows = [0.5,1,1.5,2];

% Métodos de detecção
methods = {'GThr','LThr','Dom','First'};

% Parâmetros de busca para cada método
paramMethod = [{0.1:0.1:1},{0:0.1:0.9},{NaN},{0:0.1:0.9}];

t.Grandeza = ''; t.N = NaN; t.M = NaN; t.D = NaN; t.Window = NaN;
t.Param = []; t.Pass = false; t.Method = ''; t.TimeDetect = {}; t.Obs = {}; t.Cluster = NaN;
t = struct2table(t,'AsArray',true); t(1,:) = [];

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
        
        res.Pass = false; res.TimeDetect = []; res.Obs = ''; res.Cluster = []; % Formato da análise
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
                                error('Método desconhecido')
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
                    t = [t;r];
                    clear r;
                    
                    it = it + 1;
                    waitbar(it/numIt);
                end
            end
        end
        
    end
end
        
gg = t(t.Pass == true,:);

tAmac = nan(height(gg),length(t.TimeDetect(1)));

for k1 = 1:height(gg)
    TDec = gg.TimeDetect(k1,:);
    for k2 = 1:length(TDec)
        TimeAmac = TDec{k2};
        tAmac(k1,k2) = TimeAmac(1);
    end
end

