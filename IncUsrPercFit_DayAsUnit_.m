% 拟合新增用户占总用户数的百分比
clear, clc;
format long;
warning off MATLAB:polyfit:RepeatedPointsOrRescale;
DataFrom = 200;
DataTo = 638;
% 提取用户总数数据
TtlUsrDataFile = '~/Documents/CurveFit/TotalUserNum_Sp.dat';
if((exist(TtlUsrDataFile, 'file'))==2)
	TtlUsrNum = load(TtlUsrDataFile);
	[PathStr, Name, Ext] = fileparts(TtlUsrDataFile);
	cd(PathStr)
else
	str = sprintf('数据文件%s不存在，请修改脚本第8行的参数指向对应的数据文件！！', TtlUsrDataFile);
	disp(str)
	return
end
% 提取新增用户数据
IncUsrDataFile = 'IncUserNum_Sp.dat';
if((exist(IncUsrDataFile, 'file'))==2)
	IncUsrNum = load(IncUsrDataFile);
	[PathStr, Name, Ext] = fileparts(IncUsrDataFile);
else
	str = sprintf('数据文件%s不存在，请修改脚本第19行的参数指向对应的数据文件！！', IncUsrDataFile);
	disp(str)
	return
end
DataAlter = [73, 135, 175, 176, 190, 212, 213, 214, 215, 216, 217, 281, 282, 439, 488, 489, 535, 536, 560, 608, 623, 631, 621];
IncUsrNumAlted = IncUsrNum;
for i = 1:1:length(IncUsrNum)
    if ismember(i, DataAlter)
        IncUsrNumAlted(i) = int32((IncUsrNumAlted(i-2)+IncUsrNumAlted(i-1)+IncUsrNum(i+1)+IncUsrNum(i+2))/4);
    end
end

% 计算新增用户数占用户总数的百分比的真实值
IncUsrPerc = IncUsrNumAlted./TtlUsrNum;
% 根据DataFrom与DataTo重新调整数据为待拟合期间
n = DataTo-DataFrom+1;
TtlUsrNum = TtlUsrNum(DataFrom:DataTo);
IncUsrNumAlted = IncUsrNumAlted(DataFrom:DataTo);
IncUsrPerc = IncUsrPerc(DataFrom:DataTo);
DayTh = 1:n;
% 依照之前找到的最佳方案进行拟合
ParasTtl = polyfit(DayTh, TtlUsrNum, 3);
ParasInc = polyfit(DayTh, IncUsrNumAlted, 2);
% 计算新增用户占总用户数的百分比的拟合值及预测值
IncUsrPercPrevDayTh = 1:floor(n/0.618);
IncusrPercPrev = polyval(ParasInc, IncUsrPercPrevDayTh) ./ polyval(ParasTtl, IncUsrPercPrevDayTh);
% 画图
Handle = figure('name', '对新增用户占总用户数的百分比进行拟合', 'position', [150, 200, 700, 600]);
plot(DayTh+DataFrom-1, 100*IncUsrPerc, '.', 'color', 'b');
ylabel('Percent(%)');
xlabel('Time(Day)');
grid on;
hold on;
plot(IncUsrPercPrevDayTh+DataFrom-1, 100*IncusrPercPrev, 'color', 'r')
hold on;
plot([n+DataFrom-1, n+DataFrom-1], [0, max(100*IncUsrPerc)], 'color', 'r');
text(n+DataFrom-50, max(100*IncUsrPerc)/2, 'Gold Section');
legend('Standard ', 'Preview Followed behind the Gold Sect', 'Location', 'NorthEast')
% 保存图片到文件
str = sprintf('./Pictures/对新增用户占总用户数的百分比进行拟合(以天为单位)');
% saveas(Handle, str, 'fig')  % Matlab格式
% saveas(Handle, str, 'epsc')  % 矢量图
saveas(Handle, str, 'png')  % png格式