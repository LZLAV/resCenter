clear all;
t = 0:0.002:2;   
y = chirp(t,0,1,150);                       
subplot(311);spectrogram(y,256,250,256,1E3,'yaxis');

xlabel('t=0:0.002:2'); 
title('不同采样时间的条件下');
t = -2:0.002:2;    
y = chirp(t,100,1,200,'quadratic'); 
subplot(323);spectrogram(y,128,120,128,1E3,'yaxis');
xlabel('t=-2:0.002:2');
t = -1:0.002:1; 
fo = 100; f1 = 400; 
y = chirp(t,fo,1,f1,'q',[],'convex');
subplot(324);spectrogram(y,256,200,256,1000,'yaxis')
xlabel('t=-1:0.002:1');
t = 0:0.002:1;  
fo = 100; f1 = 25;  
y = chirp(t,fo,1,f1,'q',[],'concave');
subplot(325);spectrogram(y,hanning(256),128,256,1000,'yaxis');
xlabel('t=0:0.002:1');
t = 0:0.002:10;
fo = 10; f1 = 400;  
y = chirp(t,fo,10,f1,'logarithmic');
subplot(326);spectrogram(y,256,200,256,1000,'yaxis')
xlabel('t=0:0.002:10');
