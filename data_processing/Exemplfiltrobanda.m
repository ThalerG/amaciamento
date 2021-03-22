%Arquivo para gera��o de features com FFT

clc 
%clear all

temp=vxT(50,:); % Carrega o dado de vibra��o (no caso do exemplo, � um dado de um dos meios ensaios onde cada coluna representa a velocidade vibrat�ria em um eixo)
temp = temp*9.80665;
r0 = 1e-6; 

Fs = 25.6e3; % Taxa de aquisi��o
eixos=1; %quantidade de eixos a serem analisados
t=1; % Periodo de aquisi��o 
size=Fs*t;

%FFT
fim = 10e3; %Freq final para an�lise FFT
nBandsFFT = 200; %numero de bandas do FFT
sup = 10; % Superposi��o equivalente a 20%

dur = fim/nBandsFFT+sup;
freq = 1/t; %step frequ�ncia de cada ponto do FFT
nfFFT = round(dur/freq); %dura��o da faixa em pontos
nsFFT = round(sup/freq); %dura��o da sobreposi��o em pontos
fFFT = round(fim/freq); %numero total de pontos
bands=[dur/2:(dur-sup):dur/2+(dur-sup)*nBandsFFT-1]; %gera array com a frequ�ncia central de cada banda (em kHz)

bFFT=0; %pra pegar dados de todos os eixos
amostraFFT = zeros([1 nBandsFFT*eixos]); %tempor�rio -> precisa por causa do parfor

    for a=1:1 % analisei s� um eixo
          v = temp;
                
          ft = fft(v); %calcula FFT de v
          P2 = abs(ft/size);
          ft = P2(1:size/2+1);
          ft(2:end-1) = 2*ft(2:end-1);
          
          j=1;
          i=1;
          while j<nBandsFFT
              band = ft(i:i+nfFFT-1);
              amostraFFT(j+bFFT) = sum(band.^2); %energia
              i=i+nfFFT-nsFFT;
              j=j+1;
          end
          band = ft(fFFT-nfFFT:fFFT); %�ltima banda
          amostraFFT(j+bFFT) = sum(band.^2); %energia

          bFFT=bFFT+nBandsFFT; %atualiza��o do valor  

    end

xt=(0:1/Fs:t)';
fx=(0:(length(ft)-1))'*freq;

%F1=20*log(ft/r0); F2=20*log(amostraFFT/r0);

F1 = ft; F2 = amostraFFT;

figure(1)


%figure(2)
subplot(2,1,1);
plot(fx,F1,'Color',[0.3 0.3 0.3])
ylabel('Vib. velocity level (dB)');
xlabel('Frequency (Hz)');
title('Espectro de frequ�ncia')
xlim([0 10000]);

subplot(2,1,2);
plot(bands,F2,'Color',[0.3 0.3 0.3])
ylabel('Vib. velocity level (dB)');
xlabel('Freq. band (Hz)');
title('Energia por banda de freq.')
xlim([0 10000]);


