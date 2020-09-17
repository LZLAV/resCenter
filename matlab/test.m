clear;
clc;
Fs = 1000;
t = 0:.001:.25;     %250个采样点
x = sin(2*pi*50*t) + sin(2*pi*120*t);
y = x;

sinePlot = figure;  %创建一个新的figure
plot(t,y);
xlabel('time(seconds)');
ylabel('y(t)');
title('Sample Sine Wave');

matlabFFT = figure;
YfreqDomain = fft(y);
plot(abs(YfreqDomain));
xlabel('Sample Number')
ylabel('Amplitude')
title('Using the Matlab fft command')
grid
axis([0,300,0,120])

[YfreqDomain,frequencyRange] = centeredFFT(y,Fs);
disp('test');
centeredFFT = figure;
stem(frequencyRange,abs(YfreqDomain));
xlabel('Freq(Hz)');
ylabel('Amplitude');
title('Using the centeredFFT function');
grid;
axis([0,700,0,120])

[YfreqDomain,frequencyRange] = positiveFFT(y,Fs);
positiveFFT = figure;
stem(frequencyRange,abs(YfreqDomain));
set(positiveFFT,'Position',[500,500,500,300])
xlabel('Freq(Hz)');
ylabel('Amplitude');
title('Using the positiveFFT function');
grid;
axis([0,700,0,120])

