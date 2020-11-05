clear all;
cfs = [0.5];  
essup = 10; 
figure(1) 
for i=1:6    
    rec = upcoef('a',cfs,'db6',i);    
    ax = subplot(6,1,i),h = plot(rec(1:essup)); 
    set(ax,'xlim',[1 350]); 
    essup = essup*2; 
end 
subplot(611) 
title(['单尺度低频系数向上1 - 6重构信号']);
cfs = [0.5]; 
mi = 12; ma = 30;   
rec = upcoef('d',cfs,'db6',1); 
figure(2) 
subplot(611), plot(rec(3:12)) 
for i=2:6    
    rec = upcoef('d',cfs,'db6',i); 
    subplot(6,1,i), plot(rec(mi*2^(i-2):ma*2^(i-2))) 
end 
subplot(611) 
title(['单尺度高频系数向上1- 6重构信号']);
