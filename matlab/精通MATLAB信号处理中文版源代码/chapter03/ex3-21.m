clear all
a=1/10;
m=2;					%设定窗口尺度和超高斯函数阶数
t1=5;t2=6;
%设定双信号的位置
%绘制双信号的三维网格立体图
[t,W]=meshgrid([2:0.2:7],[0:pi/6:3*pi]); 
%设置时-频相平面网格点
Gs1=(1/(sqrt(2*pi)*a))*exp(-0.5*abs((t1-t)/a).^m).*exp(-i*W*t1);
Gs2=(1/(sqrt(2*pi)*a))*exp(-0.5*abs((t2-t)/a).^m).*exp(-i*W*t2);
Gs=Gs1+Gs2;
subplot(2,3,1);
%绘制实部三维网格立体图
mesh(t,W/pi,real(Gs));
axis([2 7 0 3 -1/(sqrt(2*pi)*a) 1/(sqrt(2*pi)*a)]);
title('实部')
xlabel('t(s)'); ylabel('real(Gs)');
subplot(2,3,2);
%绘制虚部三维网格立体图
mesh(t,W/pi,imag(Gs));
axis([2 7 0 3 -1/(sqrt(2*pi)*a) 1/(sqrt(2*pi)*a)]);
title('虚部')
xlabel('t(s)'); ylabel('imag(Gs)');
subplot(2,3,3);
%绘制绝对值三维网格立体图
mesh(t,W/pi,abs(Gs));
axis([2 7 0 3 -1/(sqrt(2*pi)*a) 1/(sqrt(2*pi)*a)]);
title('绝对值')
xlabel('t(s)'); ylabel('abs(Gs)');
%绘制双信号的二维灰度图
[t,W]=meshgrid([2:0.2:7],[0:pi/20:3*pi]);
%设置时频相平面网格点
Gs1=(1/(sqrt(2*pi)*a))*exp(-0.5*abs((t1-t)/a).^m).*exp(-i*W*t1);
Gs2=(1/(sqrt(2*pi)*a))*exp(-0.5*abs((t2-t)/a).^m).*exp(-i*W*t2);
Gs=Gs1+Gs2;
subplot(2,3,4);
ss=real(Gs);ma=max(max(ss));
%计算最大值
pcolor(t,W/pi,ma-ss);
title('实部最大值')
xlabel('t(s)'); ylabel('maxreal(Gs)');
colormap(gray(50));shading interp;
subplot(2,3,5);
ss=imag(Gs);ma=max(max(ss));
%计算最大值
pcolor(t,W/pi,ma-ss);
title('虚部最大值')
xlabel('t(s)'); ylabel('maximag(Gs)');
colormap(gray(50));shading interp;
subplot(2,3,6);
ss=abs(Gs);ma=max(max(ss));
%计算绝对值的最大值
pcolor(t,W/pi,ma-ss);
title('绝对值最大值')
xlabel('t(s)'); ylabel('maxabs(Gs)');
colormap(gray(50));
shading interp;
