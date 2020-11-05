clear all;
wp=400*2*pi;
ws=420*2*pi;
rs=90;;rp=0.25;fs=1450;
[n,wn]=ellipord(wp,ws,rp,rs,'s');
[z,p,k]=ellipap(n,rp,rs);
[a,b,c,d]=zp2ss(z,p,k);
[at,bt,ct,dt]=lp2lp(a,b,c,d,wn);
[num1,den1]=ss2tf(at,bt,ct,dt);
[num2,den2]=impinvar(num1,den1,fs);
[h,w]=freqz(num2,den2);
figure;
winrect=[150,150,450,350];
set(gcf,'position',winrect);
set(gco,'linewidth',1);
freqz(num2,den2);
xlabel('归一化角频率');ylabel('相角');
figure;winrect=[150,150,450,350];
set(gcf,'position',winrect);
plot(w*fs/(2*pi),abs(h));
grid on;
xlabel('频率(Hz)');ylabel('幅值');
