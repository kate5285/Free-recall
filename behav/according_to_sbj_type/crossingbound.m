count4=cell(3,1);count5=cell(3,1);countn4=cell(3,1);countn5=cell(3,1);
allwithin4=cell(3,1);allwithin5=cell(3,1);allwithin4n=cell(3,1);allwithin5n=cell(3,1);
r4=cell(3,1);r5=cell(3,1);nr4=cell(3,1);nr5=cell(3,1);
for g = 1:numel(groupRows)
    groupName = groupNames{g}; 
    groupIndices = groupRows{g};  
    numSubjects = numel(groupIndices);  
        acount4=[];awithin5n=[];
        acount5=[];awithin4n=[];
        acountn4=[];awithin4=[];
        acountn5=[];awithin5=[];

        acount4f=[];
        acount5f=[];
        acountn4f=[];
        acountn5f=[];
    for i = 1:numSubjects
        idx = groupIndices(i);  
        positions = position{idx,1}; 
        trials = Alldata{idx, 1}; 
        numBlocks = length(trials);


        if any(~cellfun(@(x) isfield(x, 'blocknum'), trials))
            continue; 
        end
        count4_b=[];count4_f=[];within4=[];
        count5_b=[];count5_f=[];within5=[];
        count_4b1=[];count_4f1=[];within4n=[];
        count_5b1=[];count_5f1=[];within5n=[];
        for j = 1:numBlocks
            blocknum = trials{j, 1}.blocknum;
            posData = positions{j};
            
            if any(blocknum == [1, 2, 3]) 
                pos4 = posData;
                count_f = 0; 
                count_b = 0; 
                for i = 2:length(pos4)
                    if pos4(i-1) > 4 && pos4(i) <= 4
                        count_b = count_b + 1; %go backwards
                    elseif pos4(i-1) <= 4 && pos4(i) > 4
                        count_f = count_f + 1; %go forwards
                    end
                end
                count4_b=vertcat(count4_b,count_b);
                count4_f=vertcat(count4_f,count_f);
                if numel(pos4)>=1
                in4=numel(pos4)-1-count_b-count_f;
                else
                in4=0;
                end
                within4=vertcat(within4,in4);
                
            elseif any(blocknum == [4, 5, 6])
                pos5 = posData; 
                count_f = 0; 
                count_b = 0;
                for i = 2:length(pos5)
                    if pos5(i-1) > 5 && pos5(i) <= 5
                        count_b = count_b + 1;
                    elseif pos5(i-1) <= 5 && pos5(i) > 5
                        count_f = count_f + 1;
                    end
                end
                count5_b=vertcat(count5_b,count_b);
                count5_f=vertcat(count5_f,count_f);
                if numel(pos5)>=1
                in5=numel(pos5)-1-count_b-count_f;
                else
                in5=0;
                end
                within5=vertcat(within5,in5);
            elseif any(blocknum == [7, 8, 9]) 
                posn = posData; 
                count_f1 = 0; 
                count_b1 = 0;
                for i = 2:length(posn)
                    if posn(i-1) > 4 && posn(i) <= 4
                        count_b1 = count_b1 + 1;
                    elseif posn(i-1) <= 4 && posn(i) > 4
                        count_f1 = count_f1 + 1; 
                    end
                end
                count_4b1=vertcat(count_4b1,count_b1); 
                count_4f1=vertcat(count_4f1,count_f1);
                if numel(posn)>=1
                in4n=numel(posn)-1-count_b1-count_f1;
                else
                in4n=0;
                end
                within4n=vertcat(within4n,in4n);

                count_f0 = 0;
                count_b0 = 0;
                for i = 2:length(posn)
                    if posn(i-1) > 5 && posn(i) <= 5
                        count_b0 = count_b0 + 1;
                    elseif posn(i-1) <= 5 && posn(i) > 5
                        count_f0 = count_f0 + 1;
                    end
                end
                count_5b1=vertcat(count_5b1,count_b0); 
                count_5f1=vertcat(count_5f1,count_f0);
                if numel(posn)>=1
                    in5n=numel(posn)-1-count_b0-count_f0;
                else
                    in5n=0;
                end
                within5n=vertcat(within5n,in5n);
            end
        end
                    if any(within5n < 0)
                negIdx = find(within5n < 0);
                for neg_i = 1:length(negIdx)
                    fprintf('음수 값 발견: idx=%d, j=%d, blocknum=%d, posn=%s, awithin5n 값=%f\n', ...
                        idx, j, blocknum, mat2str(posData), within5n(negIdx(neg_i)));
                end
                    end

        acount4=vertcat(acount4,count4_b);%back alltogether
        acount5=vertcat(acount5,count5_b);
        acountn4=vertcat(acountn4,count_4b1);
        acountn5=vertcat(acountn5,count_5b1); 

        acount4f=vertcat(acount4f,count4_f);%front alltogether
        acount5f=vertcat(acount5f,count5_f);
        acountn4f=vertcat(acountn4f,count_4f1);
        acountn5f=vertcat(acountn5f,count_5f1);

        awithin5n=vertcat(awithin5n,within5n);
        awithin4n=vertcat(awithin4n,within4n);
        awithin5=vertcat(awithin5,within5);
        awithin4=vertcat(awithin4,within4);

    end

