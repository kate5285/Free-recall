skipCN=0;
groupNames = {'CN','MCI', 'DM'};
groupRows = {CN,MCI, DM}; 
% groupNames = {'MCI pos', 'MCI neg'};
% groupRows = {posMCI, negMCI};

for g = 1:numel(groupRows)
   groupName = groupNames{g};
   groupIndices = groupRows{g}; 
   numSubjects = numel(groupIndices);  

   frtbound4 = cell(numSubjects, 1);
   frtbound5 = cell(numSubjects, 1);
   frtboundn = cell(numSubjects, 1);

   frtmean4 = cell(numSubjects, 1);
   frtmean5 = cell(numSubjects, 1);
   frtmeann = cell(numSubjects, 1);

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
        frtbound4{i} = [];
        frtbound5{i} = [];
        frtboundn{i} = [];
    continue; 
    end

    for j = 1:numBlocks
        blocknum = trials{j, 1}.blocknum;

        if isempty(rts{idx, 1}{j, 1})
        rts_value = NaN; 
        else
        rts_value = rts{idx, 1}{j, 1}(1); 
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
        frtbound4{i} = ransum_123;
        frtbound5{i} = ransum_456;
        frtboundn{i} = ransum_789;

        frtmean4{i}  = nanmean(frtbound4{i});  
        frtmean5{i}  = nanmean(frtbound5{i});
        frtmeann{i}  = nanmean(frtboundn{i});
end

ftrtmean4 = nanmean(cell2mat(frtmean4));  
ftrtmean5 = nanmean(cell2mat(frtmean5));
ftrtmeann = nanmean(cell2mat(frtmeann));
frtmeans=[ftrtmean4, ftrtmean5, ftrtmeann];
frtSE4 = nanstd(cell2mat(frtmean4)) / sqrt(sum(~cellfun('isempty', frtmean4)));  
frtSE5 = nanstd(cell2mat(frtmean5)) / sqrt(sum(~cellfun('isempty', frtmean5)));
frtSEn = nanstd(cell2mat(frtmeann)) / sqrt(sum(~cellfun('isempty', frtmeann)));
frtSEs=[frtSE4, frtSE5, frtSEn];

groupName
frtmeans
frtSEs
figure;
bar(frtmeans);
hold on;
errorbar(1:3, frtmeans, frtSEs, 'k', 'linestyle', 'none'); 
hold off;
set(gca, 'XTickLabel', {'Boundary 4:4', 'Boundary 5:3', 'No Boundary'});  
ylim([0 9])
ylabel('average first RT of recalls(correct ones)'); 
title(groupName);

%mmse
figure;
hold on;

a=cell2mat(frtmean4);
emptyIn=find(cellfun(@isempty,frtmean4));
tmmse=mmse(groupRows{g});
tmmse(emptyIn) = [];
[a_clean, outA] = rmoutliers(a);
tmmse_clean_a = tmmse(~outA);
[r,p]=corr(tmmse_clean_a(~isnan(a_clean)),a_clean(~isnan(a_clean)));
lma = fitlm(a_clean, tmmse_clean_a);

b=cell2mat(frtmean5);
emptyIn=find(cellfun(@isempty, frtmean5));
tmmse=mmse(groupRows{g});
tmmse(emptyIn) = [];
[b_clean, outB] = rmoutliers(b);
tmmse_clean_b = tmmse(~outB);
[rb,pb]=corr(tmmse_clean_b(~isnan(b_clean)),b_clean(~isnan(b_clean)));
lmb = fitlm(b_clean,tmmse_clean_b);

c=cell2mat(frtmeann);
emptyIn=find(cellfun(@isempty, frtmeann));
tmmse=mmse(groupRows{g});
tmmse(emptyIn) = [];
[c_clean, outC] = rmoutliers(c);
tmmse_clean_c = tmmse(~outC);
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
xlabel('first word RT');
ylabel('mmse');
hold off;
title(groupName);
legend('4:4', '5:3','No boundary');

% age
figure;
hold on;
a=cell2mat(frtmean4);
emptyIn=find(cellfun(@isempty, frtmean4));
tage=age(groupRows{g});
tage(emptyIn) = [];
tage_clean_a = tage(~outA);
[ar,ap]=corr(tage_clean_a(~isnan(a_clean)),a_clean(~isnan(a_clean)));
lma = fitlm(a_clean,tage_clean_a);

