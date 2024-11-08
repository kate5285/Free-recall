emb = fastTextWordEmbedding;
groupResults = cell(9, 2);
wordmatrix=cell(9,1);
allwordVectors=cell(9,1);
for i = 1:9
    words = table2cell(ktoengwords(i, :)); 
    wordVectors = word2vec(emb, words);
    allwordVectors{i}=wordVectors;
    wordAssignments = cell(1000, 2);
    similarityMatrix = pdist2(wordVectors, wordVectors, 'cosine');%cosine으로 거리 구함
    tolerance = 1e-6; % 부동소수점 오차 임계값 설정
    similarityMatrix(abs(similarityMatrix) < tolerance) = 0;

    %ssimilarityMatrix = corr(wordVectors');%in case you want to use corr for distance
    wordmatrix{i,1}=similarityMatrix;
end
