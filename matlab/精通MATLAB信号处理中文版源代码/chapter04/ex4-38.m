clear all;
N=6; 
Rp=3;        %滤波器阶数
f1=150;
f2=600;    %滤波器的边界界限(Hz)
w1=2*pi*f1;  
w2=2*pi*f2;   %边界频率(rad/s)
[z,p,k]=cheb2ap(N,Rp);  %设计Chebyshev I型原型低通滤波器
[b,a]=zp2tf(z,p,k);  %转换为传递函数形式
Wo=sqrt(w1*w2);       %中心频率
Bw=w2-w1;             %频带宽度
[bt,at]=lp2bp(b,a,Wo,Bw);  %频率转换
[h,w]=freqs(bt,at);    %计算复数频率响应
figure;
subplot(2,2,1);semilogy(w/2/pi,abs(h));  %绘制幅频特性
xlabel('频率/Hz'); title('幅频图');
grid on;
subplot(2,2,2);plot(w/2/pi,angle(h)*180/pi);  %绘制相频响应
xlabel('频率/Hz');ylabel('相位图/^o');title('相频图');
grid on;
H=[tf(bt,at)];   %在MATLAB中表示此滤波器
[h1,t1]=impulse(H);  %绘出系统的脉冲响应图
subplot(2,2,3);plot(t1,h1); 
xlabel('时间/s');title('脉冲响应');
[h2,t2]=step(H);  %绘出系统的阶跃响应图
subplot(2,2,4);plot(t2,h2); 
xlabel('时间/s');title('阶跃响应');
