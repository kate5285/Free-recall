numSubjects = length(Alldata);
recblock4= cell(numSubjects, 2);
recblock5= cell(numSubjects, 2);
recblockn= cell(numSubjects, 2);

allpos4= [];
allpos5= [];
allposn= [];
allrtpos4=[];
allrtpos5=[];
allrtposn=[];

for i = 1:numSubjects
    positions = position{i,1};  
    trials = Alldata{i, 1};
    numBlocks = length(trials);
    pos4=[];rtpos4=[];
    pos5=[];rtpos5=[];
    posn=[];rtposn=[];

        if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
            recblock4{i,1} = [];
            recblock5{i,1} = [];
            recblockn{i,1} = [];
            recblock4{i,2} = [];
            recblock5{i,2} = [];
            recblockn{i,2} = [];
        continue; 
        end

    for j = 1:numBlocks
        blocknum = trials{j, 1}.blocknum;
        posData = positions{j}; 
        rts_value = rts{i,1}{j, 1};

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
    recblock4{i,1}=pos4;
    recblock5{i,1}=pos5;
    recblockn{i,1}=posn;
    recblock4{i,2}=rtpos4;
    recblock5{i,2}=rtpos5;
    recblockn{i,2}=rtposn;

    allpos4 = vertcat(allpos4, recblock4{i,1});
    allpos5 = vertcat(allpos5, recblock5{i,1});
    allposn = vertcat(allposn, recblockn{i,1});
    allrtpos4 = vertcat(allrtpos4, recblock4{i,2});
    allrtpos5 = vertcat(allrtpos5, recblock5{i,2});
    allrtposn = vertcat(allrtposn, recblockn{i,2});
end
figure('Position', [100, 100, 1200, 400]);  
subplot(1, 3, 1);
positions4 = unique(allpos4);
mean_rt4 = arrayfun(@(pos) mean(allrtpos4(allpos4 == pos)), positions4);
stderr_rt4 = arrayfun(@(pos) std(allrtpos4(allpos4 == pos)) / sqrt(sum(allpos4 == pos)), positions4);
bar(positions4, mean_rt4);
hold on; 
errorbar(1:8, mean_rt4, stderr_rt4, 'k', 'linestyle', 'none');
% for pos = positions4'
%     scatter(repmat(pos, sum(allpos4 == pos), 1), allrtpos4(allpos4 == pos), 'k', 'filled');
% end
title('Boundary 4:4');
xlabel('Position');
ylim1=ylim();
ylabel('avg RT(s) per position');

subplot(1, 3, 2);
positions5 = unique(allpos5);
mean_rt5 = arrayfun(@(pos) mean(allrtpos5(allpos5 == pos)), positions5);
stderr_rt5 = arrayfun(@(pos) std(allrtpos5(allpos5 == pos)) / sqrt(sum(allpos5 == pos)), positions5);
bar(positions5, mean_rt5);
hold on;
errorbar(1:8, mean_rt5, stderr_rt5, 'k', 'linestyle', 'none');
% for pos = positions5'
%     scatter(repmat(pos, sum(allpos5 == pos), 1), allrtpos5(allpos5 == pos), 'k', 'filled');
% end
title('Boundary 5:3');
xlabel('Position');
ylim2=ylim();
ylabel('avg RT(s) per position');

subplot(1, 3, 3);
positionsn = unique(allposn);
mean_rtn = arrayfun(@(pos) mean(allrtposn(allposn == pos)), positionsn);
stderr_rtn = arrayfun(@(pos) std(allrtposn(allposn == pos)) / sqrt(sum(allposn == pos)), positionsn);
bar(positionsn, mean_rtn);
hold on;
errorbar(1:8, mean_rtn, stderr_rtn, 'k', 'linestyle', 'none');
% for pos = positionsn'
%     scatter(repmat(pos, sum(allposn == pos), 1), allrtposn(allposn == pos), 'k', 'filled');
% end
title('No Boundary');
xlabel('Position');
ylim3=ylim();
ylabel('avg RT(s) per position');
hold off;

common_ylim = [0, max([ylim1(2), ylim2(2),ylim3(2)])];
figure(gcf);
subplot(1, 3, 1);
ylim(common_ylim);
subplot(1, 3, 2);
ylim(common_ylim);
subplot(1, 3, 3);
ylim(common_ylim);
