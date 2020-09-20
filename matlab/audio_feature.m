% 音频特征值提取
clear all;
cd = 'wav';
disp(fullfile(cd))
waveFiles = dir(fullfile(cd,'*.wav'));
len = size(waveFiles);

for i=1:len
    fileName = [cd '/' waveFiles(1).name];
    [sampledata,FS] = audioread(fileName);
    calsample(sampledata,FS);
    keypoint(sampledata,4);
end
