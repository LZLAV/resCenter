h=[-4 3 -5 -2  5 7 5 -2 -1 8 -3]
M=length(h);
n=0:M-1; 
[Hr,w,a,L]=hr_type1(h);
subplot(2,2,1);
stem(n,h); 
xlabel('n');
ylabel('h(n)');
title('脉冲响应')
grid on
subplot(2,2,3);
stem(0:L,a); 
xlabel('n');
ylabel('a(n)');
title('a(n)系数')
grid on
subplot(2,2,2); 
plot(w/pi,Hr);
xlabel('频率单位pi');ylabel('Hr');
title('I型幅度响应')
grid on
subplot(2,2,4);
pzplotz(h,1);
grid on
