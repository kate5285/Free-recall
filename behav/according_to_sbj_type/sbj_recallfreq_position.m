skipCN = 0;

sbjtype = info{:, 5};
MCI = find(strcmp(sbjtype, 'MCI'));
DM = find(strcmp(sbjtype, 'Dementia')); 
CN = find(strcmp(sbjtype, 'CN')); 

% MCI pos and neg
pntype = info{:, 6};
posMCI = find(strcmp(pntype, 'P') & strcmp(sbjtype, 'MCI'));
negMCI= find(strcmp(pntype, 'N')& strcmp(sbjtype, 'MCI'));

groupNames = {'CN','MCI', 'DM'};
groupRows = {CN,MCI, DM}; 
% groupNames = {'MCI pos', 'MCI neg'};
% groupRows = {posMCI, negMCI};

youngCN = find(info{:, 3}==53);
allrec4=cell(3,1);
allrec5=cell(3,1);
allrecn=cell(3,1);

for g = 1:numel(groupRows)
    groupName = groupNames{g}; 
    groupIndices = groupRows{g};  

    numSubjects = numel(groupIndices);  
    % disp(groupNames{g})
    % disp(numSubjects)

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
 
allrec4{g}=patrec4; %save for use later
allrec5{g}=patrec5;
allrecn{g}=patrecn;

    for pos = 1:8
        for i = 1:numSubjects
            if ~isempty(patrec4{i}) 
                pallpos4{pos} = [pallpos4{pos}; patrec4{i}(pos)];
            end
            if ~isempty(patrec5{i}) 
                pallpos5{pos} = [pallpos5{pos}; patrec5{i}(pos)];
            end
            if ~isempty(patrecn{i}) 
                pallposn{pos} = [pallposn{pos}; patrecn{i}(pos)];
            end
        end
    end
    mean_pos4 = zeros(8, 1); mean_pos5 = zeros(8, 1);mean_posn = zeros(8, 1);
    ste_pos4 = zeros(8, 1);  ste_pos5 = zeros(8, 1); ste_posn = zeros(8, 1);

   for pos = 1:8
   mean_pos4(pos) = mean(pallpos4{pos});
   ste_pos4(pos) = std(pallpos4{pos}) / sqrt(length(pallpos4{pos}));
   mean_pos5(pos) = mean(pallpos5{pos});
   ste_pos5(pos) = std(pallpos5{pos}) / sqrt(length(pallpos5{pos}));
   mean_posn(pos) = mean(pallposn{pos});
   ste_posn(pos) = std(pallposn{pos}) / sqrt(length(pallposn{pos}));
   end

   figure('Name', groupName,'Position', [100, 100, 1200, 400]);
   subplot(1, 3, 1);
   bar(1:8, mean_pos4);
   hold on;
   errorbar(1:8, mean_pos4, ste_pos4, 'k', 'linestyle', 'none');
    % for pos = 1:8
    % scatter(repmat(pos, numel(pallpos4 {pos}), 1), pallpos4 {pos}, 'k', 'filled');
    % end
   title('Boundary 4:4');
   xlabel('Position');
   ylim1=ylim();
   ylabel('avg recall frequency');

   subplot(1, 3, 2);
   bar(1:8, mean_pos5);
   hold on;
   errorbar(1:8, mean_pos5, ste_pos5, 'k', 'linestyle', 'none');
   % for pos = 1:8
   %  scatter(repmat(pos, numel(pallpos5 {pos}), 1), pallpos5 {pos}, 'k', 'filled');
   %  end
   title('Boundary 5:3');
   xlabel('Position');
   ylim2=ylim();
   ylabel('avg recall frequency');

   subplot(1, 3, 3);
   bar(1:8, mean_posn);
   hold on;
   errorbar(1:8, mean_posn, ste_posn, 'k', 'linestyle', 'none');
   % for pos = 1:8
   %  scatter(repmat(pos, numel(pallposn {pos}), 1), pallposn {pos}, 'k', 'filled');
   %  end
   title('No Boundary');
   xlabel('Position');
   ylim3=ylim();
   ylabel('avg recall frequency');

   common_ylim = [0, max([ylim1(2), ylim2(2),ylim3(2)])];
   figure(gcf);
   subplot(1, 3, 1);
   ylim(common_ylim);
   subplot(1, 3, 2);
   ylim(common_ylim);
   subplot(1, 3, 3);
   ylim(common_ylim);
end
