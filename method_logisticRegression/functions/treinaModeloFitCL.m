function Mdl = treinaModeloFitCL(Xobs,Yres,k,Lambda)
%TREINAMODELO Summary of this function goes here
%   Detailed explanation goes here
Xobs = Xobs';
rng(10);

Mdl = fitclinear(Xobs,Yres,'ObservationsIn','columns','KFold',k,...
    'Learner','logistic','Solver','sparsa','Regularization','lasso',...
    'Lambda',Lambda,'GradientTolerance',1e-8);

end

