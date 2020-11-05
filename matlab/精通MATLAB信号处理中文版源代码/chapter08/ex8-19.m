clear all;
load noissin;    %装载原始noissin信号
s=noissin;
figure; 
subplot(6,1,1);plot(s);
ylabel('s');
% 使用db5小波对信号进行5层分解
[C,L]=wavedec(s,5,'db5');
for i=1:5
    % 对分解的第5层到第1层的低频系数进行重构
    A=wrcoef('A',C,L,'db5',6-i);
    subplot(6,1,i+1); plot(A);
    ylabel(['A',num2str(6-i)]);
end
figure;
subplot(6,1,1);plot(s);
ylabel('s');
for i=1:5
    % 对分解的第5层到第1层的高频系数进行重构
    D=wrcoef('D',C,L,'db5',6-i);
    subplot(6,1,i+1);plot(D);
    ylabel(['D',num2str(6-i)]);
end
