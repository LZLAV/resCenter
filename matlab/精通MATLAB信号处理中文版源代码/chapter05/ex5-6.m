h=[-4 3 -5 -2  5 7 5 -2 -1 8 -3]
M=length(h);
n=0:M-1; 
[Hr,w,c,L]=hr_type3(h);
subplot(2,2,1);
stem(n,h); 
xlabel('n');
ylabel('h(n)');
title('脉冲响应')
grid on
subplot(2,2,3);
stem(0:L,c); 
xlabel('n');
ylabel('c(n)');
title('c(n)系数')
grid on
subplot(2,2,2); 
plot(w/pi,Hr);
xlabel('频率单位pi');ylabel('Hr');
title('Ⅲ 型幅度响应')
grid on
subplot(2,2,4);
pzplotz(h,1);
grid on