% fprintf('group %s: front 4:4 cond crossings = %.4f\n',groupName, mean(acount4f));
% fprintf('group %s: front 5:3 cond crossings = %.4f\n',groupName, mean(acount5f));
% fprintf('group %s: front no boundary, 4:4 crossings = %.4f\n',groupName, mean(acountn4f));
% fprintf('group %s: front no boundary, 5:3 crossings = %.4f\n',groupName, mean(acountn5f));
% 
% fprintf('group %s: back 4:4 cond crossings = %.4f\n',groupName, mean(acount4));
% fprintf('group %s: back 5:3 cond crossings = %.4f\n',groupName, mean(acount5));
% fprintf('group %s: back no boundary, 4:4 crossings = %.4f\n',groupName, mean(acountn4));
% fprintf('group %s: back no boundary, 5:3 crossings = %.4f\n',groupName, mean(acountn5));

count4{g}=acount4+acount4f;
count5{g}=acount5+acount5f;
countn4{g}=acountn4+acountn4f;%back and front
countn5{g}=acountn5+acountn5f;

allwithin4{g}=awithin4;
allwithin5{g}=awithin5;
allwithin4n{g}=awithin4n;
allwithin5n{g}=awithin5n;

r4{g}=count4{g}./allwithin4{g};
r5{g}=count5{g}./allwithin5{g};
nr4{g}=countn4{g}./allwithin4n{g};
nr5{g}=countn5{g}./allwithin5n{g};

[h_norm1, p_norm1] = lillietest(acount4f);
[h_norm2, p_norm2] = lillietest(acount4);
if h_norm1 == 0 && h_norm2 == 0 
    disp('4:4 front와 backwards crossing 은 정규분포를 따릅니다.')
    [h, p] = ttest2(acount4f, acount4);
else
    disp('4:4 front와 backwards crossing 은 정규분포를 따르지 않습니다.')
    [p, h] =signrank(acount4f, acount4);
end
if h == 0
    disp([groupNames{g} ', 4:4 front와 backwards crossing 간 유의한 차이가 없습니다.']);
elseif h==1
    disp([groupNames{g} ', 4:4 front와 backwards crossing 간 유의한 차이가 있습니다.']);
end

[h_norm1, p_norm1] = lillietest(acount5f);
[h_norm2, p_norm2] = lillietest(acount5);
if h_norm1 == 0 && h_norm2 == 0 
    disp('5:3 front와 backwards crossing 은 정규분포를 따릅니다.')
    [h, p] = ttest2(acount5f, acount5);
else
    disp('5:3 front와 backwards crossing 은 정규분포를 따르지 않습니다.')
    [p, h] =signrank(acount5f, acount5);
