B=[1 -1.3];
A =[1 0];
[H,w]=freqz(B,A,400,'whole');
Hf=abs(H);
Hx=angle(H);
clf
subplot(121)
plot(w,Hf)
title('离散系统幅频特性曲线')
xlabel('频率');ylabel('幅度')
grid on
subplot(122)
plot(w,Hx)
xlabel('频率');ylabel('幅度')
grid on
title('离散系统相频特性曲线')
