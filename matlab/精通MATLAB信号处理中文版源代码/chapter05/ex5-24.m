clear all;
n=40;           %滤波器的阶数
f=[0 0.5 0.6 1];  %频率向量
a=[1 2 0 0];         %振幅向量
w=[1 20];
b=firls(n,f,a,w);    
[h,w1]=freqz(b);   %计算滤波器的频率响应
bb=remez(n,f,a,w);   %采用remez设计滤波器
[hh,w2]=freqz(bb); %计算滤波器的频率响应
figure;
plot(w1/pi,abs(h),'r.',w2/pi,abs(hh),'b-.',f,a,'ms');
%绘制滤波器幅频响应
xlabel('归一化频率');ylabel('振幅');
