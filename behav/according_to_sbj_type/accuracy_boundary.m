skipCN = 0;

sbjtype = info{:, 5};
MCI = find(strcmp(sbjtype, 'MCI'));
DM = find(strcmp(sbjtype, 'Dementia'));
CN = find(strcmp(sbjtype, 'CN'));
groupNames = {'CN','MCI', 'DM'};
groupRows = {CN,MCI, DM};
% groupNames = {'MCI pos', 'MCI neg'};
% groupRows = {posMCI, negMCI};
acc4=cell(3,1);acc5=cell(3,1);accn=cell(3,1);
acc4a=cell(3,1);acc5a=cell(3,1);accna=cell(3,1);

for g=1:3
acc4a{g}=cell(3,1);acc5a{g}=cell(3,1);accna{g}=cell(3,1);
end

for g = 1:numel(groupRows)
    groupName = groupNames{g};
    groupIndices = groupRows{g};

    numSubjects = numel(groupIndices);
    for i = 1:numSubjects
        idx = groupIndices(i);
        positions = position{idx,1}; 
        trials = Alldata{idx, 1};
        numBlocks = length(trials);

        if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
            continue;
        end
        for j = 1:numBlocks
            blocknum = trials{j, 1}.blocknum;
            accuracy=trials{j, 1}.ransnum/8; %how many correct recalls did they make for that block? (num of correct recalls/8)

            if any(blocknum == [1, 2, 3])
                acc4{blocknum}=accuracy;
                if trials{j, 1}.ransnum== 0 && trials{j, 1}.allansnum ==0
                    acc4{blocknum}=0;
                end
                acc4a{g}{blocknum}=[acc4a{g}{blocknum};acc4{blocknum}];
            elseif any(blocknum == [4, 5, 6])
                acc5{blocknum-3}=accuracy;
                if trials{j, 1}.ransnum== 0 && trials{j, 1}.allansnum ==0
                    acc5{blocknum-3}=0;
                end
                acc5a{g}{blocknum-3}=[acc5a{g}{blocknum-3};acc5{blocknum-3}];
            elseif any(blocknum == [7, 8, 9])
                accn{blocknum-6}=accuracy;
                if trials{j, 1}.ransnum== 0 && trials{j, 1}.allansnum ==0
                    accn{blocknum-6}=0;
                end
                accna{g}{blocknum-6}=[accna{g}{blocknum-6};accn{blocknum-6}];
            end
        end
    end
end

%sbj groups cut into halves according to accuracy
hrows4 = cell(3, 1);  %groups with high accuracy
hrows5 = cell(3, 1);
hrowsn = cell(3, 1);

lrows4 = cell(3, 1);  %groups with low accuracy
lrows5 = cell(3, 1);
lrowsn = cell(3, 1);

for g = 1:numel(groupRows)
    for j = 1:3
        data4 = acc4a{g}{j};
        data5 = acc5a{g}{j};
        datan = accna{g}{j};
        n = numel(data4);
        halfN = floor(n / 2);
        [sortedData, sortIdx] = sort(data4, 'descend');
        highIdx = sortIdx(1:halfN);
        lowIdx = sortIdx(halfN+1:end);
        hRows4 = 3 * (highIdx - 1) + j;
        lRows4 = 3 * (lowIdx - 1) + j;

        [sortedData, sortIdx] = sort(data5, 'descend');
        highIdx = sortIdx(1:halfN);
        lowIdx = sortIdx(halfN+1:end);
        hRows5 = 3 * (highIdx - 1) + j;
        lRows5 = 3 * (lowIdx - 1) + j;

        [sortedData, sortIdx] = sort(datan, 'descend');
        highIdx = sortIdx(1:halfN);
        lowIdx = sortIdx(halfN+1:end);
        hRowsn = 3 * (highIdx - 1) + j;
        lRowsn = 3 * (lowIdx - 1) + j;
        
        if j == 1
            hrows4{g} = [hrows4{g}; hRows4];
            lrows4{g} = [lrows4{g}; lRows4];
        elseif j == 2
            hrows5{g} = [hrows5{g}; hRows5];
            lrows5{g} = [lrows5{g}; lRows5];
        elseif j == 3
            hrowsn{g} = [hrowsn{g}; hRowsn];
            lrowsn{g} = [lrowsn{g}; lRowsn];
        end
    end
end

