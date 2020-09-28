clc;
clear;
close all;
% 狄拉克函数的变换
%{
N = 10000;
Tau0 = 1;
for i=1:100
    Tau = Tau0/i;
    TimeRange = linspace(-10*Tau,10*Tau,N);
    FreqRange = linspace(-200*pi/i,200*pi/i,N);
    Half_Tau = Tau/2;
    RECT = 1/Tau*double(abs(TimeRange) < Half_Tau);
    SINC = sinc(FreqRange*Tau*pi);
    
    subplot(211);
    plot(TimeRange,RECT,'LineWidth',1.5);
    grid on;
    xlim([-1 1]);
    ylim([-0.5 120]);
    xlabel('Timer');
    ylabel('Amplitude');
    title('Made by lzl');
    
    subplot(212);
    plot(FreqRange,SINC,'Linewidth',1.5);
    grid on;
    xlim([-200*pi/i 200*pi/i]);
    ylim([-0.5 1.5]);
    xlabel('Frequency');
    ylabel('Amplitude');
    title('Made by lzl');
    drawnow;
end
%}

Fs = 1000;
T = 1/Fs;
L = 800;
t = (0:L-1)*T;

s1 = 5*sin(2*pi*100*t);
s2 = 5*sin(2*pi*180*t);
s3 = 5*sin(2*pi*320*t);
s4 = 5*sin(2*pi*400*t);

signal = [s1 s2 s3 s4];
tp = (0:4*L-1)*T;
figure('color','w');
plot(tp,signal);
title('Original Signal Made by lzl');
grid on;


[S F T P] = spectrogram(signal,128,120,1024,1000);
surf(T,F,abs(S));
shading flat;
view(-67,70);
xlim([0 max(tp)]);
xl = xlabel('  Time');
yl = ylabel('Frequency');
zlabel('Amplitude');
set(xl,'Rotation',70);
set(yl,'Rotation',-10);
title('Made by lzl');
