function [predict,score] = predict_stats(X, method, param)

switch method
    case 'testT'
        ALPHA = param{4};
        
        score = arrayfun(@(ROWIDX) lrPValue(X(ROWIDX,:)), (1:size(X,1)).');
        predict = score>ALPHA;
    case 'spcDif'
        dMax = param{3}; % Maximum tolerated difference
        
        score = abs(X(:,2)-X(:,1));
        predict = score<dMax;
    case 'RstatsH'
        Rc = param{4};
        
        score = X;
        predict = X<Rc;
    case 'RstatsTb'
        L1 = param{1};
        L23 = param{2};
        ALPHA = param{3}; % Significance level
        
        T = load('criticalR.mat','T'); % Loads the critical R values table (T);
        T = T.T;
        Rc = T(T(:,1)==L1 & T(:,2)==L23 & T(:,3)==L23 & T(:,4)==ALPHA,5);
        score = X;
        predict = X<Rc;
end


end