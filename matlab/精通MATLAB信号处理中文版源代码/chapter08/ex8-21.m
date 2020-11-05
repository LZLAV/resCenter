clear all;
load sumsin;    %装载原始sumsin信号
s=sumsin(1:500); 
% 取信号的前500个采样点
figure; 
subplot(6,1,1);plot(s);
ylabel('s');
% 使用db3小波对信号进行5层分解
[C,L]=wavedec(s,5,'db3');
for i=1:5
    % 对分解的第5层到第1层的低频系数进行重构
    a=wrcoef('a',C,L,'db3',6-i);
    subplot(6,1,i+1); plot(a);   
    ylabel(['a',num2str(6-i)]);
end
figure;
subplot(6,1,1);plot(s);
ylabel('s'); 
for i=1:5
    % 对分解的第6层到第1层的高频系数进行重构
    d=wrcoef('d',C,L,'db3',6-i);
    subplot(6,1,i+1);plot(d);
    ylabel(['d',num2str(6-i)]);    
end
