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
        trial_struct.sbj=block_data{:,'SBJ #'}{1}; % subject number

        trial_struct.ansnum = block_data{:,'Answer #'}; % number of answers

        if any(trial_struct.ansnum == 0)
        trial_struct.allansnum = numel(trial_struct.ansnum) - 1; %total number of recalls
        else
        disp("wrong ans 0");
        end

        trial_struct.answord = block_data.word; % words that are recalled
        trial_struct.wrongword = block_data{:,'wrong word'}; % wrong recalls
        trial_struct.anstime = block_data.time; % time points of recall

        num_wrong_words = sum(~cellfun(@isempty, trial_struct.wrongword)); 
        trial_struct.ransnum = trial_struct.allansnum - num_wrong_words; % number of correct recalls
   
        trial_struct.serial = block_data{:,'Trial (BLOCK) #'}(1,1); %order of the blocks presented
        blocks{j} = trial_struct;
    end
    Alldata{i} = blocks;
end
numSubjects = length(Alldata);

%delete repeated words
for i = 1:numSubjects
    trials = Alldata{i, 1};
    numBlocks = length(trials);
    
    for j = 1:numBlocks
        answord = trials{j, 1}.answord;
        ansnum = trials{j, 1}.ansnum;
        allansnum = trials{j, 1}.allansnum;
        ransnum = trials{j, 1}.ransnum;
        anstime = trials{j, 1}.anstime;

        [uniqueWords, eh, idx] = unique(answord, 'stable'); 
        [uniqueVals, ~, occurrences] = unique(idx);
        duplicateVals = uniqueVals(histcounts(idx, 1:max(idx)+1) > 1);

        if ~isempty(duplicateVals)
            for m=1:numel(duplicateVals)
                if isempty(trials{j, 1}.answord{duplicateVals(m)})
                duplicateIndices=[];
                else 
                duplicateI=find(idx==duplicateVals(m));
                duplicateIndices=duplicateI(2:end);
                end
            end
        elseif isempty(duplicateVals)
            continue
        end

        if ~isempty(duplicateIndices)
            answord(duplicateIndices) = {''}; 
            ansnum(duplicateIndices) = NaN; 
            allansnum = allansnum-numel(duplicateIndices);
            ransnum=ransnum-numel(duplicateIndices); 
            anstime(duplicateIndices) = NaN; 

            Alldata{i, 1}{j, 1}.answord = answord;
            Alldata{i, 1}{j, 1}.ansnum = ansnum;
            Alldata{i, 1}{j, 1}.allansnum = allansnum;
            Alldata{i, 1}{j, 1}.ransnum = ransnum;
            Alldata{i, 1}{j, 1}.anstime = anstime;
        end
    end
end
