% SVM Gauss

Comb(1).N = 4;
Comb(2).N = 5;
Comb(3).N = 4;
Comb(4).N = 4;
Comb(5).N = 5;
Comb(6).N = 5;
Comb(7).N = 3;
Comb(8).N = 5;
Comb(9).N = 5;
Comb(10).N = 3;

Comb(1).M = 60;
Comb(2).M = 100;
Comb(3).M = 70;
Comb(4).M = 100;
Comb(5).M = 90;
Comb(6).M = 70;
Comb(7).M = 180;
Comb(8).M = 60;
Comb(9).M = 110;
Comb(10).M = 130;

Comb(1).D = 60;
Comb(2).D = 40;
Comb(3).D = 60;
Comb(4).D = 60;
Comb(5).D = 40;
Comb(6).D = 40;
Comb(7).D = 60;
Comb(8).D = 40;
Comb(9).D = 40;
Comb(10).D = 90;

for k = 1:length(Comb)
    Comb(k).vars = {'cRMS', 'cKur', 'cVar', 'vaz'};
end