end
if h == 0
    disp([groupNames{g} ', 5:3 front와 backwards crossing 간 유의한 차이가 없습니다.']);
elseif h==1
    disp([groupNames{g} ', 5:3 front와 backwards crossing 간 유의한 차이가 있습니다.']);
end

[h_norm1, p_norm1] = lillietest(acountn4f);
[h_norm2, p_norm2] = lillietest(acountn4);
if h_norm1 == 0 && h_norm2 == 0 
    disp('non bound 4:4 front와 backwards crossing 은 정규분포를 따릅니다.')
    [h, p] = ttest2(acountn4f, acountn4);
else
    disp('non bound 4:4 front와 backwards crossing 은 정규분포를 따르지 않습니다.')
    [p, h] =signrank(acountn4f, acountn4);
end
if h == 0
    disp([groupNames{g} ', non bound, 4:4 front와 backwards crossing 간 유의한 차이가 없습니다.']);
elseif h==1
    disp([groupNames{g} ', non bound, 4:4 front와 backwards crossing 간 유의한 차이가 있습니다.']);
end

[h_norm1, p_norm1] = lillietest(acountn5f);
[h_norm2, p_norm2] = lillietest(acountn5);
if h_norm1 == 0 && h_norm2 == 0 
    disp('non bound 5:3 front와 backwards crossing 은 정규분포를 따릅니다.')
    [h, p] = ttest2(acountn5f, acountn5);
else
    disp('non bound 5:3 front와 backwards crossing 은 정규분포를 따르지 않습니다.')
    [p, h] =signrank(acountn5f, acountn5);
end
if h == 0
    disp([groupNames{g} ', non bound, 5:3 front와 backwards crossing 간 유의한 차이가 없습니다.']);
elseif h==1
    disp([groupNames{g} ', non bound, 5:3 front와 backwards crossing 간 유의한 차이가 있습니다.']);
end

figure;
subplot(1,2,1)
bar({'4:4','5:3','no bound 4:4','no bound 5:3'}, [mean(acount4f),mean(acount5f),mean(acountn4f),mean(acountn5f)], 'FaceColor', 'b');
ylabel('avg number of boundary crossings'); 
ylim([0 0.5])
title(['Front' groupName]);

subplot(1,2,2)
bar({'4:4','5:3','no bound 4:4','no bound 5:3'}, [mean(acount4),mean(acount5),mean(acountn4),mean(acountn5)], 'FaceColor', 'b');
ylabel('avg number of boundary crossings'); 
ylim([0 0.5])
title(['Back' groupName]);

figure;
count_means = [mean(count4{g}), mean(countn4{g}), mean(count5{g}), mean(countn5{g})];
count_ste = [std(count4{g}) / sqrt(numel(count4{g})), ...
               std(countn4{g}) / sqrt(numel(countn4{g})), ...
               std(count5{g}) / sqrt(numel(count5{g})), ...
               std(countn5{g}) / sqrt(numel(countn5{g}))];

awithin_means = [mean(allwithin4{g}), mean(allwithin4n{g}), mean(allwithin5{g}), mean(allwithin5n{g})];
awithin_ste = [std(allwithin4{g}) / sqrt(numel(allwithin4{g})), ...
               std(allwithin5{g}) / sqrt(numel(allwithin5{g})), ...
               std(allwithin4n{g}) / sqrt(numel(allwithin4n{g})), ...
               std(allwithin5n{g}) / sqrt(numel(allwithin5n{g}))];

x_labels = categorical({'4:4','no bound 4:4','5:3','no bound 5:3'});
x_labels = reordercats(x_labels, {'4:4','no bound 4:4','5:3','no bound 5:3'});

