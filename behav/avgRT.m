numSubjects = length(Alldata);
rtbound4 = cell(numSubjects, 1);
rtbound5 = cell(numSubjects, 1);
rtboundn = cell(numSubjects, 1);
rtmean4 = cell(numSubjects, 1);
rtmean5 = cell(numSubjects, 1);
rtmeann = cell(numSubjects, 1);

for i = 1:numSubjects
    trials = Alldata{i, 1};
    numBlocks = length(trials);
    ransum_123 = []; 
    ransum_456 = []; 
    ransum_789 = [];  

    if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
        rtbound4{i} = [];
        rtbound5{i} = [];
        rtboundn{i} = [];
    continue; 
    end

    for j = 1:numBlocks
        blocknum = trials{j, 1}.blocknum;

        if isempty(rts{i, 1}{j, 1})
        rts_value = NaN;
        else
        rts_value = rts{i, 1}{j, 1}; 
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
        rtbound4{i} = ransum_123;
        rtbound5{i} = ransum_456;
        rtboundn{i} = ransum_789;

        rtmean4{i}  = nanmean(rtbound4{i});  
        rtmean5{i}  = nanmean(rtbound5{i});
        rtmeann{i}  = nanmean(rtboundn{i});
end

trtmean4 = nanmean(cell2mat(rtmean4));  
trtmean5 = nanmean(cell2mat(rtmean5));
trtmeann = nanmean(cell2mat(rtmeann));
rtmeans=[trtmean4, trtmean5, trtmeann];
rtSE4 = nanstd(cell2mat(rtmean4)) / sqrt(sum(~cellfun('isempty', rtmean4)));  
rtSE5 = nanstd(cell2mat(rtmean5)) / sqrt(sum(~cellfun('isempty', rtmean5)));
rtSEn = nanstd(cell2mat(rtmeann)) / sqrt(sum(~cellfun('isempty', rtmeann)));
rtSEs=[rtSE4, rtSE5, rtSEn];

figure;
bar(rtmeans);
hold on;
errorbar(1:3, rtmeans, rtSEs, 'k', 'linestyle', 'none');
hold off;
set(gca, 'XTickLabel', {'Boundary 4:4', 'Boundary 5:3', 'No Boundary'});  
ylabel('average RT of recalls(correct ones)'); 
