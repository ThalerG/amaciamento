function B = treinaMnrfit(Xobs,Yres)
%TREINAMODELO Summary of this function goes here
%   Detailed explanation goes here

rng(10);
Yres = categorical(Yres);
[B,~,~] = mnrfit(Xobs,Yres);

end
