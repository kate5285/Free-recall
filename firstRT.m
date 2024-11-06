numSubjects = length(Alldata);
frtbound4 = cell(numSubjects, 1);
frtbound5 = cell(numSubjects, 1);
frtboundn = cell(numSubjects, 1);
frtmean4 = cell(numSubjects, 1);
frtmean5 = cell(numSubjects, 1);
frtmeann = cell(numSubjects, 1);

for i = 1:numSubjects
    trials = Alldata{i, 1};
    numBlocks = length(trials);
    ransum_123 = []; 
    ransum_456 = []; 
    ransum_789 = [];  

    if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
        frtbound4{i} = [];
        frtbound5{i} = [];
        frtboundn{i} = [];
    continue; 
    end

    for j = 1:numBlocks
        blocknum = trials{j, 1}.blocknum;

        if isempty(rts{i, 1}{j, 1})
        rts_value = NaN; 
        else
        rts_value = rts{i, 1}{j, 1}(1); %first word RT
        end

        if any(blocknum == [1, 2, 3])
            ransum_123 = vertcat(ransum_123, rts_value);
        elseif any(blocknum == [4, 5, 6])
            ransum_456 = vertcat(ransum_456, rts_value);
        elseif any(blocknum == [7, 8, 9])
            ransum_789 =vertcat(ransum_789, rts_value);
        elseif ~isfield(trials{j, 1}, 'blocknum')
        continue;
        end
    end
        frtbound4{i} = ransum_123;
        frtbound5{i} = ransum_456;
        frtboundn{i} = ransum_789;

        frtmean4{i}  = nanmean(frtbound4{i});  
        frtmean5{i}  = nanmean(frtbound5{i});
        frtmeann{i}  = nanmean(frtboundn{i});
end

ftrtmean4 = nanmean(cell2mat(frtmean4));  
ftrtmean5 = nanmean(cell2mat(frtmean5));
ftrtmeann = nanmean(cell2mat(frtmeann));
frtmeans=[ftrtmean4, ftrtmean5, ftrtmeann];
frtSE4 = nanstd(cell2mat(frtmean4)) / sqrt(sum(~cellfun('isempty', frtmean4)));  
frtSE5 = nanstd(cell2mat(frtmean5)) / sqrt(sum(~cellfun('isempty', frtmean5)));
frtSEn = nanstd(cell2mat(frtmeann)) / sqrt(sum(~cellfun('isempty', frtmeann)));
frtSEs=[frtSE4, frtSE5, frtSEn];

figure;
bar(frtmeans); %first word RT accprding to boundary types of free recall word list
hold on;
errorbar(1:3, frtmeans, frtSEs, 'k', 'linestyle', 'none');  
hold off;
set(gca, 'XTickLabel', {'Boundary 4:4', 'Boundary 5:3', 'No Boundary'});  
ylabel('average first RT of recalls(correct ones)'); 
