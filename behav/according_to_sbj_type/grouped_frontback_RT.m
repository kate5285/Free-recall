%% avg rt blocks comparison
figure('Name', 'RT Across Conditions', 'Position', [100, 100, 1400, 800]);
allYData=[];
skipCN=0;
groupNames = {'CN','MCI', 'DM'};
groupRows = {CN,MCI, DM}; 
% groupNames = {'MCI pos', 'MCI neg'};
% groupRows = {posMCI, negMCI};
rtfronts=cell(3,1);allans4=cell(3,1);
rtbacks=cell(3,1);allans5=cell(3,1);
allansn=cell(3,1);
for i = 1:3
    rtfronts{i} = cell(4,1);
    rtbacks{i} = cell(4,1);
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

    mf4=cell(3*numSubjects,1);ans4=cell(3*numSubjects,1);
    mb4=cell(3*numSubjects,1);
    mf5=cell(3*numSubjects,1);ans5=cell(3*numSubjects,1);
    mb5=cell(3*numSubjects,1);
    mnf4=cell(3*numSubjects,1);ansn=cell(3*numSubjects,1);
    mnb4=cell(3*numSubjects,1);
    mnf5=cell(3*numSubjects,1);
    mnb5=cell(3*numSubjects,1);

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
                    rts_value = rts{idx, 1}{j, 1};
  
                    if any(blocknum == [1, 2, 3])
                        indices = find(posData >= 1 & posData <= 4);
                        frontRecall4 = vertcat(frontRecall4,rts_value(indices));
                        bindices = find(posData >= 5 & posData <= 8);
                        backRecall4 = vertcat(backRecall4,rts_value(bindices));
                    mf4{(i-1)*3+blocknum}=nanmean(rts_value(indices));
                    mb4{(i-1)*3+blocknum}=nanmean(rts_value(bindices));
                    ans4{(i-1)*3+blocknum}=trials{j, 1}.allansnum;

                    elseif any(blocknum == [4, 5, 6]) 
                        indices = find(posData >= 1 & posData <= 5);
                        frontRecall5 = vertcat(frontRecall5,rts_value(indices));
                        bindices = find(posData >= 6 & posData <= 8);
                        backRecall5 = vertcat(backRecall5,rts_value(bindices));
                    mf5{(i-1)*3+blocknum-3}=nanmean(rts_value(indices));
                    mb5{(i-1)*3+blocknum-3}=nanmean(rts_value(bindices));
                    ans5{(i-1)*3+blocknum-3}=trials{j, 1}.allansnum;

                    elseif any(blocknum == [7, 8, 9])
                        findices = find(posData >= 1 & posData <= 4);
                        ffrontRecalln = vertcat(ffrontRecalln,rts_value(findices));
                        fbindices = find(posData >= 5 & posData <= 8);
                        fbackRecalln = vertcat(fbackRecalln,rts_value(fbindices));

                        indices = find(posData >= 1 & posData <= 5);
                        frontRecalln = vertcat(frontRecalln,rts_value(indices));
                        bindices = find(posData >= 6 & posData <= 8);
                        backRecalln = vertcat(backRecalln,rts_value(bindices));

                    mnf4{(i-1)*3+blocknum-6}=nanmean(rts_value(findices));
                    mnb4{(i-1)*3+blocknum-6}=nanmean(rts_value(fbindices));
                    mnf5{(i-1)*3+blocknum-6}=nanmean(rts_value(indices));
                    mnb5{(i-1)*3+blocknum-6}=nanmean(rts_value(bindices));
                    ansn{(i-1)*3+blocknum-6}=trials{j, 1}.allansnum;
                    end

                end

        end

    end

    groupName
    numSubjects
    meanFront4 = mean(frontRecall4)
    meanBack4 = mean(backRecall4)
    meanFront5 = mean(frontRecall5)
    meanBack5 = mean(backRecall5)

    meanFrontn = mean(frontRecalln)
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

    subplot(3, 4, (g - 1) * 4 + 1);
    bar(1:2, [meanFront4, meanBack4]);  
    hold on;
    errorbar(1:2, [meanFront4, meanBack4], [stderrFront4, stderrBack4], 'k', 'linestyle', 'none');
    title([groupName ' - Boundary 4:4']);
    xticks([1 2]);
    xticklabels({'Front 4', 'Back 4'});
    ylabel('RT (Mean) (s)');
    % ylim1 = ylim();
    % hold off;

    subplot(3, 4, (g - 1) * 4 + 2);
    bar(1:2, [meanFront5, meanBack5]);
    hold on;
    errorbar(1:2, [meanFront5, meanBack5], [stderrFront5, stderrBack5], 'k', 'linestyle', 'none');
    title([groupName ' - Boundary 5:3']);
    xticks([1 2]);
    xticklabels({'Front 5', 'Back 3'});
    ylabel('RT (Mean) (s)');
    % ylim2 = ylim();
    % hold off;

    % figure('Name', groupName, 'Position', [100, 100, 1200, 600]);
    subplot(3, 4, (g - 1) * 4 + 4);
    bar(1:2, [meanFrontn, meanBackn]);
    hold on;
    errorbar(1:2, [meanFrontn, meanBackn], [stderrFrontn, stderrBackn], 'k', 'linestyle', 'none');
    title([groupName '  - No Boundary cond, grouped into 5:3 words']);
    xticks([1 2]);
    xticklabels({'Front 5', 'Back 3'});
    ylabel('RT (Mean) (s)');
    % ylim11 = ylim();
    % hold off;

    subplot(3, 4, (g - 1) * 4 + 3);
    bar(1:2, [fmeanFrontn, fmeanBackn]);
    hold on;
    errorbar(1:2, [fmeanFrontn, fmeanBackn], [fstderrFrontn, fstderrBackn], 'k', 'linestyle', 'none');
    title([groupName ' - No Boundary cond, grouped into 4:4 words']);
    xticks([1 2]);
    xticklabels({'Front 4', 'Back 4'});
    ylabel('RT (Mean) (s)');
    % ylim21 = ylim();
    % hold off;

    % common_ylim = [0, max([ylim1(2), ylim2(2),ylim11(2), ylim21(2)])];
    % figure(2*(g-1)+1);
    % 
    % subplot(1, 2, 1);
    % ylim(common_ylim);
    % subplot(1, 2, 2);
    % ylim(common_ylim);
    % 
    % 
    % figure(2*(g-1)+2);
    % subplot(1, 2, 1);
    % ylim(common_ylim);
    % subplot(1, 2, 2);
    % ylim(common_ylim);
    % common_ylim
