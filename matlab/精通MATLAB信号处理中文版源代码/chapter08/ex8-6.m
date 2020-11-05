load sumsin   %读入信号
s=sumsin(1:500);
%取信号的前500个采样点
[c,l]=wavedec(s,3, 'db3');
%对信号做层数为3的多尺度分解
a3= wrcoef('a',c,l, 'db3',3);
%对尺度3上的低频信号进行重构
subplot(211);plot(s);title('原始信号')
subplot(212);plot(a3);title ('重构信号');
