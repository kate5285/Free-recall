%% RT per position and sbj type- delta
allYData = [];allerrorb=[];
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
    disp(groupNames{g})
    disp(numSubjects)

    patrec4= cell(numSubjects, 2);
    patrec5= cell(numSubjects, 2);
    patrecn= cell(numSubjects, 2);

    patallpos4= [];
    patallpos5= [];
    patallposn= [];

    rtallpos4= [];
    rtallpos5= [];
    rtallposn= [];

    for i = 1:numSubjects
        idx = groupIndices(i); 
       if skipCN == 1 && strcmp(groupName, 'CN') && groupIndices(i) == youngCN
           continue;
       end

        positions = position{idx,1};
        trials = Alldata{idx, 1}; 
        numBlocks = length(trials);
        pos4=[];rtpos4=[];
        pos5=[];rtpos5=[];
        posn=[];rtposn=[];

        if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
            patrec4{i,1} = [];
            patrec4{i,2} = [];
            patrec5{i,1} = [];
            patrec5{i,2} = [];
            patrecn{i,1} = [];
            patrecn{i,2} = [];
            continue; 
        end

        for j = 1:numBlocks
            blocknum = trials{j, 1}.blocknum;
            posData = positions{j}; 
            rts_value = rts{idx, 1}{j, 1};

            if any(blocknum == [1, 2, 3])
                rtpos4 = vertcat(rtpos4,rts_value);
                pos4 = vertcat(pos4, posData); 
            elseif any(blocknum == [4, 5, 6])
                rtpos5 = vertcat(rtpos5,rts_value);
                pos5 = vertcat(pos5, posData);  
            elseif any(blocknum == [7, 8, 9])
                rtposn = vertcat(rtposn,rts_value);
                posn = vertcat(posn, posData);  
            end
        end
        patrec4{i,2}=rtpos4;%2 is for rt value
        patrec5{i,2}=rtpos5;
        patrecn{i,2}=rtposn;

        patrec4{i,1}=pos4;%1 is for position
        patrec5{i,1}=pos5;
        patrecn{i,1}=posn;

        patallpos4 = vertcat(patallpos4, patrec4{i,1});
        patallpos5 = vertcat(patallpos5, patrec5{i,1});
        patallposn = vertcat(patallposn, patrecn{i,1});

        rtallpos4 = vertcat(rtallpos4, patrec4{i,2});
        rtallpos5 = vertcat(rtallpos5, patrec5{i,2});
        rtallposn = vertcat(rtallposn, patrecn{i,2});
    end

    positionsn = unique(patallposn);
    mean_rtn = arrayfun(@(pos) mean(rtallposn(patallposn == pos)), positionsn);
    stderr_rtn = arrayfun(@(pos) std(rtallposn(patallposn == pos)) / sqrt(sum(patallposn == pos)), positionsn);

    positions4 = unique(patallpos4);positions5 = unique(patallpos5);
    mean_rt4 = NaN(8,1); stderr_rt4= NaN(8,1);mean_rt5 = NaN(8,1); stderr_rt5= NaN(8,1);
    posrt4 =cell(8,1); posrt5 =cell(8,1); 

    for p = 1:8
        if any(positions4==p)
            posm=p;
        if ismember(posm, positionsn)
            mean_rtn_value = mean_rtn(positionsn == posm);
            posrt4{p} = rtallpos4(patallpos4 == posm) - mean_rtn_value;
        else
            posrt4{p}=NaN;
        end
        mean_rt4(p) =  mean(posrt4{p});
        stderr_rt4(p)=std(posrt4{p}) / sqrt(numel((posrt4{p})));
        end
    end

    for p = 1:8
        if any(positions5==p)
        posm = p;
        % does positionsn have that position
        if ismember(posm, positionsn)
            mean_rtn_value = mean_rtn(positionsn == posm);
            posrt5{p} = rtallpos5(patallpos5 == posm) - mean_rtn_value;
        else
            % if positionsn doesn't have it, put NaN in it
            posrt5{p}=NaN;
        end
    mean_rt5(p) =  mean(posrt5{p});
    stderr_rt5(p)=std(posrt5{p}) / sqrt(numel((posrt5{p})));
        end
    end

allYData = [allYData; mean_rt4;mean_rt5];
allerrorb=[allerrorb;stderr_rt4;stderr_rt5];
subplot(3, 2, (g - 1) * 2 + 1);
bar(1:8, mean_rt4);
hold on;
errorbar(1:8, mean_rt4,stderr_rt4, 'k', 'linestyle', 'none');
title([groupName ', avg 4:4 - avg non boundary']);
xlabel('position');
ylabel('avg RT(s)');

subplot(3, 2, (g - 1) * 2 + 2);
bar(1:8, mean_rt5);
hold on;
errorbar(1:8, mean_rt5,stderr_rt5, 'k', 'linestyle', 'none');
title([groupName ', avg 5:3 - avg non boundary']);
xlabel('position');
ylabel('avg RT(s)');
end
ymax = max(allYData)+max(allerrorb)+0.5;
ymin = min(allYData)-max(allerrorb);
for s = 1:6
    subplot(3, 2, s);
    ylim([ymin, ymax]);
end
