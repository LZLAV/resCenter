clear; 
t=40; 
fs=10000; 
f1=2000; 
f2=4000; 
le=fs*t;   
a=1/16;b=16; 
N=a*fs;M=fs/b; 
s=fix(le/fs);
%帧间重叠1/2,所以算出所需循环次数 
hn=boxcar(M)';
%得到STFT分析窗,汉宁窗,帧长256点 
T=1:fs*t; 
d=sin(2*pi*f1*T/fs)+sin(2*pi*f2*T/fs); 
for n=1:1:s        
    d1(1:M)=d((n-1)*N+1:(n-1)*N+M).*hn; 
%时域加窗  
    Xd(n,(1:M))=fft(d1,M);  %FFT   
end 
[n,m]=size(Xd); 
x=1:n;y=1:m; 
mesh(y/m,x,abs(Xd));
axis([0,0.5,0,20,0,100])
xlabel('t'); 
ylabel('f ') 
zlabel('幅度');
