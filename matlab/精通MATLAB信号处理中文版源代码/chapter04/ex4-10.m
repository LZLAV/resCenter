clear all;
n=0:0.01:2;
for i=1:4,
    switch i
        case 1;
            N=1;
        case 2;
            N=3;
        case 3;
            N=8;
        case 4;
            N=12;
    end;
[z,p,k]=buttap(N);    %函数调用
[b,a]=zp2tf(z,p,k);   %得到传递函数
[h,w]=freqs(b,a,n);   %特性分析
magh=abs(h);
subplot(2,2,i);plot(w,magh);
axis([0 2 0 1]);
xlabel('w/wc');ylabel('|H(jw)|^2');
title([' filter N=',num2str(N)]);
grid on;
end
