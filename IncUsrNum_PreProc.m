% 对新增用户数据进行预处理
% 首先用三次多项式对曲线进行拟合，然后根据拟合函数删除
clear, clc;
format long;
IncUsrNum = load('~/Documents/CurveFit/IncUserNum_Sp.dat');
DayTh = 1:length(IncUsrNum);
plot(DayTh, IncUsrNum);
