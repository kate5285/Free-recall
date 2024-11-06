figure('Name', 'Recall Ratios Across Conditions', 'Position', [100, 100, 1400, 800]);
allYData=[];
skipCN=0;
groupNames = {'CN','MCI', 'DM'};
groupRows = {CN,MCI, DM}; 
% groupNames = {'MCI pos', 'MCI neg'};
% groupRows = {posMCI, negMCI};
cfronts=cell(3,1);
cbacks=cell(3,1);
for i = 1:3
   cfronts{i} = cell(4,1);
   cbacks{i} = cell(4,1);
end

for g = 1:numel(groupRows)
    groupName = groupNames{g}; 
    groupIndices = groupRows{g};  

    numSubjects = numel(groupIndices);  

    frontRecall4 = [];
    backRecall4 = [];
    frontRecall5 = [];
    backRecall5 = [];

    frontRecalln = [];
    backRecalln = [];
    ffrontRecalln = [];
    fbackRecalln = [];

    for i = 1:numSubjects
        idx = groupIndices(i);  
        if skipCN == 1 && strcmp(groupName, 'CN') && groupIndices(i) == youngCN
            continue;
        end
        positions = position{idx, 1};
        trials = Alldata{idx, 1}; 
        numBlocks = length(trials);

        if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
            continue; 
        else
            for j = 1:numBlocks
                blocknum = trials{j, 1}.blocknum;
                posData = positions{j}; 
    
                if any(blocknum == [1, 2, 3])
                    indices = find(posData >= 1 & posData <= 4);
                    frontRecall4 = vertcat(frontRecall4,numel(indices));
                    bindices = find(posData >= 5 & posData <= 8);
                    backRecall4 = vertcat(backRecall4,numel(bindices));
                elseif any(blocknum == [4, 5, 6]) 
                    indices = find(posData >= 1 & posData <= 5);
                    frontRecall5 = vertcat(frontRecall5,numel(indices));
                    bindices = find(posData >= 6 & posData <= 8);
                    backRecall5 = vertcat(backRecall5,numel(bindices));
                elseif any(blocknum == [7, 8, 9]) 
                    findices = find(posData >= 1 & posData <= 4);
                    ffrontRecalln = vertcat(ffrontRecalln,numel(findices));

                    fbindices = find(posData >= 5 & posData <= 8);
                    fbackRecalln = vertcat(fbackRecalln,numel(fbindices));

                    indices = find(posData >= 1 & posData <= 5);
                    frontRecalln = vertcat(frontRecalln,numel(indices));

                    bindices = find(posData >= 6 & posData <= 8);
                    backRecalln = vertcat(backRecalln,numel(bindices));
                end
            end
    end
    end
    frontRecall4=frontRecall4/4;
    backRecall4=backRecall4/4;
    frontRecall5=frontRecall5/5;
    backRecall5=backRecall5/3;

    ffrontRecalln=ffrontRecalln/4;
    fbackRecalln=fbackRecalln/4;
    frontRecalln=frontRecalln/5;
    backRecalln=backRecalln/3;

    groupName
    numSubjects
    meanFront4 = mean(frontRecall4)
    meanBack4 = mean(backRecall4)
    meanFront5 = mean(frontRecall5)
    meanBack5 = mean(backRecall5)

    meanFrontn = mean(frontRecalln)%5:3
    meanBackn = mean(backRecalln)
    fmeanFrontn = mean(ffrontRecalln)
    fmeanBackn = mean(fbackRecalln)

    stderrFront4 = std(frontRecall4) / sqrt(numel(frontRecall4));
    stderrBack4 = std(backRecall4) / sqrt(numel(backRecall4));
    stderrFront5 = std(frontRecall5) / sqrt(numel(frontRecall5));
    stderrBack5 = std(backRecall5) / sqrt(numel(backRecall5));

    stderrFrontn = std(frontRecalln) / sqrt(numel(frontRecalln));
    stderrBackn = std(backRecalln) / sqrt(numel(backRecalln));
    fstderrFrontn = std(ffrontRecalln) / sqrt(numel(ffrontRecalln));
    fstderrBackn = std(fbackRecalln) / sqrt(numel(fbackRecalln));

    % figure('Name', groupName, 'Position', [100, 100, 1200, 600]);  
     
    % Boundary 4:4 subplot
    subplot(3, 4, (g - 1) * 4 + 1);
    bar(1:2, [meanFront4, meanBack4]);  
    hold on;
    errorbar(1:2, [meanFront4, meanBack4], [stderrFront4, stderrBack4], 'k', 'linestyle', 'none');
    title([groupName ' - Boundary 4:4']);
    xticks([1 2]);
    xticklabels({'Front 4', 'Back 4'});
    % ylabel('Ratio of recalls made out of each chunks (Mean)');
    ylabel('avg ratio of recalls per chunk');
    % ylim1 = ylim();

    subplot(3, 4, (g - 1) * 4 + 2);
    bar(1:2, [meanFront5, meanBack5]); 
    hold on;
    errorbar(1:2, [meanFront5, meanBack5], [stderrFront5, stderrBack5], 'k', 'linestyle', 'none');
    title([groupName ' - Boundary 5:3']);
    xticks([1 2]);
    xticklabels({'Front 5', 'Back 3'});
    % ylabel('Ratio of recalls made out of each chunks (Mean)');
    ylabel('avg ratio of recalls per chunk');
    % ylim2 = ylim();
    % hold off;

    % figure('Name', groupName, 'Position', [100, 100, 1200, 600]);  

    subplot(3, 4, (g - 1) * 4 + 4);
    bar(1:2, [meanFrontn, meanBackn]); 
    hold on;
    errorbar(1:2, [meanFrontn, meanBackn], [stderrFrontn, stderrBackn], 'k', 'linestyle', 'none');
    title([groupName ' - No Boundary cond, grouped into 5:3 words']);
    xticks([1 2]);
    xticklabels({'Front 5', 'Back 3'});
    % ylabel('Ratio of recalls made out of each chunks (Mean)');
    ylabel('avg ratio of recalls per chunk');
    % ylim11 = ylim();

    subplot(3, 4, (g - 1) * 4 + 3);
    bar(1:2, [fmeanFrontn, fmeanBackn]); 
    hold on;
    errorbar(1:2, [fmeanFrontn, fmeanBackn], [fstderrFrontn, fstderrBackn], 'k', 'linestyle', 'none');
    title([groupName ' - No Boundary cond, grouped into 4:4 words']);
    xticks([1 2]);
    xticklabels({'Front 4', 'Back 4'});
    % ylabel('Ratio of recalls made out of each chunks (Mean)');
    ylabel('avg ratio of recalls per chunk');
    % ylim21 = ylim();
    % hold off;

    % common_ylim = [0, max([ylim1(2), ylim2(2),ylim11(2), ylim21(2)])];
    % figure(2*(g-1)+1);
  
    % subplot(1, 2, 1);
    % ylim(common_ylim);
    % subplot(1, 2, 2);
    % ylim(common_ylim);
    
    % figure(2*(g-1)+2);
    % subplot(1, 2, 1);
    % ylim(common_ylim);
    % subplot(1, 2, 2);
    % ylim(common_ylim);
    % common_ylim  

