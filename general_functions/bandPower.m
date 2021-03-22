function [p,f] = bandPower(x,fs,fend,nBands,sup)
%BANDPOWER Signal power in same width bands.
%   [p,f] = BANDPOWER(x,fs,fend,nBands,sup) divide as frequências de 0 a 
%   fend do sinal x, amostrado com frequência fs, em nBands bandas de
%   frequência com superposição de sup %.

t=length(x)/fs; % Periodo de aquisição 
size=length(x);

dur = fend/nBands+sup; % Largura das bandas
freq = 1/t; %step frequência de cada ponto do FFT
nfFFT = round(dur/freq); %duração da faixa em pontos
nsFFT = round(sup/freq); %duração da sobreposição em pontos
fFFT = round(fend/freq); %numero total de pontos
f = [dur/2:(dur-sup):dur/2+(dur-sup)*nBands-1]; %gera array com a frequência central de cada banda (em kHz)

p = zeros([1 nBands]); %temporário -> precisa por causa do parfor

ft = fft(x); %calcula FFT de x
P2 = abs(ft/size);
ft = P2(1:size/2+1);
ft(2:end-1) = 2*ft(2:end-1);

j=1;
i=1;
while j<nBands
  band = ft(i:i+nfFFT-1);
  p(j) = sum(band.^2); %energia
  i=i+nfFFT-nsFFT;
  j=j+1;
end
band = ft(fFFT-nfFFT:fFFT); %última banda
p(j) = sum(band.^2); %energia

end

