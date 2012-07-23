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
DataFrom = 200;
DataTo = 638;
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
R_SquareMin = 0.99;
% 相对误差允许的最大值：
RelErrMax = 1000;
Left = 60;

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

    % 取总数据的前0.618部分参与拟合:
    DayThGldSct_Left = 1:ceil(n*0.618);
    DayThGldSct_Right = (length(DayThGldSct_Left)+1):n;
    TtlUsrNumGldSct_Left = TtlUsrNum(1:length(DayThGldSct_Left));
    TtlUsrNumGldSct_Right = TtlUsrNum((length(DayThGldSct_Left)+1):n);
    [ParasGldSct, StructGldSct] = polyfit(DayThGldSct_Left, TtlUsrNumGldSct_Left, Degree);
    FitTimeGldSct = polyval(ParasGldSct, Time);
    FitDayThGldSct = polyval(ParasGldSct, DayTh);
    FitDayThGldSct_Left = polyval(ParasGldSct, DayThGldSct_Left);
    FitDayThGldSct_Right = polyval(ParasGldSct, DayThGldSct_Right);
    % 计算相对误差:
    RelErrGldSct = 100*abs(TtlUsrNum-FitDayThGldSct)./TtlUsrNum;
    for i = 1:length(RelErrGldSct)
        if(RelErrGldSct(i)>RelErrMax)
            RelErrGldSct(i) = RelErrMax;
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
    
    % 计算取总数据的前0.618部分参与拟合时的误差:
    SSE_GldSct_Left = sum((FitDayThGldSct_Left-TtlUsrNumGldSct_Left).^2);
    SSE_GldSct_Right = sum((FitDayThGldSct_Right-TtlUsrNumGldSct_Right).^2);
    SSE_GldSct_All = sum((FitDayThGldSct-TtlUsrNum).^2);
    MSE_GldSct_Left = SSE_GldSct_Left/length(DayThGldSct_Left);
    MSE_GldSct_Right = SSE_GldSct_Right/length(DayThGldSct_Right);
    MSE_GldSct_All = SSE_GldSct_All/n;
    RMSE_GldSct_Left = sqrt(MSE_GldSct_Left);
    RMSE_GldSct_Right = sqrt(MSE_GldSct_Right);
    RMSE_GldSct_All = sqrt(MSE_GldSct_All);
    SSR_GldSct_Left = sum( (FitDayThGldSct_Left - (sum(TtlUsrNumGldSct_Left)/length(DayThGldSct_Left))).^2 );
    SSR_GldSct_Right = sum( (FitDayThGldSct_Right - (sum(TtlUsrNumGldSct_Right)/length(DayThGldSct_Right))).^2 );
    SSR_GldSct_All = sum( (FitDayThGldSct - (sum(TtlUsrNum)/n)).^2 );
    SST_GldSct_Left = sum( (TtlUsrNumGldSct_Left - (sum(TtlUsrNumGldSct_Left)/length(DayThGldSct_Left))).^2 );
    SST_GldSct_Right = sum( (TtlUsrNumGldSct_Right - (sum(TtlUsrNumGldSct_Right)/length(DayThGldSct_Right))).^2 );
    SST_GldSct_All = SST;
    R_SquareGldSct_Left = SSR_GldSct_Left/SST_GldSct_Left;
    R_SquareGldSct_Right = SSR_GldSct_Right/SST_GldSct_Right;
    R_SquareGldSct_All = SSR_GldSct_All/SST_GldSct_All;
    
	% 做图并自动保存到本地
	if(R_Square > R_SquareMin)
		str = sprintf('多项式阶数为%d, R_Square为%.10f', Degree, R_Square);
		Handle = figure('name', str, 'position', [Left, 0, 1400, 750]);
		Left = Left+30;
        % 绘制 拟合曲线：
		subplot(2, 2, 1); plot(DayTh, TtlUsrNum, '.', 'color', 'b', 'MarkerSize', 3)
		str = sprintf('Poly Fitting the Num of Ttl Usr(RSquare=%.10f)', R_Square);
		title(str)
		xlabel('Time(Day)')
		ylabel('Num of Total User')
		% text(10, 5*10^5, strcat('y=', poly2str(Paras, 'x')));
		hold on
        plot(Time, FitTime, 'color', 'r')
		legend('Standard ', 'Fitted', 'Location', 'NorthWest')
        grid on
        % 绘制拟合函数与真实值的 相对误差 随时间变化的曲线:
        subplot(2, 2, 3); plot(DayTh, RelErr, 'color', 'r')
        str = sprintf('Relative Err(All Rel Errs Bigger then %d is recorded as %d)', RelErrMax, RelErrMax);
        title(str)
        xlabel('Time(Day)')
		ylabel('Relative Error(%)')
        % 取总数据的前0.618部分参与拟合，生成的 拟合曲线:
        subplot(2, 2, 2); plot(DayTh, TtlUsrNum, '.', 'color', 'b', 'MarkerSize', 3)
		str = sprintf('Poly of GldSct Fitting Num of Ttl Usr(RSquareGldSctRight=%.7f)', R_SquareGldSct_Right);
		title(str)
		xlabel('Time(Day)')
		ylabel('Num of Total User')
		% text(10, 5*10^5, strcat('y=', poly2str(ParasGldSct, 'x')));
        hold on
        plot(Time, FitTimeGldSct, 'color', 'r');
        legend('Standard ', 'GldSct Fitted', 'Location', 'NorthWest')
        hold on
        plot([length(DayThGldSct_Left), length(DayThGldSct_Left)], [0, max(TtlUsrNumGldSct_Right)], 'color', 'r');
        text(length(DayThGldSct_Left)-40, max(TtlUsrNumGldSct_Right)/2, 'Golden Section')
        grid on
        % 取总数据的前0.618部分参与拟合，生成的拟合函数与真实值的 相对误差 随时间变化的曲线:
        subplot(2, 2, 4); plot(DayTh, RelErrGldSct, 'color', 'r')
        str = sprintf('Relative Err of GldSct Curving(All Rel Errs Bigger then %d is recorded as %d)', RelErrMax, RelErrMax);
        title(str)
        xlabel('Time(Day)')
		ylabel('Relative Error(%)')

        % 保存图片到文件
		str = sprintf('TotalUsrNum_%d_%d_PolyFit_Deg-%d', DataFrom, DataTo, Degree);
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
    disp('----------------------------')
    str = sprintf('当取总数据的前0.618部分参与拟合时：\n  拟合的多项式为:\ny =%s', poly2str(ParasGldSct, 'x'));
    disp(str)
    disp('黄金分割线左边的情况是：')
    str = sprintf('SSE_GldSct_Left(平方差和)为：%.10e', SSE_GldSct_Left);
	disp(str)
	str = sprintf('MSE_GldSct_Left(均方差)为：%.10e', MSE_GldSct_Left);
	disp(str)
	str = sprintf('RMSE_GldSct_Left(均方根误差)为：%.10e', RMSE_GldSct_Left);
	disp(str)
	str = sprintf('SSR_GldSct_Left(预测数据与原始数据均值之差的平方和)为：%.10e', SSR_GldSct_Left);
	disp(str)
	str = sprintf('SST_GldSct_Left(原始数据和均值之差的平方和)为：%.10e', SST_GldSct_Left);
	disp(str)
	str = sprintf('R-SquareGldSct_Left(确定系数,表征拟合的好坏,越接近1越好)为：%.10e', R_SquareGldSct_Left);
    disp(str)
    disp('黄金分割线右边的情况是：')
    str = sprintf('SSE_GldSct_Right(平方差和)为：%.10e', SSE_GldSct_Right);
	disp(str)
	str = sprintf('MSE_GldSct_Right(均方差)为：%.10e', MSE_GldSct_Right);
	disp(str)
	str = sprintf('RMSE_GldSct_Right(均方根误差)为：%.10e', RMSE_GldSct_Right);
	disp(str)
	str = sprintf('SSR_GldSct_Right(预测数据与原始数据均值之差的平方和)为：%.10e', SSR_GldSct_Right);
	disp(str)
	str = sprintf('SST_GldSct_Right(原始数据和均值之差的平方和)为：%.10e', SST_GldSct_Right);
	disp(str)
	str = sprintf('R-SquareGldSct_Right(确定系数,表征拟合的好坏,越接近1越好)为：%.10e', R_SquareGldSct_Right);
    disp(str)
    disp('总体的情况是：')
    str = sprintf('SSE_GldSct_All(平方差和)为：%.10e', SSE_GldSct_All);
	disp(str)
	str = sprintf('MSE_GldSct_All(均方差)为：%.10e', MSE_GldSct_All);
	disp(str)
	str = sprintf('RMSE_GldSct_All(均方根误差)为：%.10e', RMSE_GldSct_All);
	disp(str)
	str = sprintf('SSR_GldSct_All(预测数据与原始数据均值之差的平方和)为：%.10e', SSR_GldSct_All);
	disp(str)
	str = sprintf('SST_GldSct_All(原始数据和均值之差的平方和)为：%.10e', SST_GldSct_All);
	disp(str)
	str = sprintf('R-SquareGldSct_All(确定系数,表征拟合的好坏,越接近1越好)为：%.10e', R_SquareGldSct_All);
    disp(str)
    str = sprintf('===========================================================\n\n');
	disp(str)
end