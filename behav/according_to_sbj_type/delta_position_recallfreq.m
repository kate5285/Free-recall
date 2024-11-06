%% delta for ratio of recalls made
figure('Name', 'Recall Ratios Across Conditions', 'Position', [100, 100, 1400, 800]);
allerrorb=[];allYData = [];
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

    for i = 1:numSubjects
        idx = groupIndices(i);  
        if skipCN == 1 && strcmp(groupName, 'CN') && groupIndices(i) == youngCN
            continue;
        end

        positions = position{idx,1};
        trials = Alldata{idx, 1}; 
        numBlocks = length(trials);
        recrate4=zeros(8, 1); 
        recrate5=zeros(8, 1); 
        recraten=zeros(8, 1); 
        pos4=[];
        pos5=[];
        posn=[];

        if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
            patrec4{i} = [];
            patrec5{i} = [];
            patrecn{i} = [];
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
       recrate4(k) = sum(pos4 == k) / 3;
       recrate5(k) = sum(pos5 == k) / 3;
       recraten(k) = sum(posn == k) / 3;
       end

        patrec4{i}=recrate4;
        patrec5{i}=recrate5;
        patrecn{i}=recraten;
    end
    pallpos4=cell(8, 1);
    pallpos5=cell(8, 1);
    pallposn=cell(8, 1);

    for pos = 1:8
        for i = 1:numSubjects
            if ~isempty(patrec4{i}) && length(patrec4{i}) >= pos
                pallpos4{pos} = [pallpos4{pos}; patrec4{i}(pos)];
            end
            if ~isempty(patrec5{i}) && length(patrec5{i}) >= pos
                pallpos5{pos} = [pallpos5{pos}; patrec5{i}(pos)];
            end
            if ~isempty(patrecn{i}) && length(patrecn{i}) >= pos
                pallposn{pos} = [pallposn{pos}; patrecn{i}(pos)];
            end
        end
    end
    mean_posn=cellfun(@mean, pallposn);
    ste_posn=cellfun(@std, pallposn)/numel(groupIndices);

    mean_pos4 = zeros(8, 1); mean_pos5 = zeros(8, 1);
    ste_pos4 = zeros(8, 1);  ste_pos5 = zeros(8, 1);
    posrt4 =cell(8,1); posrt5 =cell(8,1); 
    for p = 1:8
        mean_rtn_value = mean_posn(p);
        posrt4{p} = pallpos4{p} - mean_rtn_value;
        mean_pos4(p) =  mean(posrt4{p});
        ste_pos4(p)=std(posrt4{p}) / sqrt(numel(groupIndices));

        posrt5{p} = pallpos5{p} - mean_rtn_value;
        mean_pos5(p) =  mean(posrt5{p});
        ste_pos5(p)=std(posrt5{p}) / sqrt(numel(groupIndices));
    end
allYData = [allYData; mean_pos4;mean_pos5];
allerrorb=[allerrorb;ste_pos4;ste_pos5];

subplot(3, 2, (g - 1) * 2 + 1);
bar(1:8, mean_pos4);
hold on;
errorbar(1:8, mean_pos4,ste_pos4, 'k', 'linestyle', 'none');
title([groupName ', avg 4:4 - avg non boundary']);
xlabel('position');
ylabel('avg recall ratio(s)');

subplot(3, 2, (g - 1) * 2 + 2);
bar(1:8,mean_pos5);
hold on;
errorbar(1:8, mean_pos5,ste_pos5, 'k', 'linestyle', 'none');
title([groupName ', avg 5:3 - avg non boundary']);
xlabel('position');
ylabel('avg recall ratio(s)');
end

ymax = max(allYData)+max(allerrorb)+0.05;
ymin = min(allYData)-max(allerrorb);
for s = 1:6
    subplot(3, 2, s);
    ylim([ymin, ymax]);
end