mwh=cell(3,1); mah=cell(3,1); %mean_within/across_high
ewh=cell(3,1); eah=cell(3,1);
mwl=cell(3,1); mal=cell(3,1);
ewl=cell(3,1); eal=cell(3,1);

for g = 1:3
mwh{g}=cell(4,1); mah{g}=cell(4,1); %mean_within/across_high
ewh{g}=cell(4,1); eah{g}=cell(4,1); %ste_within/across_high
mwl{g}=cell(4,1); mal{g}=cell(4,1);%mean_within/across_low
ewl{g}=cell(4,1); eal{g}=cell(4,1);%ste_within/across_low

    highRows = hrows4{g};  
    highData4 = allwithin4{g}(highRows); 
    ahighData4 = count4{g}(highRows); 
    mwh{g}{1} = mean(highData4);
    ewh{g}{1} = std(highData4) / sqrt(numel(highData4)); 
    mah{g}{1} = mean(ahighData4);
    eah{g}{1} = std(ahighData4) / sqrt(numel(ahighData4)); 

    lowRows = lrows4{g};
    lowData4 = allwithin4{g}(lowRows); 
    alowData4 = count4{g}(lowRows); 
    mwl{g}{1} = mean(lowData4);  
    ewl{g}{1} = std(lowData4) / sqrt(numel(lowData4)); 
    mal{g}{1} = mean(alowData4);
    eal{g}{1} = std(alowData4) / sqrt(numel(alowData4));  

% % is the number of crossings - within vs across different significantly
% [p, h] = signrank(highData4, ahighData4); %high
% fprintf('%s 4:4 high across vs within, h=%d, p=%.4f\n', groupNames{g}, h, p);
% [p, h] = signrank(lowData4, alowData4);
% fprintf('%s 4:4 low across vs within, h=%d, p=%.4f\n', groupNames{g}, h, p);    

    highRows = hrows5{g};
    highData5 = allwithin5{g}(highRows);
    ahighData5 = count5{g}(highRows); 
    mwh{g}{2} = mean(highData5);
    ewh{g}{2} = std(highData5) / sqrt(numel(highData5));
    mah{g}{2} = mean(ahighData5);
    eah{g}{2} = std(ahighData5) / sqrt(numel(ahighData5)); 

    lowRows = lrows5{g};
    lowData5 = allwithin5{g}(lowRows); 
    alowData5 = count5{g}(lowRows); 
    mwl{g}{2} = mean(lowData5);  
    ewl{g}{2} = std(lowData5) / sqrt(numel(lowData5)); 
    mal{g}{2} = mean(alowData5);
    eal{g}{2} = std(alowData5) / sqrt(numel(alowData5)); 


    highRows = hrowsn{g};
    highData4n = allwithin4n{g}(highRows);
    ahighData4n = countn4{g}(highRows); 
    mwh{g}{3}= mean(highData4n);
    ewh{g}{3} = std(highData4n) / sqrt(numel(highData4n)); 
    mah{g}{3} = mean(ahighData4n);
    eah{g}{3} = std(ahighData4n) / sqrt(numel(ahighData4n)); 

    lowRows = lrowsn{g};
    lowData4n = allwithin4n{g}(lowRows); 
    alowData4n = countn4{g}(lowRows); 
    mwl{g}{3} = mean(lowData4n);  
    ewl{g}{3} = std(lowData4n) / sqrt(numel(lowData4n)); 
    mal{g}{3} = mean(alowData4n);
    eal{g}{3} = std(alowData4n) / sqrt(numel(alowData4n));


    highData5n = allwithin5n{g}(highRows);
    ahighData5n = countn5{g}(highRows); 
    mwh{g}{4} = mean(highData5n);
    ewh{g}{4} = std(highData5n) / sqrt(numel(highData5n)); 
    mah{g}{4} = mean(ahighData5n);
    eah{g}{4} = std(ahighData5n) / sqrt(numel(ahighData5n));
    
    lowData5n = allwithin5n{g}(lowRows); 
    alowData5n = countn5{g}(lowRows); 
    mwl{g}{4} = mean(lowData5n);  
    ewl{g}{4} = std(lowData5n) / sqrt(numel(lowData5n)); 
    mal{g}{4} = mean(alowData5n);
    eal{g}{4} = std(alowData5n) / sqrt(numel(alowData5n)); 

