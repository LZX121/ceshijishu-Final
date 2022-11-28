clc;close all;clear;
start_flag=1;
fs=500;
if(start_flag==1)
%% 读取数据
tmp=nan(8,fs);
delete(instrfindall);
obj=serialport('COM10',9600);
flush(obj);
tic
t=nan(fs,1);
tic
for i=1:8*fs
    tmp(i)=read(obj,1,"uint8");
    if mod(i,8)==1
        t(floor(i/8)+1)=toc;
            tic
    end
end
%% 数据转换
[m,n]=size(tmp);
data=reshape(tmp,m*n,1);
idx=find(data==170);
idx0=[];
for i=1:1:length(idx)
    if data(idx(i)+1)==170
        idx0=[idx0 idx(i)];
    end        
end
datafinal=[];
for i=1:1:length(idx0)-1
    if (idx0(i+1)-idx0(i))==8
        datafinal=[datafinal data(idx0(i):idx0(i)+7)];
    end
end
datafinal=datafinal';
find(datafinal(:,2)~=170) %检查
datafinal(:,1:5)=[];
datafinal(find(datafinal(:,1)>127))=datafinal(find(datafinal(:,1)>127))-256;
dataplot=datafinal(:,1)*256*256+datafinal(:,2)*256+datafinal(:,3);
%% 时域图像
matrix=zeros(length(dataplot),length(dataplot));
for i=1:1:length(dataplot)
    for j=1:1:length(dataplot)
        if  i<=j
            matrix(i,j)=1;
        end
    end
end
tplot=t(1:length(dataplot));
tplot=tplot'*matrix;
%% 频谱图像
yi= interp1 (tplot,dataplot,0:0.002:max(tplot),'pchip');
fplot=0:(fs/(length(yi)-1)):(fs/2);
fftplot=abs(fftshift(fft(yi)));
fftplot(1:(length(fftplot)/2))=[];
fftplot=fftplot*2;
fftplot(1)=fftplot(1)/2;
end
%% Figure
figure
plot(tplot,dataplot);
hold on
plot(0.002:0.002:0.002*length(yi),yi);
figure
plot(fplot,fftplot);
xlim([0,50])
% save('up01.mat','yi')