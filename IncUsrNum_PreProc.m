% 对新增用户数据进行预处理
clear, clc;
format long;
% 待处理的数据文件:
DataFile = '~/Documents/CurveFit/IncUserNum_Sp.dat';
if((exist(DataFile, 'file'))==2)
	IncUsrNum = load(DataFile);
	[PathStr, Name, Ext] = fileparts(DataFile);
	cd(PathStr)
else
	str = sprintf('数据文件%s不存在，请修改脚本第5行的参数指向对应的数据文件！！', DataFile);
	disp(str)
	return
end

% 原始数据：
DayTh = 1:length(IncUsrNum);
Handle = figure('name', '对新增用户数的预处理-(原始数据--对部分点替换后的数据--以星期为单位的数据)','position', [80, 0, 1450, 750]);
subplot(1, 3, 1);
plot(DayTh, IncUsrNum, '.');
title('Original Data'); xlabel('Time(Day As Unit)'); ylabel('Increased Usr Num')

% 对 第135天、439天等 部分十分抖动的点进行替换：
DataAlter = [73, 135, 175, 176, 190, 212, 213, 214, 215, 216, 217, 281, 282, 439, 488, 489, 535, 536, 560, 608, 623, 631, 621];
IncUsrNumAlted = IncUsrNum;
for i = 1:1:length(DayTh)
    if ismember(i, DataAlter)
        IncUsrNumAlted(i) = int32((IncUsrNumAlted(i-2)+IncUsrNumAlted(i-1)+IncUsrNum(i+1)+IncUsrNum(i+2))/4);
    end
end
subplot(1, 3, 2)
plot(DayTh, IncUsrNumAlted, '.')
title('Altered Data(Day As Unit)'); xlabel('Time(Day As Unit)'); ylabel('Increased Usr Num')

% 时间轴以星期为单位:
DayTh_WeekAsUnit = 1:1:floor(length(DayTh)/7);
IncUsrNumAlted_WeekAsUnit = 1:1:length(DayTh_WeekAsUnit);
for i = 1:1:length(DayTh_WeekAsUnit)
    IncUsrNumAlted_WeekAsUnit(i) = IncUsrNumAlted((i-1)*7+mod(length(DayTh),7)+1) +IncUsrNumAlted((i-1)*7+mod(length(DayTh),7)+2) +IncUsrNumAlted((i-1)*7+mod(length(DayTh),7)+3) +IncUsrNumAlted((i-1)*7+mod(length(DayTh),7)+4) +IncUsrNumAlted((i-1)*7+mod(length(DayTh),7)+5) +IncUsrNumAlted((i-1)*7+mod(length(DayTh),7)+6) +IncUsrNumAlted((i-1)*7+mod(length(DayTh),7)+7);
end
subplot(1, 3, 3)
plot(DayTh_WeekAsUnit, IncUsrNumAlted_WeekAsUnit, '.')
title('Altered Data(Week As Unit)'); xlabel('Time(Week As Unit)'); ylabel('Increased Usr Num')

% 保存图片到本地文件
str = sprintf('./Pictures/对新增用户数目的预处理-(原始数据--对部分点替换后的数据--以星期为单位的数据)');
% saveas(Handle, str, 'fig')  % Matlab格式
% saveas(Handle, str, 'epsc')  % 矢量图
saveas(Handle, str, 'png')  % png格式
