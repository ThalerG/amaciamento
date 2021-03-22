function [ROC_AUC, fBeta, MMC] = performanceMetrics(responseLabel, prediction, score, beta)

if nargin < 4
    beta = 1;
end

if size(prediction,2) > 1
    prediction = prediction(:,2);
end

if size(score,2) > 1
    score = score(:,2);
end

C = confusionmat(responseLabel, prediction);

TP = C(1,1);
TN = C(2,2);
FP = C(1,2);
FN = C(2,1);

MMC = (TP*TN - FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
fBeta = (1+beta^2)*TP/((1+beta^2)*TP + beta^2*FN +FP);
[~,~,~,ROC_AUC] = perfcurve(responseLabel,score,1);
