clear all;
load wnoislop;    %装载原始wnoislop信号
s= wnoislop;
figure; 
subplot(7,1,1);plot(s);
ylabel('s');axis tight;
% 使用db5小波对信号进行6层分解
[C,L]=wavedec(s,6,'db5');
for i=1:6
    % 对分解的第6层到第1层的低频系数进行重构
    a=wrcoef('a',C,L,'db5',7-i);
    subplot(7,1,i+1); plot(a);
    axis tight;
    ylabel(['a',num2str(7-i)]);
end
figure;
subplot(7,1,1);plot(s);
ylabel('s'); axis tight;
for i=1:6
    % 对分解的第6层到第1层的高频系数进行重构
    d=wrcoef('d',C,L,'db5',7-i);
    subplot(7,1,i+1);plot(d);
    ylabel(['d',num2str(7-i)]);
    axis tight;
end
