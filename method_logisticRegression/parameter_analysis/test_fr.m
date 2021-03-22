clear all; close all; clc;

fLogr = "D:\Documentos\Amaciamento\Ferramentas\Arquivos Gerados\logR_parameters201020_1314\Results.mat";

load(fLogr);

maxFPR = 0.05;
minTPR = 0.85;

n = 1;
for k = 1:numel(Res)
    if nnz((Res(k).TPR>minTPR)&(Res(k).FPR<maxFPR))>0
        [mInd(1), mInd(2), mInd(3)] = ind2sub(size(Res),k);
        L(n).N = N(mInd(1));
        L(n).M = M(mInd(2));
        L(n).D = D(mInd(3));
        T(n).thr = thr((Res(k).TPR>minTPR)&(Res(k).FPR<maxFPR));
        n = n+1;
    end
end

clear Res N M D;

F = 0:10;
R = [1:4 5:5:100];
FTPR = cell(length(L),1);
FFPR = cell(length(L),1);

for k = 1:length(L)
    minT = 10; % Número mínimo de horas considerado por ensaio (normalmente é 2*tEst)

    [Xobs,Yres] = preTrain(EnData,tEst, L(k).N, L(k).M, L(k).D, minT);

    B = treinaMnrfit(Xobs,Yres);
    prob = mnrval(B,Xobs);
    prob = prob(:,2);
    
    for k1 = 1:length(T(k).thr)
        FTPR{k} = nan(length(T(k).thr),length(F),length(R));
        TTPR{k} = nan(length(T(k).thr),length(F),length(R));
        display([num2str(k),'/',num2str(length(L)),';',num2str(k1),'/',num2str(length(T(k).thr))]);
        for f = 1:length(F)
            s = zeros(1,length(prob));
            flag = 0;
            
            if prob(1)>T(k).thr(k1)
                s(1) = 1;
            end
            
            for n = 2:length(prob)
                if prob(n)>T(k).thr(k1)
                    s(n) = s(n-1)+1;
                else
                    if flag>=F(f)
                        s(n) = 0;
                        flag = 0;
                    else
                        flag = flag+1;
                    end
                end
            end
            
            for r = 1:length(R)
                classPred = s>=R(r);
                cMat = confusionmat(Yres,classPred);
                FTPR{k}(k1,f,r) = cMat(1,1)/sum(cMat(:,1));
                FFPR{k}(k1,f,r) = cMat(1,2)/sum(cMat(:,2));
            end
        end
    end
end