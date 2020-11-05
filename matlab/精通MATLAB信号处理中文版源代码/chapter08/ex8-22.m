clear all;
load wnoislop;          %装载原始wnoislop信号
x= wnoislop;
subplot(6,1,1);plot(x);
ylabel('x');
% 进行一维离散小波变换
[C,L]=wavedec(x,5,'db4');
for i=1:5
    % 对分解结构[C,L]中的低频部分进行重构
    s=wrcoef('a',C,L,'db4',6-i);
    subplot(6,1,i+1);plot(s);
    ylabel(['a',num2str(6-i)]);
end
