pD = [];
pS = [];

SPDA = 14.7; SPSA = 1.148;

for k1 = 3:length(EnDataA)
    for k2 = 1:length(EnDataA{k1})
        pD = [pD;EnDataA{k1}(k2).pD(EnDataA{k1}(k2).tempo>1)];
        pS = [pS;EnDataA{k1}(k2).pS(EnDataA{k1}(k2).tempo>1)];
    end
end

% Descarta 2 outliers
pD = sort(pD); pDAMax = pD(end-3); pDAMin = pD(3);
pS = sort(pS); pSAMax = pS(end-3); pSAMin = pS(3);

writematrix([pD,pS],'ModeloA.txt');

pD = [];
pS = [];

SPDB = 7.616; SPSB = 0.626;

for k1 = 1:length(EnDataB)
    for k2 = 1:length(EnDataB{k1})
        pD = [pD;EnDataB{k1}(k2).pD(EnDataB{k1}(k2).tempo>1)];
        pS = [pS;EnDataB{k1}(k2).pS(EnDataB{k1}(k2).tempo>1)];
    end
end

writematrix([pD,pS],'ModeloB.txt');

ErDAMax = (pDAMax-SPDA)/SPDA; ErDAMin = (pDAMin-SPDA)/SPDA;
ErDBMax = (pDBMax-SPDB)/SPDB; ErDBMin = (pDBMin-SPDB)/SPDB;

ErSAMax = (pSAMax-SPSA)/SPSA; ErSAMin = (pSAMin-SPSA)/SPSA;
ErSBMax = (pSBMax-SPSB)/SPSB; ErSBMin = (pSBMin-SPSB)/SPSB;