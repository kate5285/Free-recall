emb = fastTextWordEmbedding;
groupResults = cell(9, 2);
wordmatrix=cell(9,1);
allwordVectors=cell(9,1);
for i = 1:9
    words = table2cell(ktoengwords(i, :)); 
    wordVectors = word2vec(emb, words);
    allwordVectors{i}=wordVectors;
    wordAssignments = cell(1000, 2);
    similarityMatrix = pdist2(wordVectors, wordVectors, 'cosine');%I used cosine for distance
    tolerance = 1e-6; % error threshold
    similarityMatrix(abs(similarityMatrix) < tolerance) = 0;

    %ssimilarityMatrix = corr(wordVectors');%in case you want to use corr for distance
    wordmatrix{i,1}=similarityMatrix;
end

%skipCN = 0; %code below is for calculating center of word groups and their distances
% sbjtype = info{:, 5};
% MCI = find(strcmp(sbjtype, 'MCI')); 
% DM = find(strcmp(sbjtype, 'Dementia')); 
% CN = find(strcmp(sbjtype, 'CN')); 
% 
% groupNames = {'CN','MCI', 'DM'};
% groupRows = {CN,MCI, DM};  
% % groupNames = {'MCI pos', 'MCI neg'};
% % groupRows = {posMCI, negMCI};
% front4dist=cell(3,1);front5dist=cell(3,1);
% back4dist=cell(3,1);back5dist=cell(3,1);
% for g = 1:numel(groupRows)
%     for j=1:9
%         if any (j == [1,2,3])
%     front4dist{j}=horzcat(wordmatrix{j}(1,2:4),wordmatrix{j}(2,3:4),wordmatrix{j}(3,4));
%     back4dist{j}=horzcat(wordmatrix{j}(5,6:8),wordmatrix{j}(6,7:8),wordmatrix{j}(7,8));
%         elseif any (j == [4,5,6])
%     front5dist{j-3}=horzcat(wordmatrix{j}(1,2:5),wordmatrix{j}(2,3:5),wordmatrix{j}(3,4:5),wordmatrix{j}(4,5));
%     back5dist{j-3}=horzcat(wordmatrix{j}(6,7:8),wordmatrix{j}(7,8));
%         end
%     end
% end
% f4mdist=[];f5mdist=[];b4mdist=[];b5mdist=[];
% for i=1:3
% f4mdist=[f4mdist;mean(front4dist{i})];
% f5mdist=[f5mdist;mean(front5dist{i})];
% b4mdist=[b4mdist;mean(back4dist{i})];
% b5mdist=[b5mdist;mean(back5dist{i})];
% end
% 
%     f4distGroup = []; f5distGroup = []; b4distGroup = []; b5distGroup = [];
%     for j = 1:9
%         wordVectors = allwordVectors{j};
% 
%         if any(j == [1, 2, 3])
%             front4Center = mean(wordVectors(1:4, :), 1); 
%             f4distGroup = [f4distGroup; front4Center];
% 
%             back4Center = mean(wordVectors(5:8, :), 1);
%             b4distGroup = [b4distGroup; back4Center];
% 
%         elseif any(j == [4, 5, 6])
%             front5Center = mean(wordVectors(1:5, :), 1);
%             f5distGroup = [f5distGroup; front5Center];
% 
%             back5Center = mean(wordVectors(6:8, :), 1);
%             b5distGroup = [b5distGroup; back5Center];
%         end
%     end
% 
% %%
% for g = 1:numel(groupRows)
%     figure;
%     y41=[];y42=[];y43=[];y51=[];y52=[];y53=[];
%     for j=1:9
%         if any (j == [1,2,3])
%             for i=1:numel(cbacks{g}{2})/3
%                 y41=[y41;abs(cfronts{g}{1}(3*(i-1)+1)-cbacks{g}{1}(3*(i-1)+1))];
%                 y42=[y42;abs(cfronts{g}{1}(3*(i-1)+2)-cbacks{g}{1}(3*(i-1)+2))];
%                 y43=[y43;abs(cfronts{g}{1}(3*(i-1)+3)-cbacks{g}{1}(3*(i-1)+3))];
%             end
%         elseif any (j == [4,5,6])
%             for i=1:numel(cbacks{g}{2})/3
%                 y51=[y51;abs(cfronts{g}{2}(3*(i-1)+1)-cbacks{g}{2}(3*(i-1)+1))];
%                 y52=[y52;abs(cfronts{g}{2}(3*(i-1)+2)-cbacks{g}{2}(3*(i-1)+2))];
%                 y53=[y53;abs(cfronts{g}{2}(3*(i-1)+3)-cbacks{g}{2}(3*(i-1)+3))];
%             end
%         end
%     end
% plot(pdist2(f4distGroup(1,:),b4distGroup(1,:),'cosine'),mean(y51),'r.');hold on;
% plot(pdist2(f4distGroup(2,:),b4distGroup(2,:),'cosine'),mean(y52),'r.');hold on;
% plot(pdist2(f4distGroup(3,:),b4distGroup(3,:),'cosine'),mean(y53),'r.');hold on;
% 
% plot(pdist2(f5distGroup(1,:),b5distGroup(1,:),'cosine'),mean(y51),'k.');hold on;
% plot(pdist2(f5distGroup(2,:),b5distGroup(2,:),'cosine'),mean(y52),'k.');hold on;
% plot(pdist2(f5distGroup(3,:),b5distGroup(3,:),'cosine'),mean(y53),'k.');hold on;
% end
