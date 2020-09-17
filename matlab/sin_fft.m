clear;
clc;
fo = 4;     %频率
Fs = 100;   %采样率
Ts = 1/Fs;  % 采样间隔
t = 0:Ts:1-Ts;
n = length(t);
y = 2*sin(2*pi*fo*t);

sinePlot = figure;  %创建一个新的figure
plot(t,y);
xlabel('time(seconds)');
ylabel('y(t)');
title('Sample Sine Wave');

matlabFFT = figure;
YfreqDomain = fft(y);
%stem(abs(YfreqDomain));
stem(abs(YfreqDomain));
xlabel('Sample Number')
ylabel('Amplitude')
title('Using the Matlab fft command')
grid
axis([0,100,0,120])

[YfreqDomain,frequencyRange] = centeredFFT(y,Fs);
disp('test');
centeredFFT = figure;
stem(frequencyRange,abs(YfreqDomain));
xlabel('Freq(Hz)');
ylabel('Amplitude');
title('Using the centeredFFT function');
grid;
axis([-6,6,0,1.5])

[YfreqDomain,frequencyRange] = positiveFFT(y,Fs);
positiveFFT = figure;
stem(frequencyRange,abs(YfreqDomain));
set(positiveFFT,'Position',[500,500,500,300])
xlabel('Freq(Hz)');
ylabel('Amplitude');
title('Using the positiveFFT function');
grid;
axis([0,20,0,1.5])