disp('no bound vs bound');

p_front = signrank(cell2mat(mf4), cell2mat(mnf4)); 
disp([groupName, ', 4:4 Front p-value: ', num2str(p_front)]);
p_back = signrank(cell2mat(mb4), cell2mat(mnb4));
disp([groupName, ', 4:4 Back p-value: ', num2str(p_back)]);

p_front = signrank(cell2mat(mf5), cell2mat(mnf5));
disp([groupName, ', 5:3 Front p-value: ', num2str(p_front)]);
p_back = signrank(cell2mat(mb5), cell2mat(mnb5));
disp([groupName, ', 5:3 Back p-value: ', num2str(p_back)]);

disp('boundary front vs back');

p_front = signrank(cell2mat(mf4), cell2mat(mb4));
disp([groupName, ', 4:4 Front vs Back p-value: ', num2str(p_front)]);
p_back = signrank(cell2mat(mf5), cell2mat(mb5));
disp([groupName, ', 5:3 Front vs Back p-value: ', num2str(p_back)]);

p_front = signrank(cell2mat(mnf4), cell2mat(mnb4));
disp([groupName, ', No boundary, 4:4 Front vs Back p-value: ', num2str(p_front)]);
p_back = signrank(cell2mat(mnf5), cell2mat(mnb5));
disp([groupName, ', No boundary, 5:3 Front vs Back p-value: ', num2str(p_back)]);

        rtfronts{g}{1} = mf4;
        rtbacks{g}{1} = mb4;allans4{g}=ans4;

        rtfronts{g}{2} = mf5;
        rtbacks{g}{2} = mb5;allans5{g}=ans5;

        rtfronts{g}{3} = mnf5;%5:3n
        rtbacks{g}{3} = mnb5;allansn{g}=ansn;

        rtfronts{g}{4} = mnf4;
        rtbacks{g}{4} = mnb4;

allYData = [allYData; meanFront4; meanBack4; meanFront5;meanBack5; fmeanFrontn; fmeanBackn; meanFrontn; meanBackn];
end
ymax = max(allYData) +1;
for s = 1:12
    subplot(3, 4, s);
    ylim([0, ymax]);
end
