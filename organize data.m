numSubjects = length(Alldata);
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
