function Mdl = treinaModeloFitCL(Xobs,Yres,k,Lambda)
%TREINAMODELO Summary of this function goes here
%   Detailed explanation goes here

rng(10);
Mdl = fitclinear(Xobs,Yres, 'KFold',k,...
                    'Learner','logistic','Solver','sparsa');

end

