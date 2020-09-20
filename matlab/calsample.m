% 分离音频音轨，多音轨只摘取第一个音轨

function sample = calsample(sampledata,FS)
temp_sample = resample(sampledata,1,FS/FS); % resample(sampledata,p,q)重采样，以原有信号的 p/q 倍重采样
[m,n]= size(temp_sample);
disp(n);    % 音频声道数
disp(m);
if(n == 2)
    sample = temp_sample(:,1);
else
    sample = temp_sample;
end
sound(sample,FS);
end