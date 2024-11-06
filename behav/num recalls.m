%average number of recalls made
numSubjects = length(Alldata);
bound4 = cell(numSubjects, 1);
bound5 = cell(numSubjects, 1);
boundn = cell(numSubjects, 1);
mean4 = cell(numSubjects, 1);
mean5 = cell(numSubjects, 1);
meann = cell(numSubjects, 1);

for i = 1:numSubjects
    trials = Alldata{i, 1};
    numBlocks = length(trials);
    ransum_123 = []; 
    ransum_456 = []; 
    ransum_789 = [];  

    if any(~cellfun(@(x) isfield(x, 'blocknum'), trials)) %if that trial for that participant was disturbed 
        bound4{i} = [];
        bound5{i} = [];
        boundn{i} = [];
    continue; % skip that trial
    end

    for j = 1:numBlocks
        blocknum = trials{j, 1}.blocknum;
        
        if any(blocknum == [1, 2, 3])
            ransum_123 = [ransum_123, trials{j, 1}.ransnum];
        elseif any(blocknum == [4, 5, 6])
            ransum_456 = [ransum_456, trials{j, 1}.ransnum];
        elseif any(blocknum == [7, 8, 9])
            ransum_789 = [ransum_789, trials{j, 1}.ransnum];
        elseif ~isfield(trials{j, 1}, 'blocknum')
        continue;
        end
    end

        bound4{i} = ransum_123;
        bound5{i} = ransum_456;
        boundn{i} = ransum_789;

        mean4{i}  = nanmean(bound4{i});  
        mean5{i}  = nanmean(bound5{i});
        meann{i}  = nanmean(boundn{i});
end

tmean4 = nanmean(cell2mat(mean4));  
tmean5 = nanmean(cell2mat(mean5));
tmeann = nanmean(cell2mat(meann));

means=[tmean4, tmean5, tmeann];
SE4 = nanstd(cell2mat(mean4)) / sqrt(sum(~cellfun('isempty', mean4)));  
SE5 = nanstd(cell2mat(mean5)) / sqrt(sum(~cellfun('isempty', mean5)));
SEn = nanstd(cell2mat(meann)) / sqrt(sum(~cellfun('isempty', meann)));
SEs=[SE4, SE5, SEn];

figure;
bar(means);
hold on;
errorbar(1:3, means, SEs, 'k', 'linestyle', 'none');
hold off;
set(gca, 'XTickLabel', {'Boundary 4:4', 'Boundary 5:3', 'No Boundary'});  
ylabel('average number of recalls(correct ones)');
