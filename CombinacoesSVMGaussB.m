% SVM Gauss

Comb(1).N = 4;
Comb(2).N = 3;
Comb(3).N = 3;
Comb(4).N = 3;
Comb(5).N = 2;
Comb(6).N = 3;
Comb(7).N = 3;
Comb(8).N = 5;
Comb(9).N = 4;
Comb(10).N = 5;

Comb(1).M = 30;
Comb(2).M = 30;
Comb(3).M = 120;
Comb(4).M = 130;
Comb(5).M = 180;
Comb(6).M = 180;
Comb(7).M = 70;
Comb(8).M = 160;
Comb(9).M = 160;
Comb(10).M = 30;

Comb(1).D = 30;
Comb(2).D = 70;
Comb(3).D = 40;
Comb(4).D = 50;
Comb(5).D = 100;
Comb(6).D = 80;
Comb(7).D = 60;
Comb(8).D = 20;
Comb(9).D = 30;
Comb(10).D = 40;

for k = 1:length(Comb)
    Comb(k).vars = {'cRMS', 'cKur', 'cVar', 'vaz'};
end
