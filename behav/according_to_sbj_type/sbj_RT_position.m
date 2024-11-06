skipCN = 1;
sbjtype = info{:, 5};
MCI = find(strcmp(sbjtype, 'MCI')); 
DM = find(strcmp(sbjtype, 'Dementia')); 
CN = find(strcmp(sbjtype, 'CN')); 

groupNames = {'CN','MCI', 'DM'};
groupRows = {CN,MCI, DM}; 
% groupNames = {'MCI pos', 'MCI neg'};
% groupRows = {posMCI, negMCI};

allpositions=cell(3,1);
allrtpositions=cell(3,1);

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
    allpositions{g,1}=cell(3,1);
    allrtpositions{g,1}=cell(3,1);

    allpositions{g,1}{1,1}=patallpos4;
    allpositions{g,1}{2,1}=patallpos5;
    allpositions{g,1}{3,1}=patallposn;

    allrtpositions{g,1}{1,1}=rtallpos4;
    allrtpositions{g,1}{2,1}=rtallpos5;
    allrtpositions{g,1}{3,1}=rtallposn;

    figure('Name', groupName,'Position', [100, 100, 1200, 400]);  
    
    subplot(1, 3, 1);
    positions4 = unique(patallpos4);
    mean_rt4 = arrayfun(@(pos) mean(rtallpos4(patallpos4 == pos)), positions4);
    stderr_rt4 = arrayfun(@(pos) std(rtallpos4(patallpos4 == pos)) / sqrt(sum(patallpos4 == pos)), positions4);
    bar(positions4, mean_rt4);
    hold on;  
    errorbar(positions4, mean_rt4, stderr_rt4, 'k', 'linestyle', 'none');  
    % for pos = positions4'
    %     scatter(repmat(pos, sum(patallpos4 == pos), 1), rtallpos4(patallpos4 == pos), 'k', 'filled');
    % end
    title([groupName ' - Boundary 4:4']);
    xlabel('Position');
    ylim1=ylim();
    ylabel('avg RT(s) per position');

    subplot(1, 3, 2);
    positions5 = unique(patallpos5);
    mean_rt5 = arrayfun(@(pos) mean(rtallpos5(patallpos5 == pos)), positions5);
    stderr_rt5 = arrayfun(@(pos) std(rtallpos5(patallpos5 == pos)) / sqrt(sum(patallpos5 == pos)), positions5);
    bar(positions5, mean_rt5);
    hold on;  
    errorbar(positions5, mean_rt5, stderr_rt5, 'k', 'linestyle', 'none');  
    % for pos = positions5'
    %     scatter(repmat(pos, sum(patallpos5 == pos), 1), rtallpos5(patallpos5 == pos), 'k', 'filled');
    % end
    title([groupName ' - Boundary 5:3']);
    xlabel('Position');
    ylim2=ylim();
    ylabel('avg RT(s) per position');

    subplot(1, 3, 3);
    positionsn = unique(patallposn);
    mean_rtn = arrayfun(@(pos) mean(rtallposn(patallposn == pos)), positionsn);
    stderr_rtn = arrayfun(@(pos) std(rtallposn(patallposn == pos)) / sqrt(sum(patallposn == pos)), positionsn);
    bar(positionsn, mean_rtn);
    hold on;  
    errorbar(positionsn, mean_rtn, stderr_rtn, 'k', 'linestyle', 'none'); 
    % for pos = positionsn'
    %     scatter(repmat(pos, sum(patallposn == pos), 1), rtallposn(patallposn == pos), 'k', 'filled');
    % end
    title([groupName ' - No Boundary']);
    xlabel('Position');
    ylim3=ylim();
    ylabel('avg RT(s) per position');

common_ylim = [0, max([ylim1(2), ylim2(2),ylim3(2)])];
figure(gcf);
subplot(1, 3, 1);
ylim(common_ylim);
subplot(1, 3, 2);
ylim(common_ylim);
subplot(1, 3, 3);
ylim(common_ylim);
end
