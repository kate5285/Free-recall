%%recall frequency according to position
numSubjects = length(Alldata);
recblock4= cell(numSubjects, 1);
recblock5= cell(numSubjects, 1);
recblockn= cell(numSubjects, 1);

for i = 1:numSubjects
    positions = position{i,1};  
    trials = Alldata{i, 1};
    numBlocks = length(trials);

    recall_rate4 = zeros(8, 1);  
    recall_rate5 = zeros(8, 1);
    recall_rate_n = zeros(8, 1);

    pos4 = [];
    pos5 = [];
    posn = [];

    if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
        recblock4{i} = [];
        recblock5{i} = [];
        recblockn{i} = [];
        continue; 
    end

    for j = 1:numBlocks
        blocknum = trials{j, 1}.blocknum;
        posData = positions{j}; 
        
        if any(blocknum == [1, 2, 3])
            pos4 = vertcat(pos4, posData); 
        elseif any(blocknum == [4, 5, 6])
            pos5 = vertcat(pos5, posData);  
        elseif any(blocknum == [7, 8, 9])
            posn = vertcat(posn, posData);  
        end
    end

    for k = 1:8
        recall_rate4(k) = sum(pos4 == k) /3; 
        recall_rate5(k) = sum(pos5 == k) /3; 
        recall_rate_n(k) = sum(posn == k) /3; 
    end

    recblock4{i} = recall_rate4;
    recblock5{i} = recall_rate5;
    recblockn{i} = recall_rate_n;
end

allpos4=cell(8, 1);
allpos5=cell(8, 1);
allposn=cell(8, 1);

for pos = 1:8
    for i = 1:numSubjects
        if ~isempty(recblock4{i}) && length(recblock4{i}) >= pos
            allpos4{pos} = [allpos4{pos}; recblock4{i}(pos)];
        end
        if ~isempty(recblock5{i}) && length(recblock5{i}) >= pos
            allpos5{pos} = [allpos5{pos}; recblock5{i}(pos)];
        end
        if ~isempty(recblockn{i}) && length(recblockn{i}) >= pos
            allposn{pos} = [allposn{pos}; recblockn{i}(pos)];
        end
    end
end


mean_pos4 = zeros(8, 1); mean_pos5 = zeros(8, 1);mean_posn = zeros(8, 1);
ste_pos4 = zeros(8, 1);  ste_pos5 = zeros(8, 1); ste_posn = zeros(8, 1); 

for pos = 1:8
    mean_pos4(pos) = mean(allpos4{pos});
    ste_pos4(pos) = std(allpos4{pos}) / sqrt(length(allpos4{pos}));

    mean_pos5(pos) = mean(allpos5{pos});
    ste_pos5(pos) = std(allpos5{pos}) / sqrt(length(allpos5{pos}));

    mean_posn(pos) = mean(allposn{pos});
    ste_posn(pos) = std(allposn{pos}) / sqrt(length(allposn{pos}));
end

figure('Position', [100, 100, 1200, 400]);  
subplot(1, 3, 1);
bar(1:8, mean_pos4);
hold on;
errorbar(1:8, mean_pos4, ste_pos4, 'k', 'linestyle', 'none');
title('Boundary 4:4');
xlabel('Position');
% ylim([0 0.08])
% yticks(0:0.05:1);
ylabel('avg recall frequency');

subplot(1, 3, 2);
bar(1:8, mean_pos5);
hold on;
errorbar(1:8, mean_pos5, ste_pos5, 'k', 'linestyle', 'none');
title('Boundary 5:3');
xlabel('Position');
ylim([0 0.7])
% yticks(0:0.05:1);
ylabel('avg recall frequency');

subplot(1, 3, 3);
bar(1:8, mean_posn);
hold on;
errorbar(1:8, mean_posn, ste_posn, 'k', 'linestyle', 'none');
title('No Boundary');
xlabel('Position');
ylim([0 0.7])
% yticks(0:0.05:1);
ylabel('avg recall frequency');
