%% avg RT plot (with corr)
skipCN=0;
groupNames = {'CN','MCI', 'DM'};
groupRows = {CN,MCI, DM}; 
% groupNames = {'MCI pos', 'MCI neg'};
% groupRows = {posMCI, negMCI};

for g =1:numel(groupRows)
    groupName = groupNames{g};
    groupIndices = groupRows{g};
    numSubjects = numel(groupIndices);

    rtbound4 = cell(numSubjects, 1);
    rtbound5 = cell(numSubjects, 1);
    rtboundn = cell(numSubjects, 1);
    rtmean4 = cell(numSubjects, 1);
    rtmean5 = cell(numSubjects, 1);
    rtmeann = cell(numSubjects, 1);

for i = 1:numSubjects
    idx = groupIndices(i);
    if skipCN == 1 && strcmp(groupName, 'CN') && groupIndices(i) == youngCN
        continue;
    end
    trials = Alldata{idx, 1};
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

        if isempty(rts{idx, 1}{j, 1})
        rts_value = NaN;
        else
        rts_value = rts{idx, 1}{j, 1}; 
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

groupName
rtmeans
rtSEs

figure;
bar(rtmeans);
hold on;
errorbar(1:3, rtmeans, rtSEs, 'k', 'linestyle', 'none');
hold off;
set(gca, 'XTickLabel', {'Boundary 4:4', 'Boundary 5:3', 'No Boundary'});
ylim([0 7])
ylabel('average RT of recalls(correct ones)');
title(groupName);

%mmse
figure;
hold on; 

a=cell2mat(rtmean4);
emptyIn=find(cellfun(@isempty,rtmean4));
tmmse=mmse(groupRows{g});
tmmse(emptyIn) = [];
a(emptyIn) = [];
[a_clean, outA] = rmoutliers(a);
tmmse_clean_a = tmmse(~outA); 
% [r,p]=corr(tmmse,a);
[r,p]=corr(tmmse_clean_a(~isnan(a_clean)),a_clean(~isnan(a_clean)));
lma = fitlm(a_clean, tmmse_clean_a);

b=cell2mat(rtmean5);
emptyIn=find(cellfun(@isempty, rtmean5));
tmmse=mmse(groupRows{g});
tmmse(emptyIn) = [];
b(emptyIn) = [];
[b_clean, outB] = rmoutliers(b);
tmmse_clean_b = tmmse(~outB); 
% [rb,pb]=corr(tmmse,b);
[rb,pb]=corr(tmmse_clean_b(~isnan(b_clean)),b_clean(~isnan(b_clean)));
lmb = fitlm(b_clean,tmmse_clean_b);

c=cell2mat(rtmeann);
emptyIn=find(cellfun(@isempty, rtmeann));
tmmse=mmse(groupRows{g});
tmmse(emptyIn) = [];
c(emptyIn) = [];
[c_clean, outC] = rmoutliers(c);
tmmse_clean_c = tmmse(~outC); 
% [rc,pc]=corr(tmmse,c);
[rc,pc]=corr(tmmse_clean_c(~isnan(c_clean)),c_clean(~isnan(c_clean)));
lmc = fitlm(c_clean, tmmse_clean_c);

minv=min([a_clean;b_clean;c_clean]);
maxv=max([a_clean;b_clean;c_clean]);
x_range = linspace(minv, maxv, 100); 
plot(x_range,lma.Coefficients.Estimate(2) * x_range + lma.Coefficients.Estimate(1), 'b-', 'LineWidth', 2);
plot(x_range,lmb.Coefficients.Estimate(2) * x_range + lmb.Coefficients.Estimate(1), 'r-', 'LineWidth', 2);
plot(x_range,lmc.Coefficients.Estimate(2) * x_range + lmc.Coefficients.Estimate(1), 'm-', 'LineWidth', 2);
plot(a_clean, tmmse_clean_a,'b.','MarkerSize',10);
plot(b_clean, tmmse_clean_b, 'r.','MarkerSize',10);
plot(c_clean, tmmse_clean_c, 'm.','MarkerSize',10);

xlabel('average RT');
ylabel('mmse');
hold off;
title(groupName);
legend('4:4', '5:3','No boundary');

%age
figure;
hold on; 
a=cell2mat(rtmean4);
emptyIn=find(cellfun(@isempty, rtmean4));
tage=age(groupRows{g});
tage(emptyIn) = [];
tage_clean_a = tage(~outA); 
% [ar,ap]=corr(tage(~isnan(a)),a(~isnan(a)));
[ar,ap]=corr(tage_clean_a(~isnan(a_clean)),a_clean(~isnan(a_clean)));
lma = fitlm(a_clean,tage_clean_a);

b=cell2mat(rtmean5);
emptyIn=find(cellfun(@isempty, rtmean5));
tage=age(groupRows{g});
tage(emptyIn) = [];
tage_clean_b = tage(~outB); 
% [arb,apb]=corr(tage(~isnan(b)),b(~isnan(b)));
[arb,apb]=corr(tage_clean_b(~isnan(b_clean)),b_clean(~isnan(b_clean)));
lmb = fitlm(b_clean,tage_clean_b);

