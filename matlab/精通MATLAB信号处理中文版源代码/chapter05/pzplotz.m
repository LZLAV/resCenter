function pzplotz(b,a) 
%pzplotz(b,a)按给定系数向量b,a在z平面上画出零极点分布图
% b - 分子多项式系数向量
% a - 分母多项式系数向量
% a,b向量可从z的最高幂降幂排至z^0,也可由z^0开始,按z^-1的升幂排至z的最负幂.
N = length(a); 
M = length(b); 
pz = []; zz = []; 
if (N > M)      
zz = zeros((N-M),1); 
elseif (M > N)      
pz = zeros((M-N),1);  
end 
pz = [pz;roots(a)]; 
zz = [zz;roots(b)]; 
pzr = real(pz)'; 
pzi = imag(pz)'; 
zzr = real(zz)'; 
zzi = imag(zz)'; 
rzmin = min([pzr,zzr,-1])-0.5; 
rzmax = max([pzr,zzr,1])+0.5; 
izmin = min([pzi,zzi,-1])-0.5; 
izmax = max([pzi,zzi,1])+0.5; 
zmin = min([rzmin,izmin]); 
zmax = max([rzmax,izmax]); 
zmm=max(abs([zmin,zmax])); 
uc=exp(j*2*pi*[0:1:500]/500);
plot(real(uc),imag(uc),'b',[-zmm,zmm],[0,0],'b',[0,0],[-zmm,zmm],'b'); 
axis([-zmm,zmm,-zmm,zmm]);
axis('square');
hold on
plot(zzr,zzi,'bo',pzr,pzi,'rx');
hold on
text(zmm*1.1,zmm*0.95,'z-平面') 
xlabel('实轴');ylabel('虚轴') title('零极点图')
