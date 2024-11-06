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

%organize data
subjects = unique(recall{:,'SBJ #'});
Alldata = cell(length(subjects), 1);
for i = 1:length(subjects)
    subj_data = recall(strcmp(recall{:,'SBJ #'}, subjects{i}), :);
    blockn = unique(subj_data{:,'Trial (BLOCK) #'});
    blocks = cell(length(blockn), 1);
    for j = 1:length(blockn)
        block_data = subj_data(subj_data{:,'Trial (BLOCK) #'} == blockn(j), :);
        trial_struct = struct();
        trial_struct.sbj=block_data{:,'SBJ #'}{1};

        trial_struct.ansnum = block_data{:,'Answer #'};

        if any(trial_struct.ansnum == 0)
        trial_struct.allansnum = numel(trial_struct.ansnum) - 1;
        else
        disp("wrong ans 0");
        end

        trial_struct.answord = block_data.word;
        trial_struct.wrongword = block_data{:,'wrong word'};
        trial_struct.anstime = block_data.time;

        num_wrong_words = sum(~cellfun(@isempty, trial_struct.wrongword)); % 오답 단어 수
        trial_struct.ransnum = trial_struct.allansnum - num_wrong_words;
   
        trial_struct.serial = block_data{:,'Trial (BLOCK) #'}(1,1);
        blocks{j} = trial_struct;
    end
    Alldata{i} = blocks;
end
numSubjects = length(Alldata);
