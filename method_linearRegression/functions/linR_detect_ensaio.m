function [amaciado, varargout] = linR_detect_ensaio(data,alpha)
%LINR_DETECT_ENSAIO Detects run-in based on linear regression
%   amaciado = linR_detect_ensaio(data,alpha)
%   [amaciado, pVal] = linR_detect_ensaio(data,alpha)
%   data contains one or more sample windows to test for run-in, from
%   latest to oldest.
%   alpha is the significance level to be used

pVal = arrayfun(@(ROWIDX) lrPValue(data(ROWIDX,:)), (1:size(data,1)).'); % Evaluates the p-value for the null-slope hypothesis for each row
amaciado = pVal>=alpha; % If the p-value is greater than the significance, accept the null hypothesis

if nargout > 1
    varargout{1} = pVal;
end

end

