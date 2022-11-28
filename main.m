clc;close all;clear;
start_flag=1;
fs=500;
if(start_flag==1)
    [yi,fplot,fftplot]=read_data(fs);
end
figure
plot(0.002:0.002:0.002*length(yi),yi);
figure
plot(fplot,fftplot);
xlim([0,50])



