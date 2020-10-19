function [A,w,type,tao] = amplres(h)
% h: FIR 数字滤波器的冲激响应
% A : 滤波器的幅度特性
% w : [0 2*pi] 区间内计算 Hr 的 512 个频率点
% type : 线性相位滤波器的类型
% tao : 幅度特性的群迟延
N = length(h);
tao = (N-1)/2;
L = floor(tao);
n = 1:L+1;
w = [0:511]*2*pi/512;
if all(abs(h(n) - h(N -n+1))<1e-8)
    if mod(N,2)~= 0
        A = 2* h(n) *cos(((N+1)/2 -n)'*w) - h(L+1);
        type =1;
    else
        A = 2*h(n)*cos(((N+1)/2 -n)'*w);
        type = 2;
    end
elseif all(abs(h(n)+h(N-n+1))< 1e-8) && (h(L+1) *mod(N,2) ==0)
    A = 2*h(n)*sin(((N+1)/2-n)'*w);
    if mod(N,2)~= 0
        type =3;
    else
        type =4;
    end
else error('error:非线性相位滤波器');
end