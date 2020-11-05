function [h]=usefir1(mode,n,fp,fs,window,r,sample)
% mode:模式(1--高通; 2--低通; 3--带通; 4--带阻)
% n:阶数, 加窗的点数为阶数加1
% fp:高通和低通时指示截止频率, 带通和带阻时指示下限频率
% fs:带通和带阻时指示上限频率
% window:加窗(1--矩形窗; 2--三角窗; 3--巴特窗; 4--汉明窗; 
%5--汉宁窗; 6--布莱克曼窗; 7--凯泽窗; 8--契比雪夫窗)
% r代表加chebyshev窗的r值和加kaiser窗时的beta值
% sample:采样率
% h:返回设计好的FIR滤波器系数
if window==1 w=boxcar(n+1);
end
if window==2 w=triang(n+1);end
if window==3 w=bartlett(n+1);end
if window==4 w=hamming(n+1);end
if window==5 w=hanning(n+1);end
if window==6 w=blackman(n+1);end
if window==7 w=kaiser(n+1,r);end
if window==8 w=chebwin(n+1,r);
end
wp=2*fp/sample;
ws=2*fs/sample;
if mode==1 h=fir1(n,wp,'high',w);
end
if mode==2 h=fir1(n,wp,'low',w);
end
if mode==3 h=fir1(n,[wp,ws],w);
end
if mode==4 h=fir1(n,[wp,ws],'stop',w);
end
m=0:n;
subplot(131);
plot(m,h);grid on;	
title('冲激响应');
axis([0 n 1.1*min(h) 1.1*max(h)]);
ylabel('h(n)');xlabel('n');
freq_response=freqz(h,1);
magnitude=20*log10(abs(freq_response));
m=0:511; f=m*sample/(2*511);
subplot(132);
plot(f,magnitude);grid on;
title('幅频特性');
axis([0 sample/2 1.1*min(magnitude) 1.1*max(magnitude)]);
ylabel('f幅值');xlabel('频率');
phase=angle(freq_response);
subplot(133);plot(f,phase);grid on;
title('相频特性');
axis([0 sample/2 1.1*min(phase) 1.1*max(phase)]);
ylabel('相位');xlabel('频率');
