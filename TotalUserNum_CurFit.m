clear all
format long
disp('用多项式拟合用户总数随时间变化曲线:')
% 待处理的数据文件:
DataFile = '~/Documents/CurveFit/TotalUserNum_Sp.dat';
TtlUsrNum = load(DataFile);
n = length(TtlUsrNum);
str = sprintf('从文件 %s 中获取了 %d 个数据', DataFile, n);
disp(str)
DayTh = 0:1:n-1;
Time = 0:0.001:n-1;
% 多项式拟合的阶数:
Degree = 6;

plot(DayTh, TtlUsrNum, '.', 'color', 'b', 'MarkerSize', 3)
title('Polynomial Fitting the Num of Total User')
xlabel('Dayth')
ylabel('Num of Total User')
hold on

% DayThStd = (DayTh-mean(DayTh))./std(DayTh);
[Paras, Struct] = polyfit(DayTh, TtlUsrNum, Degree);
% 
[FitTime, Delta] = polyval(Paras, Time, Struct);
% FitDayTh = polyval(Paras, DayTh);
plot(Time, FitTime, 'color', 'r')
legend('Standard ', 'Fitted', 'Location', 'NorthWest')
grid on
figure(2)
plot(Delta)
% 
% Sum of Squared Error(平方差和):
SSE = sum((FitDayTh-TtlUsrNum).^2);
str = sprintf('SSE(平方差和)为：%.10e', SSE);
disp(str)
% Mean Squared Error(均方差):
MSE = SSE/n;
str = sprintf('MSE(均方差)为：%.10e', MSE);
disp(str)
% Root Mean Squared Error(均方根误差):
RMSE = sqrt(MSE);
str = sprintf('RMSE(均方根误差)为：%.10e', RMSE);
disp(str)
% Sum of Squares of the Regression(预测数据与原始数据均值之差的平方和,即残差或剩余误差的平方和):
SSR = sum( (FitDayTh - (sum(TtlUsrNum)/n)).^2 );
str = sprintf('SSR(预测数据与原始数据均值之差的平方和)为：%.10e', SSR);
disp(str)
% Total Sum of Squares(原始数据和均值之差的平方和):
% SST = SSE+SSR
SST = sum( (TtlUsrNum - (sum(TtlUsrNum)/n)).^2 );
str = sprintf('SST(原始数据和均值之差的平方和)为：%.10e', SST);
disp(str)
% R_Square(确定系数,表征拟合的好坏,越接近1越好):
R_Square = SSR/SST;
str = sprintf('R-Square(确定系数,表征拟合的好坏,越接近1越好)为：%.10e', R_Square);
disp(str)