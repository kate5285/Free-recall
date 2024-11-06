clear all;clc;
%% load file
filename= "C:\Users\Leelab_Intern\Desktop\doyeon kim\free recall\timepoints_merge.xlsx"; % file directory for free recall behavioral data
partici =readcell(filename, 'Sheet', 1, 'Range','A:A');
numRows = numel(partici)-1;
VariableNames = readcell(filename, 'Range', 'A1:P1');
recall = readtable(filename, 'Range', sprintf('A2:P%d',numRows+1));
recall.Properties.VariableNames = VariableNames;

wfilename= "C:\Users\Leelab_Intern\Desktop\doyeon kim\free recall\recallwords.xlsx"; % file directory for word list shown to participants (in Korean)
recallwords = readtable(wfilename, 'Range', sprintf('A1:H10'));
kfilename= "C:\Users\Leelab_Intern\Desktop\doyeon kim\free recall\kortoeng.xlsx"; % file directory for word list shown to participants (in English)
ktoengwords = readtable(kfilename, 'Range', sprintf('A1:H10'));

%load sbj info
filename= "C:\Users\Leelab_Intern\Desktop\doyeon kim\free recall\www_info_DY.xlsx";
partici =readcell(filename, 'Sheet', 1, 'Range','A:A');
numRows = numel(partici)-1;
VariableNames = readcell(filename, 'Range', 'A1:G1');
info = readtable(filename, 'Range', sprintf('A2:G%d',numRows+1));
info.Properties.VariableNames = VariableNames;
age=info{:,3};
mmse=info{:,7};
edu=info{:,4};
