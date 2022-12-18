clear;close all;clc
load('ssvep.mat')
%% 训练模型
train_fe_9_25=zeros(30,5);
train_fe_10_25=zeros(30,5);
train_fe_11_25=zeros(30,5);
train_fe_12_25=zeros(30,5);
train_fe_13_25=zeros(30,5);
for i=1:30
    train_fe_9_25(i,:)=power_fe(train_data_9_25(i,:));
    train_fe_10_25(i,:)=power_fe(train_data_10_25(i,:));
    train_fe_11_25(i,:)=power_fe(train_data_11_25(i,:));
    train_fe_12_25(i,:)=power_fe(train_data_12_25(i,:));
    train_fe_13_25(i,:)=power_fe(train_data_13_25(i,:));
end
train_fe=[train_fe_9_25;train_fe_10_25;train_fe_11_25;train_fe_12_25;train_fe_13_25];
label_1=ones(30,1);
label_2=ones(30,1)*2;
label_3=ones(30,1)*3;
label_4=ones(30,1)*4;
label_5=ones(30,1)*5;
train_label=[label_1;label_2;label_3;label_4;label_5];
[trainedClassifier,validationAccuracy]=trainClassifier(train_fe,train_label);
%% 测试数据验证
test_flag=4;
test_fe=predict_flag(test_flag,test_data_9_25,test_data_10_25,test_data_11_25,test_data_12_25,test_data_13_25);
pre_flag=trainedClassifier.predictFcn(test_fe);
%% Function
function fe=power_fe(data)
l=1075;
fs=256;
data=myfilter(data,8,41,fs);
[fre,sp]=pwelch(data,hanning(l),l/2,l,fs);
fe=zeros(1,5);
df=sp(2)-sp(1);
fe(1,1)=(fre(38)+fre(39)+fre(40)+fre(41)+fre(42)+fre(77)+fre(78)+fre(79)+fre(80)+fre(81)+fre(116)+fre(117)+fre(118)+fre(119)+fre(120))/sum(fre);
fe(1,2)=(fre(42)+fre(43)+fre(44)+fre(45)+fre(46)+fre(84)+fre(85)+fre(86)+fre(87)+fre(88)+fre(128)+fre(129)+fre(130)+fre(131)+fre(132))/sum(fre);
fe(1,3)=(fre(46)+fre(47)+fre(48)+fre(49)+fre(50)+fre(93)+fre(94)+fre(95)+fre(96)+fre(97)+fre(137)+fre(138)+fre(139)+fre(140)+fre(141))/sum(fre);
fe(1,4)=(fre(50)+fre(51)+fre(52)+fre(53)+fre(54)+fre(102)+fre(103)+fre(104)+fre(105)+fre(106)+fre(153)+fre(154)+fre(155)+fre(156)+fre(157))/sum(fre);
fe(1,5)=(fre(54)+fre(55)+fre(56)+fre(57)+fre(58)+fre(111)+fre(112)+fre(113)+fre(114)+fre(115)+fre(166)+fre(167)+fre(168)+fre(169)+fre(170))/sum(fre);
end

function result = myfilter(y,down,up,fc)
%0.5-4Hz Delta
%4-8Hz Theta
%8-13 Alpha
%13-32 Beta
%32-50 Gamma
    Wn = [down*2 up*2]/fc;
    [k,l] = butter(4,Wn);
    result = filtfilt(k,l,y);
end

function test_fe=predict_flag(flag,test_data_9_25,test_data_10_25,test_data_11_25,test_data_12_25,test_data_13_25)
switch flag
    case 1
        test_data=test_data_9_25(round(rand(1)*15),:);
    case 2
        test_data=test_data_10_25(round(rand(1)*15),:);
    case 3
        test_data=test_data_11_25(round(rand(1)*15),:);
    case 4
        test_data=test_data_12_25(round(rand(1)*15),:);
    case 5
        test_data=test_data_13_25(round(rand(1)*15),:);
end
test_fe=power_fe(test_data);
end