disp('no bound vs bound');

[p_front,h] = signrank(frontRecall4, ffrontRecalln); 
disp([groupName, ', 4:4 Front p-value: ', num2str(p_front), 'h=', num2str(h)]);
[p_back,h] = signrank(backRecall4, fbackRecalln);
disp([groupName, ', 4:4 Back p-value: ', num2str(p_back), 'h=', num2str(h)]);

[p_front,h] = signrank(frontRecall5, frontRecalln);
disp([groupName, ', 5:3 Front p-value: ', num2str(p_front), 'h=', num2str(h)]);
[p_back,h] = signrank(backRecall5, backRecalln);
disp([groupName, ', 5:3 Back p-value: ', num2str(p_back), 'h=', num2str(h)]);

disp('boundary front vs back');

[p_front,h] = signrank(frontRecall4, backRecall4);
disp([groupName, ', 4:4 Front vs Back p-value: ', num2str(p_front), 'h=', num2str(h)]);
[p_back,h] = signrank(frontRecall5, backRecall5);
disp([groupName, ', 5:3 Front vs Back p-value: ', num2str(p_back), 'h=', num2str(h)]);

[p_front,h] = signrank(ffrontRecalln, fbackRecalln);
disp([groupName, ', No boundary, 4:4 Front vs Back p-value: ', num2str(p_front),'h=', num2str(h)]);
[p_back,h] = signrank(frontRecalln, backRecalln);
disp([groupName, ', No boundary, 5:3 Front vs Back p-value: ', num2str(p_back),'h=', num2str(h)]);

        cfronts{g}{1} = frontRecall4;
        cbacks{g}{1} = backRecall4;

        cfronts{g}{2} = frontRecall5;
        cbacks{g}{2} = backRecall5;

        cfronts{g}{3} = frontRecalln;%5:3n
        cbacks{g}{3} = backRecalln;

        cfronts{g}{4} = ffrontRecalln;
        cbacks{g}{4} = fbackRecalln;

allYData = [allYData; meanFront4; meanBack4; meanFront5;meanBack5; fmeanFrontn; fmeanBackn; meanFrontn; meanBackn];
end

ymax = max(allYData) + 0.1;
for s = 1:12
    subplot(3, 4, s);
    ylim([0, ymax]);
end
savePath = 'C:\Users\Leelab_Intern\Desktop\doyeon kim\free recall\figure\';
conditionNames = {'4', '5', 'n5', 'n4'};
