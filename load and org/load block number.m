 load('C:\Users\Leelab_Intern\Desktop\doyeon kim\free recall\boundary_file1.mat')  % load block numbers
 numSubjects = length(Alldata);
 for i = 1:numSubjects
        correct_block_order = word_boundary{i};
        for j = 1:length(correct_block_order)  
            Alldata{i,1}{j,1}.blocknum = correct_block_order(j);
        end
end
