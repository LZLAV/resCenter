close all;
clear all;
clc;
%读取音频信号
[a,fs,nbit]=wavread('qq.wav');
subplot(3,1,1)
plot(a);
title('原始语音信号');
%定义采样的点数和重复点数
m=length(a);
chongfudian=160;								%选取重复的点数为64
L=250-chongfudian;
%判断总共有多少个这样的段
nn=(m-90)/L;
N=ceil(nn); 
count=zeros(1,N);
%段内过零点统计
%thesh为一界限，不对（-thresh，thresh）之间的点经行过零点统计
thresh=0.000010;
for n=1:N-2
    for k=L*n : (L*n+250)
        if  a(k)>thresh&a(k+1)<-thresh | a(k)<-thresh&a(k+1)>thresh       
            count(n)=count(n)+1;
        end 
    end
end
%最后一段零点统计
for j=k:m-1
        if  a(j)>thresh&a(j+1)<-thresh  | a(j)<-thresh&a(j+1)>thresh       
            count(N)=count(N)+1;
        end 
end
%过零点统计图
subplot(3,1,2)
plot(count);
title('过零点个数统计图');
%语音信号的分段提取
%选取合适的阈值
j=0;
for n1=1:N
    j=j+1;
    if count(n1)>0.0003
        x(j)=count(n1);
    else 
        x(j)=0;    
    end
end
subplot(3,1,3)
plot(x);
title('选取适当阈值后的分割图');
%提取各个语音片段
pianduan=0;									%确定第几个片段
qidian=0;										%分段时确定每一个片段的起点标志
for n2=1:N
    if x(n2)>0
        for i=1:L
            a2((n2-1-qidian)*L+i)=a((n2-1)*L+i);  
        end
        if x(n2)>0 &x(n2+1)==0 & x(n2+2)==0		%每一片段结束的判断
                pianduan=pianduan+1;
                a2=0;
                qidian=n2-1;
        end
        switch pianduan						%将每一片段转换成MP3
            case 0							%格式并保存
                 wavwrite(a2,fs, nbit ,'ODD0.mp3')
             case 1  
                 wavwrite(a2,fs, nbit ,'ODD1.mp3')
             case 2  
                 wavwrite(a2,fs, nbit ,'ODD2.mp3')
             case 3  
                 wavwrite(a2,fs, nbit ,'ODD3.mp3')
             case 4  
                 wavwrite(a2,fs, nbit ,'ODD4.mp3') 
             case 5  
                 wavwrite(a2,fs, nbit ,'ODD5.mp3') 
             case 6  
                 wavwrite(a2,fs, nbit ,'ODD6.mp3') 
             case 7  
                 wavwrite(a2,fs, nbit ,'ODD7.mp3')
             case 8  
                 wavwrite(a2,fs, nbit ,'ODD8.mp3')
             case 9 
                 wavwrite(a2,fs, nbit ,'ODD9.mp3')
            otherwise 
                 disp('error')  
       end      
    end
end
%处理后每段语音的波形输出
figure;
[a0,fs,nbit]=wavread('ODD0.mp3');
subplot(2,2,1)
plot(a0);
[a1,fs,nbit]=wavread('ODD1.mp3');
subplot(2,2,2)
plot(a1);
[a2,fs,nbit]=wavread('ODD2.mp3');
subplot(2,2,3)
plot(a2);
[a3,fs,nbit]=wavread('ODD3.mp3');
subplot(2,2,4)
plot(a3);
