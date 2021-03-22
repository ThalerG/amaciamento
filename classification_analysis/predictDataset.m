function [label,score] = predictDataset(trainedClassifier, Xtest)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

[label,score] = predict(trainedClassifier.model,Xtest);

if size(score,2) > 1
    score = score(:,2);
end

end