data_means = [count_means; awithin_means]';
data_errors = [count_ste; awithin_ste]'; 
b = bar(x_labels, data_means, 'grouped');
b(1).FaceColor = 'b';              
b(2).FaceColor = [0.7 0.85 1]; 
hold on;
nbars = size(data_means, 2);
for i = 1:nbars
    x = b(i).XEndPoints; 
    errorbar(x, data_means(:, i), data_errors(:, i), 'k', 'linestyle', 'none');
end
hold off;

ylabel('avg number of boundary crossings'); 
ylim([0 2.1]);
title(groupName);
legend({'Across boundary', 'Within boundary'}, 'Location', 'Best');

figure;
count_means = [mean(count4{g}), mean(countn4{g}), mean(count5{g}), mean(countn5{g})];
count_ste = [std(count4{g}) / sqrt(numel(count4{g})), ...
               std(countn4{g}) / sqrt(numel(countn4{g})), ...
               std(count5{g}) / sqrt(numel(count5{g})), ...
               std(countn5{g}) / sqrt(numel(countn5{g}))];

x_labels = categorical({'4:4','no bound 4:4','5:3','no bound 5:3'});
x_labels = reordercats(x_labels, {'4:4','no bound 4:4','5:3','no bound 5:3'});

data_means = count_means';
data_errors = count_ste'; 
b = bar(x_labels, count_means, 'grouped');
b(1).FaceColor = 'b';              

hold on;
nbars = size(data_means, 2);
for i = 1:nbars
    x = b(i).XEndPoints; 
    errorbar(x, data_means(:, i), data_errors(:, i), 'k', 'linestyle', 'none');
end
hold off;

ylabel('avg number of boundary crossings'); 
ylim([0 0.9]);
title(groupName);

% figure;
% count_means = [mean(r4{g}), mean(nr4{g}), mean(r5{g}), mean(nr5{g})];
% count_ste = [std(r4{g}) / sqrt(numel(r4{g})), ...
%                std(nr4{g}) / sqrt(numel(nr4{g})), ...
%                std(r5{g}) / sqrt(numel(r5{g})), ...
%                std(nr5{g}) / sqrt(numel(nr5{g}))];
% 
% x_labels = categorical({'4:4','no bound 4:4','5:3','no bound 5:3'});
% x_labels = reordercats(x_labels, {'4:4','no bound 4:4','5:3','no bound 5:3'});
% 
% data_means = count_means';
% data_errors = count_ste'; 
% b = bar(x_labels, count_means, 'grouped');
% b(1).FaceColor = 'b';              
% 
% hold on;
% nbars = size(data_means, 2);
% for i = 1:nbars
%     x = b(i).XEndPoints; 
%     errorbar(x, data_means(:, i), data_errors(:, i), 'k', 'linestyle', 'none');
% end
% hold off;

ylabel('avg ratio of within/across boundary crossings'); 
% ylim([0 0.9]);
title(groupName);

% across boundary
[p, h] = signrank(count4{g}, countn4{g});
fprintf('across boundary, %s 4:4 vs non bound 4:4, h=%d, p=%.4f\n', groupNames{g}, h, p);
[p, h] = signrank(count5{g}, countn5{g});
fprintf('across boundary, %s 5:3 vs non bound 5:3, h=%d, p=%.4f\n', groupNames{g}, h, p);

% within boundary
[p, h] = signrank(allwithin4{g}, allwithin4n{g});
fprintf('within boundary, %s 4:4 vs non bound 4:4, h=%d, p=%.4f\n', groupNames{g}, h, p);
[p, h] = signrank(allwithin5{g}, allwithin5n{g});
fprintf('within boundary, %s 5:3 vs non bound 5:3, h=%d, p=%.4f\n', groupNames{g}, h, p);

%ratio
[p, h] = signrank(r4{g}, nr4{g});
fprintf('ratio, %s 4:4 vs non bound 4:4, h=%d, p=%.4f\n', groupNames{g}, h, p);
[p, h] = signrank(r5{g}, nr5{g});
fprintf('ratio, %s 5:3 vs non bound 5:3, h=%d, p=%.4f\n', groupNames{g}, h, p);
end