% is the number of crossings - bound vs no bound different significantly
[p, h] = ranksum(highData4, highData4n);
fprintf('\n within boundary, %s 4:4 vs non 4:4 high, h=%d, p=%.4f\n', groupNames{g}, h, p);
[p, h] = ranksum(ahighData4, ahighData4n);
fprintf('across boundary, %s 4:4 vs non 4:4 high, h=%d, p=%.4f\n', groupNames{g}, h, p);
[p, h] = ranksum(lowData4, lowData4n);
fprintf('\n within boundary, %s 4:4 vs non 4:4 low, h=%d, p=%.4f\n', groupNames{g}, h, p);
[p, h] = ranksum(alowData4, alowData4n);
fprintf('across boundary, %s 4:4 vs non 4:4 low, h=%d, p=%.4f\n', groupNames{g}, h, p);


% is the number of crossings - bound vs no bound different significantly
[p, h] = ranksum(highData5, highData5n);
fprintf('\n within boundary, %s 5:3 vs non 5:3 high, h=%d, p=%.4f\n', groupNames{g}, h, p);
[p, h] = ranksum(ahighData5, ahighData5n);
fprintf('across boundary, %s 5:3 vs non 5:3 high, h=%d, p=%.4f\n', groupNames{g}, h, p);
[p, h] = ranksum(lowData5, lowData5n);
fprintf('\n within boundary, %s 5:3 vs non 5:3 low, h=%d, p=%.4f\n', groupNames{g}, h, p);
[p, h] = ranksum(alowData5, alowData5n);
fprintf('across boundary, %s 5:3 vs non 4:4 5:3, h=%d, p=%.4f\n', groupNames{g}, h, p);

figure;
x_labels = categorical({'High perf 4:4', 'High perf no bound 4:4', 'Low perf 4:4', 'Low perf no bound 4:4'});
x_labels = reordercats(x_labels, {'High perf 4:4', 'High perf no bound 4:4', 'Low perf 4:4', 'Low perf no bound 4:4'});

subplot(1, 2, 1);
hold on;

%4:4 bound
data_means = [mah{g}{1}, mwh{g}{1}; mah{g}{3}, mwh{g}{3}; mal{g}{1}, mwl{g}{1}; mal{g}{3}, mwl{g}{3}];
data_errors = [eah{g}{1}, ewh{g}{1}; eah{g}{3}, ewh{g}{3}; eal{g}{1}, ewl{g}{1}; eal{g}{3}, ewl{g}{3}];

b = bar(x_labels, data_means, 'grouped');
b(1).FaceColor = 'b';              % Across bound: 파란색
b(2).FaceColor = [0.7 0.85 1];     % Within bound: 하늘색

nbars = size(data_means, 2);
for i = 1:nbars
    x = b(i).XEndPoints; % 각 바의 x좌표
    errorbar(x, data_means(:, i), data_errors(:, i), 'k', 'linestyle', 'none');
end

ylim([0 3.9])
xlabel('Condition');
ylabel('num of crossings');
title('4:4 Condition');
legend({'Across bound', 'Within bound'}, 'Location', 'Best');
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
hold off;

%5:3 bound
subplot(1, 2, 2);
hold on;

x_labels = categorical({'High perf 5:3', 'High perf no bound 5:3', 'Low perf 5:3', 'Low perf no bound 5:3'});
x_labels = reordercats(x_labels, {'High perf 5:3', 'High perf no bound 5:3', 'Low perf 5:3', 'Low perf no bound 5:3'});

data_means = [mah{g}{2}, mwh{g}{2}; mah{g}{4}, mwh{g}{4}; mal{g}{2}, mwl{g}{2}; mal{g}{4}, mwl{g}{4}];
data_errors = [eah{g}{2}, ewh{g}{2}; eah{g}{4}, ewh{g}{4}; eal{g}{2}, ewl{g}{2}; eal{g}{4}, ewl{g}{4}];

b = bar(x_labels, data_means, 'grouped');
b(1).FaceColor = 'b';              % Across bound
b(2).FaceColor = [0.7 0.85 1];     % Within bound

nbars = size(data_means, 2);
for i = 1:nbars
    x = b(i).XEndPoints;
    errorbar(x, data_means(:, i), data_errors(:, i), 'k', 'linestyle', 'none');
end

ylim([0 3.9])
xlabel('Condition');
ylabel('num of crossings');
title('5:3 Condition');
legend({'Across bound', 'Within bound'}, 'Location', 'Best');
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
set(gcf, 'Name', groupNames{g})
hold off;


end
close all
