rt = cell(numSubjects, 1); 
rts = cell(numSubjects, 1); 
kk = cell(numSubjects, 1); 
for i = 1:numSubjects
    trials = Alldata{i, 1};
    numBlocks = length(trials);
    rt{i} = cell(numBlocks,1); 
    rts{i} = cell(numBlocks,1);
    kk{i} = cell(numBlocks,1); 
    
    for j = 1:numBlocks
        anstime = trials{j, 1}.anstime; 
        answord = trials{j, 1}.answord;  
        validIndices = find(~cellfun(@isempty, answord));
        rt{i}{j} = anstime;
        if ~isempty(validIndices)
            firstRT = anstime(1); 
            rts{i}{j} = zeros(length(validIndices), 1); 
            rts{i}{j}(1) = anstime(validIndices(1)) - firstRT;
            for k = 2:length(validIndices)
                rts{i}{j}(k) = anstime(validIndices(k)) - anstime(validIndices(k-1));
            end
            kk{i}{j}= validIndices;
        end
    end
end
