wp = 0.4*pi;
ws = 0.6*pi;
Rp = 0.45;
As = 80;	
%给定指标
delta1 = (10^(Rp/20)-1)/(10^(Rp/20)+1); 
delta2 = (1+delta1)*(10^(-As/20));
%求波动指标
weights = [delta2/delta1 1]; 
deltaf = (ws-wp)/(2*pi);
%给定权函数和△f=wp-ws
N= ceil((-20*log10(sqrt(delta1*delta2))-13)/(14.6*deltaf)+1);
N=N+mod (N-1,2); 
%估算阶数N
f =[0 wp/pi ws/pi 1]; A = [1 1 0 0];
%给定频率点和希望幅度值
h = remez(N-1,f,A,weights);
%求脉冲响应
[db,mag,pha,grd,W] = freqz_m(h,[1]);
%验证求取频率特性
delta_w = 2*pi/1000; wsi = ws/delta_w+1;
wpi=wp/delta_w+1;
Asd = -max(db(wsi:1:500));
%求阻带衰减
subplot(2,2,1); n=0:1:N-1;stem(n,h);
axis([0,52,-0.1,0.3]);title('脉冲响应');
xlabel('n');
ylabel('hd(n)')
grid on;
%画h(n)
subplot(2,2,2); 
plot(W,db);
title('对数幅频特性');
ylabel('分贝数');
xlabel('频率')
grid on;
%画对数幅频特性
subplot(2,2,3);
plot(W,mag);axis([0,4,-0.5,1.5]);
title('绝对幅频特性');
xlabel('Hr(w)');
ylabel('频率')
grid on;
%画绝对幅频特性
n=1:(N-1)/2+1;H0=2*h(n)*cos(((N+1)/2-n)'*W)-mod(N,2)*h((N-1)/2+1);
%求Hg(w)
subplot(2,2,4);
plot(W(1:wpi),H0(1:wpi)-1,W(wsi+5:501),H0(wsi+5:501));
title('误差特性');
%求误差
ylabel('Hr(w)');
xlabel('频率')
grid on;
