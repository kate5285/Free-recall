skipCN = 0;

sbjtype = info{:, 5};
MCI = find(strcmp(sbjtype, 'MCI'));
DM = find(strcmp(sbjtype, 'Dementia')); 
CN = find(strcmp(sbjtype, 'CN')); 
groupNames = {'CN','MCI', 'DM'};
groupRows = {CN,MCI, DM}; 
% groupNames = {'MCI pos', 'MCI neg'};
% groupRows = {posMCI, negMCI};

for g = 1:numel(groupRows)
    groupName = groupNames{g}; 
    groupIndices = groupRows{g};  

    numSubjects = numel(groupIndices);  

    patrec4= cell(numSubjects, 1);
    patrec5= cell(numSubjects, 1);
    patrecn= cell(numSubjects, 1);

pos4 = cell(3, 1);
pos5 = cell(3, 1);
posn = cell(3, 1);

j4=cell(2,1);j5=cell(2,1);jn=cell(2,1);
for i=1:numSubjects
    idx = groupIndices(i);
    positions = position{idx,1};
    trials = Alldata{idx, 1};

    if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
        continue;
    end
    for j=1:9

        blocknum = trials{j, 1}.blocknum;
        posData = positions{j};
        if any(blocknum == [1, 2, 3])
            j4{1}=[j4{1};j];
            j4{2}=[j4{2};blocknum];
        elseif any(blocknum == [4, 5, 6])
            j5{1}=[j5{1};j];
            j5{2}=[j5{2};blocknum];
        elseif any(blocknum == [7, 8, 9])
            jn{1}=[jn{1};j];
            jn{2}=[jn{2};blocknum];
        end
    end
end
% Assuming j4{1,1} is a column vector
data = j4{1,1};
data1 = j5{1,1};
data2 = jn{1,1};
numSubjects = size(data, 1) / 3;

for k = 1:numSubjects
    chunk = data((k-1)*3 + (1:3)); 
    chunk1 = data1((k-1)*3 + (1:3));
    chunk2 = data2((k-1)*3 + (1:3)); % Extract chunk of 3
    if all(diff(chunk) > 0)&&all(diff(chunk1) > 0)&&all(diff(chunk2) > 0) % Check if the difference is always positive
        disp('증가.')% If any chunk is not increasing
        break; % Exit the loop early
    else
        disp('아님.')
    end
end

pos4 = cell(3, 1);
pos5 = cell(3, 1);
posn = cell(3, 1);

for i = 1:numSubjects
    idx = groupIndices(i);
    if skipCN == 1 && strcmp(groupName, 'CN') && groupIndices(i) == youngCN
        continue;
    end

    positions = position{idx,1};
    trials = Alldata{idx, 1};

    if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
        continue;
    end

    for j = 1:numel(trials)  % Loop through each trial/blocknum
        blocknum = trials{j, 1}.blocknum;
        posData = positions{j};

        % Map blocknum to cell index directly using a formula
        if any(blocknum == [1, 2, 3])
            pos4{blocknum} = [pos4{blocknum}; posData];
        elseif any(blocknum == [4, 5, 6])
            pos5{blocknum - 3} = [pos5{blocknum - 3}; posData];  % Shift blocknum to map to [1, 2, 3]
        elseif any(blocknum == [7, 8, 9])
            posn{blocknum - 6} = [posn{blocknum - 6}; posData];  % Shift blocknum to map to [1, 2, 3]
        end
    end
end

colors = {'r',  [1, 0.647, 0], [1, 1, 0]};
lineStyles = {'-', '--', ':'};
figure;
for groupIdx = 1:3
    if groupIdx == 1
        posD = pos4;
    elseif groupIdx == 2
        posD = pos5;
    else
        posD = posn;
    end
    for j = 1:3
        currentData = posD{j};
        count = arrayfun(@(pos) sum(currentData == pos), 1:8);
        y = count / 11;
        x = 1:8;
         plot(x, y, 'Color', colors{j}, 'LineWidth', 2, 'LineStyle', lineStyles{groupIdx}, 'DisplayName', ['Trial ' num2str(j)]);
         hold on;
    end
end
xlabel('Position');
ylabel('avg recall of sbjs');
title(groupName);
legend('show');
hold off;


recallValues = cell(8, 1);
recallValues1 = cell(8, 1);
recallValues2 = cell(8, 1);
for pos = 1:8
    for trial = 1:3
        recallValues{pos} = [recallValues{pos}; sum(pos4{trial} == pos)];
        recallValues1{pos} = [recallValues1{pos}; sum(pos5{trial} == pos)];
        recallValues2{pos} = [recallValues2{pos}; sum(posn{trial} == pos)];
    end
end

% ANOVA 
     groupnames = repmat((1:3)', size(recallValues)); 
     pValue = anova1(vertcat(recallValues{:}), groupnames, 'off') 
     pValue1 = anova1(vertcat(recallValues1{:}), groupnames, 'off')
     pValue2 = anova1(vertcat(recallValues2{:}), groupnames, 'off')

end
