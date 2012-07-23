% 注意, 执行脚本时请修改第6行的参数指向对应的数据文件！！
clear, clc;
format long;
warning off MATLAB:polyfit:RepeatedPointsOrRescale;
% 待处理的数据文件:
DataFile = '~/Documents/CurveFit/TotalUserNum_Sp.dat';
if((exist(DataFile, 'file'))==2)
	TtlUsrNum = load(DataFile);
	[PathStr, Name, Ext] = fileparts(DataFile);
	cd(PathStr)
else
	str = sprintf('数据文件%s不存在，请修改脚本第6行的参数指向对应的数据文件！！', DataFile);
	disp(str)
	return
end
n = length(TtlUsrNum);
DataFrom = 1;
DataTo = 200;
str = sprintf('从文件 %s 中获取了 %d 个数据, 取其中的 第%d天到第%d天 的数据进行拟合.', DataFile, n, DataFrom, DataTo);
disp(str)
% 现在n表示参加拟合的数据总个数:
n = DataTo-DataFrom+1;
TtlUsrNum = TtlUsrNum(DataFrom:DataTo);
DayTh = 1:n;
Time = 0:0.001:n;
% 多项式拟合的最大阶数:
DegreeMax = 9;
% R_Square允许的最小值（比此值小的情况将不在终端打印和做图）:
% 可调小此值，以打印所有情况。
R_SquareMin = 0.999;
% 相对误差允许的最大值：
RelErrMax = 1000;
Left = 50;

str = sprintf('将依次用 2阶～%d阶的多项式 拟合用户总数随时间变化的曲线，并对R_Square大于%.10f的情况做图。\n\n', DegreeMax, R_SquareMin);
disp(str)
for Degree = 2:DegreeMax
	% 多项式拟合曲线:
	% DayThStd = (DayTh-mean(DayTh))./std(DayTh);
	[Paras, Struct] = polyfit(DayTh, TtlUsrNum, Degree);
	FitTime = polyval(Paras, Time);
	FitDayTh = polyval(Paras, DayTh);
    % 计算相对误差:
    RelErr = 100*abs(TtlUsrNum-FitDayTh)./TtlUsrNum;
    for i = 1:length(RelErr)
        if(RelErr(i)>RelErrMax)
            RelErr(i) = RelErrMax;
        end
    end

	% 计算误差:
	% Sum of Squared Error(平方差和):
	SSE = sum((FitDayTh-TtlUsrNum).^2);
	% Mean Squared Error(均方差):
	MSE = SSE/n;
	% Root Mean Squared Error(均方根误差):
	RMSE = sqrt(MSE);
	% Sum of Squares of the Regression(预测数据与原始数据均值之差的平方和,即残差或剩余误差的平方和):
	SSR = sum( (FitDayTh - (sum(TtlUsrNum)/n)).^2 );
	% Total Sum of Squares(原始数据和均值之差的平方和):
	% SST = SSE+SSR
	SST = sum( (TtlUsrNum - (sum(TtlUsrNum)/n)).^2 );
	% R_Square(确定系数,表征拟合的好坏,越接近1越好):
	R_Square = SSR/SST;

	% 做图并自动保存到本地
	if(R_Square > R_SquareMin)
		str = sprintf('多项式阶数为%d, R_Square为%.10f', Degree, R_Square);
		Handle = figure('name', str, 'position', [Left, 0, 750, 750]);
		Left = Left+120;
        % 绘制拟合曲线随时间变化的图形：
		subplot(2, 1, 1); plot(DayTh, TtlUsrNum, '.', 'color', 'b', 'MarkerSize', 3)
		str = sprintf('Polynomial Fitting the Num of Total User(Degree=%d, RSquare=%.10f)', Degree, R_Square);
		title(str)
		xlabel('Time(Day)')
		ylabel('Num of Total User')
		text(10, 5*10^5, strcat('y =', poly2str(Paras, 'x')));
		hold on
        plot(Time, FitTime, 'color', 'r')
		legend('Standard ', 'Fitted', 'Location', 'NorthWest')
        grid on
        % 绘制拟合函数与真实值的相对误差随时间变化的图形:
        subplot(2, 1, 2);
        plot(DayTh, RelErr, 'color', 'r')
        str = sprintf('Relative Error(All Rel Errs Bigger then %d is recorded as %d)', RelErrMax, RelErrMax);
        title(str)
        xlabel('Time(Day)')
		ylabel('Relative Error(%)')
        % 保存图片到文件
		str = sprintf('TotalUsrNum_1_200_PolyFit_Deg-%d', Degree);
		saveas(Handle, str, 'fig')  % Matlab格式
		saveas(Handle, str, 'epsc')  % 矢量图
		saveas(Handle, str, 'png')  % png格式
	end

	% 打印误差
	str = sprintf('%d阶多项式拟合的误差分析：', Degree);
	disp(str)
	str = sprintf('拟合的%d阶多项式为:\ny =%s', Degree, poly2str(Paras, 'x'));
	disp(str)
	str = sprintf('SSE(平方差和)为：%.10e', SSE);
	disp(str)
	str = sprintf('MSE(均方差)为：%.10e', MSE);
	disp(str)
	str = sprintf('RMSE(均方根误差)为：%.10e', RMSE);
	disp(str)
	str = sprintf('SSR(预测数据与原始数据均值之差的平方和)为：%.10e', SSR);
	disp(str)
	str = sprintf('SST(原始数据和均值之差的平方和)为：%.10e', SST);
	disp(str)
	str = sprintf('R-Square(确定系数,表征拟合的好坏,越接近1越好)为：%.10e', R_Square);
	disp(str)
	str = sprintf('\n');
	disp(str)
end