b=cell2mat(frtmean5);
emptyIn=find(cellfun(@isempty, frtmean5));
tage=age(groupRows{g});
tage(emptyIn) = [];
tage_clean_b = tage(~outB);
[arb,apb]=corr(tage_clean_b(~isnan(b_clean)),b_clean(~isnan(b_clean)));
lmb = fitlm(b_clean,tage_clean_b);

c=cell2mat(frtmeann);
emptyIn=find(cellfun(@isempty, frtmeann));
tage=age(groupRows{g});
tage(emptyIn) = [];
tage_clean_c = tage(~outC);
[arc,apc]=corr(tage_clean_c(~isnan(c_clean)),c_clean(~isnan(c_clean)));
lmc = fitlm(c_clean,tage_clean_c);

plot(x_range,lma.Coefficients.Estimate(2) * x_range + lma.Coefficients.Estimate(1), 'b-', 'LineWidth', 2);
plot(x_range,lmb.Coefficients.Estimate(2) * x_range + lmb.Coefficients.Estimate(1), 'r-', 'LineWidth', 2);
plot(x_range,lmc.Coefficients.Estimate(2) * x_range + lmc.Coefficients.Estimate(1), 'm-', 'LineWidth', 2);
plot(a_clean, tage_clean_a,'b.','MarkerSize',10);
plot(b_clean, tage_clean_b, 'r.','MarkerSize',10);
plot(c_clean, tage_clean_c, 'm.','MarkerSize',10);
xlabel('first word RT');
ylabel('age');
hold off;
title(groupName);
legend('4:4', '5:3','No boundary');

% education
figure;
hold on;
a=cell2mat(frtmean4);
emptyIn=find(cellfun(@isempty, frtmean4));
tedu=edu(groupRows{g});
tedu(emptyIn) = [];
tedu_clean_a = tedu(~outA);
[er,ep]=corr(tedu(~isnan(a)),a(~isnan(a)));
lma = fitlm(a_clean,tedu_clean_a);

b=cell2mat(frtmean5);
emptyIn=find(cellfun(@isempty, frtmean5));
tedu=edu(groupRows{g});
tedu(emptyIn) = [];
tedu_clean_b = tedu(~outB);
[erb,epb]=corr(tedu(~isnan(b)),b(~isnan(b)));
lmb = fitlm(b_clean,tedu_clean_b);

c=cell2mat(frtmeann);
emptyIn=find(cellfun(@isempty, frtmeann));
tedu=edu(groupRows{g});
tedu(emptyIn) = [];
tedu_clean_c = tedu(~outC);
[erc,epc]=corr(tedu(~isnan(c)),c(~isnan(c)));
lmc = fitlm(c_clean, tedu_clean_c);

plot(x_range,lma.Coefficients.Estimate(2) * x_range + lma.Coefficients.Estimate(1), 'b-', 'LineWidth', 2);
plot(x_range,lmb.Coefficients.Estimate(2) * x_range + lmb.Coefficients.Estimate(1), 'r-', 'LineWidth', 2);
plot(x_range,lmc.Coefficients.Estimate(2) * x_range + lmc.Coefficients.Estimate(1), 'm-', 'LineWidth', 2);
plot(a_clean, tedu_clean_a,'b.','MarkerSize',10);
plot(b_clean, tedu_clean_b, 'r.','MarkerSize',10);
plot(c_clean, tedu_clean_c, 'm.','MarkerSize',10);
xlabel('first word RT');
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
[amaxr, aidx] = max([abs(ar), abs(arb), abs(arc)]);
conditions = {'4:4', '5:3', 'no boundary'};
fprintf('highest r: %.4f, boundary condition: %s \n', amaxr, conditions{aidx});
'corr with education'
fprintf('4:4 r: %.4f p: %.4f \n',er,ep);
fprintf('5:3 r: %.4f p: %.4f \n',erb,epb);
fprintf('no boundary r: %.4f p: %.4f \n',erc,epc);
[emaxr, eidx] = max([abs(er), abs(erb), abs(erc)]);
fprintf('highest r: %.4f, boundary condition: %s \n', emaxr, conditions{eidx});
end
% close all

conditionNames = {' mmse', ' age', ' education'};
for g=1:3
   for i=1:3
   figure(4*(g-1)+i+1);
   saveas(gcf,fullfile(savePath,['rmout first word rt_',groupNames{g}, conditionNames{i},'.png']))
   end
end
