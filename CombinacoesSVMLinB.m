Comb(1).N = 4;
Comb(2).N = 3;
Comb(3).N = 3;
Comb(4).N = 4;
Comb(5).N = 4;
Comb(6).N = 4;
Comb(7).N = 4;
Comb(8).N = 3;
Comb(9).N = 4;
Comb(10).N = 3;

Comb(1).M = 60;
Comb(2).M = 90;
Comb(3).M = 160;
Comb(4).M = 170;
Comb(5).M = 50;
Comb(6).M = 180;
Comb(7).M = 150;
Comb(8).M = 180;
Comb(9).M = 130;
Comb(10).M = 100;

Comb(1).D = 60;
Comb(2).D = 90;
Comb(3).D = 90;
Comb(4).D = 60;
Comb(5).D = 60;
Comb(6).D = 60;
Comb(7).D = 60;
Comb(8).D = 90;
Comb(9).D = 60;
Comb(10).D = 90;

for k = 1:length(Comb)
    Comb(k).vars = {'cRMS', 'cKur', 'cVar', 'vaz'};
end