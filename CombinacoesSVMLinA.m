Comb(1).N = 4;
Comb(2).N = 4;
Comb(3).N = 4;
Comb(4).N = 4;
Comb(5).N = 3;
Comb(6).N = 3;
Comb(7).N = 4;
Comb(8).N = 3;
Comb(9).N = 3;
Comb(10).N = 4;

Comb(1).M = 160;
Comb(2).M = 180;
Comb(3).M = 170;
Comb(4).M = 150;
Comb(5).M = 170;
Comb(6).M = 180;
Comb(7).M = 140;
Comb(8).M = 160;
Comb(9).M = 150;
Comb(10).M = 130;

Comb(1).D = 60;
Comb(2).D = 60;
Comb(3).D = 60;
Comb(4).D = 60;
Comb(5).D = 90;
Comb(6).D = 90;
Comb(7).D = 60;
Comb(8).D = 90;
Comb(9).D = 90;
Comb(10).D = 60;

for k = 1:length(Comb)
    Comb(k).vars = {'cRMS', 'cKur', 'cVar', 'vaz'};
end