c=cell2mat(rtmeann);
emptyIn=find(cellfun(@isempty, rtmeann));
tage=age(groupRows{g});
tage(emptyIn) = [];
tage_clean_c = tage(~outC); 
% [arc,apc]=corr(tage(~isnan(c)),c(~isnan(c)));
[arc,apc]=corr(tage_clean_c(~isnan(c_clean)),c_clean(~isnan(c_clean)));
lmc = fitlm(c_clean,tage_clean_c);

plot(x_range,lma.Coefficients.Estimate(2) * x_range + lma.Coefficients.Estimate(1), 'b-', 'LineWidth', 2);
plot(x_range,lmb.Coefficients.Estimate(2) * x_range + lmb.Coefficients.Estimate(1), 'r-', 'LineWidth', 2);
plot(x_range,lmc.Coefficients.Estimate(2) * x_range + lmc.Coefficients.Estimate(1), 'm-', 'LineWidth', 2);
plot(a_clean, tage_clean_a,'b.','MarkerSize',10);
plot(b_clean, tage_clean_b, 'r.','MarkerSize',10);
plot(c_clean, tage_clean_c, 'm.','MarkerSize',10);
xlabel('average RT');
ylabel('age');
hold off;
title(groupName);
legend('4:4', '5:3','No boundary');

%education
figure;
hold on; 
a=cell2mat(rtmean4);
emptyIn=find(cellfun(@isempty, rtmean4));
tedu=edu(groupRows{g});
tedu(emptyIn) = [];
a(emptyIn) = [];
tedu_clean_a = tedu(~outA); 
% [er,ep]=corr(tedu,a);
[er,ep]=corr(tedu_clean_a(~isnan(a_clean)),a_clean(~isnan(a_clean)));
lma = fitlm(a_clean,tedu_clean_a);

b=cell2mat(rtmean5);
emptyIn=find(cellfun(@isempty, rtmean5));
tedu=edu(groupRows{g});
tedu(emptyIn) = [];
b(emptyIn) = [];
tedu_clean_b = tedu(~outB); 
% [erb,epb]=corr(tedu,b);
[erb,epb]=corr(tedu_clean_b(~isnan(b_clean)),b_clean(~isnan(b_clean)));
lmb = fitlm(b_clean,tedu_clean_b);

c=cell2mat(rtmeann);
emptyIn=find(cellfun(@isempty, rtmeann));
tedu=edu(groupRows{g});
tedu(emptyIn) = [];
c(emptyIn) = [];
tedu_clean_c = tedu(~outC); 
% [erc,epc]=corr(tedu,c);
[erc,epc]=corr(tedu_clean_c(~isnan(c_clean)),c_clean(~isnan(c_clean)));
lmc = fitlm(c_clean, tedu_clean_c);

plot(x_range,lma.Coefficients.Estimate(2) * x_range + lma.Coefficients.Estimate(1), 'b-', 'LineWidth', 2);
plot(x_range,lmb.Coefficients.Estimate(2) * x_range + lmb.Coefficients.Estimate(1), 'r-', 'LineWidth', 2);
plot(x_range,lmc.Coefficients.Estimate(2) * x_range + lmc.Coefficients.Estimate(1), 'm-', 'LineWidth', 2);
plot(a_clean, tedu_clean_a,'b.','MarkerSize',10);
plot(b_clean, tedu_clean_b, 'r.','MarkerSize',10);
plot(c_clean, tedu_clean_c, 'm.','MarkerSize',10);
xlabel('average RT');
ylabel('education');
hold off;
title(groupName);
legend('4:4', '5:3','No boundary');

groupName
'corr with mmse'
fprintf('4:4 r: %.4f p: %.4f \n',r,p);
fprintf('5:3 r: %.4f p: %.4f \n',rb,pb);
fprintf('no boundary r: %.4f p: %.4f \n',rc,pc);
[maxr, idx] = max([abs(r), abs(rb), abs(rc)]);
conditions = {'4:4', '5:3', 'no boundary'};
fprintf('highest r: %.4f, boundary condition: %s \n', maxr, conditions{idx});

'corr with age'
fprintf('4:4 r: %.4f p: %.4f \n',ar,ap);
fprintf('5:3 r: %.4f p: %.4f \n',arb,apb);
fprintf('no boundary r: %.4f p: %.4f \n',arc,apc);
[amaxr, aidx] = max([abs(ar),abs(arb),abs(arc)]);
fprintf('highest r: %.4f, boundary condition: %s \n', amaxr, conditions{aidx});

'corr with education'
fprintf('4:4 r: %.4f p: %.4f \n',er,ep);
fprintf('5:3 r: %.4f p: %.4f \n',erb,epb);
fprintf('no boundary r: %.4f p: %.4f \n',erc,epc);
[emaxr, eidx] = max([abs(er), abs(erb),abs(erc)]);
fprintf('highest r: %.4f, boundary condition: %s \n', emaxr, conditions{eidx});
end
% close all
conditionNames = {' mmse', ' age', ' education'};
for g=1:3
    for i=1:3
    figure(4*(g-1)+i+1);
    saveas(gcf,fullfile(savePath,['rmout avg rt_',groupNames{g}, conditionNames{i},'.png']))
    end
end
