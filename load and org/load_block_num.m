 load('C:\Users\Leelab_Intern\Desktop\doyeon kim\free recall\boundary_file1.mat')  % load block numbers
 numSubjects = length(Alldata);
 for i = 1:numSubjects
        correct_block_order = word_boundary{i};
        for j = 1:length(correct_block_order)  
            Alldata{i,1}{j,1}.blocknum = correct_block_order(j);
        end
end

%position of recalled word within that block
numSubjects = length(Alldata);
position = cell(numSubjects, 1);

for i = 1:numSubjects
    trials = Alldata{i, 1};
    numBlocks = length(trials);
    position{i} = cell(numBlocks, 1);

    if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
        position{i} = [];
    continue; 
    end

    for j = 1:numBlocks
        blocknum = trials{j, 1}.blocknum;
        answord = trials{j, 1}.answord;
        recallwords_block = table2cell(recallwords(blocknum, :));
        position{i}{j} = [];
        for k = 1:length(answord)
            if ~isempty(answord{k}) 
                matchIdx = find(strcmp(recallwords_block, answord{k}));
                if ~isempty(matchIdx) 
                    position{i}{j} = vertcat(position{i}{j}, matchIdx);
                end
            end
        end
    end
end
