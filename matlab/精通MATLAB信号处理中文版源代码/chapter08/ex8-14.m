clear;
[w1,ns]=wnoise(3,9,7);
subplot(321);plot(ns);title('原始信号');
p=length(ns);
for i=1:3
    N=p/2^(i-1);
    M=N/2;
    for j=1:N
        x(j+2)=ns(j);
    end
    x(1)=ns(3);
    x(2)=ns(2);
    x(N+3)=ns(N-1);%扩展为N+3值
    Ye=dyaddown(x,0);%偶抽取
    Yo=dyaddown(x,1);%奇抽取
    for j=1:M+1;
        d(j)=Ye(j)-(Yo(j)+Yo(j+1))/2;%计算细节系数
    end
    for j=1:M
        detail(j)=d(j+1);
        dd(i,j)=detail(j);
    end
    for j=1:M
        approximation(j)=Yo(j+1)+(d(j)+d(j+1))/4;
    end
    for j=1:M
        ns(j)=approximation(j);
    end
end
for j=1:p/2^3
    s3(j)=approximation(j);
end
subplot(323);
plot(s3);title('提升小波分解第三层低频系数');
for j=1:p/2
    d1(1,j)=dd(1,j);
end
subplot(322);
plot(d1(1,:));title('第一层高频系数');
for j=1:p/2^2
    d2(1,j)=dd(2,j);
end
subplot(324);
plot(d2(1,:));title('第二层高频系数');
for j=1:p/2^3
    d3(1,j)=dd(3,j);
end
subplot(326);
plot(d3(1,:));title('第三层高频系数');
for j=3:-1:1
    M=p/2^j;
    N=2*M;
    for i=1:M
        s(i)=approximation(i);
    end
    s(M+1)=approximation(M);
    for i=1:M
        du(i+1)=dd(j,i);
    end
    du(1)=dd(j,1);
    du(M+2)=dd(j,M-1);
    for i=1:M+1
        h(2*i-1)=s(i)-(du(i)+du(i+1))/4;
    end
    for i=1:M
        y(2*i-1)=h(2*i-1);
    end
    for i=1:M
        y(2*i)=du(i+1)+(h(2*i-1)+h(2*i+1))/2;
    end
    for i=1:2*M
        approximation(i)=y(i);
    end
end
subplot(325);
plot(approximation);title('重构信号');
