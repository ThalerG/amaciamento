thr = 0:0.001:1;

for k = 1:length(thr)
    gtest = prob>=thr(k);
    cMat = confusionmat(grup,gtest);
    TPR(k) = cMat(1,1)/sum(cMat(:,1));
    FPR(k) = cMat(1,2)/sum(cMat(:,2));
end

% TPR(isnan(TPR)) = 1;
% FPR(isnan(FPR)) = 0;

p = plot(FPR,TPR); xlim([0 1]); ylim([0 1]);
row = dataTipTextRow('Thr',thr);
p.DataTipTemplate.DataTipRows(end+1) = row;
ylabel('True Positive Rate TP/(TP+FN)');
xlabel('False Positive Rate FP/(FP+TN)');