% 音频合并操作，直接两音频连接
clear all;
cd = 'wav';
disp(fullfile(cd))
waveFiles = dir(fullfile(cd,'*.wav'));
len = size(waveFiles,1);
disp(len)

Z =[];
for i=1:len
    fileName = [cd '/' waveFiles(i).name];
    disp(fileName)
    [X,fs] = audioread(fileName);
    %X = X((1:int32(fs*0.6)),:);
    Z = [Z;X];
end
audiowrite('final.wav',Z,12*fs);
sound(Z,fs);

