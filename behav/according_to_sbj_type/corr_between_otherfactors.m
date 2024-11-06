%% correlation between different factors
'age and MMSE'
[r,p]=corr(age,mmse)
'edu and MMSE'
[r,p]=corr(edu,mmse)
'age and edu'
[r,p]=corr(age,edu)
groupNames = {'CN','MCI', 'DM'};
groupRows = {CN,MCI, DM}; 
% groupNames = {'MCI pos', 'MCI neg'};
% groupRows = {posMCI, negMCI};

for g = 1:numel(groupRows)
    groupName = groupNames{g}
    groupIndices = groupRows{g};
    numSubjects = numel(groupIndices);
0
'age and MMSE'
[r,p]=corr(age(groupIndices),mmse(groupIndices))
'edu and MMSE'
[r,p]=corr(edu(groupIndices),mmse(groupIndices))
'age and edu'
[r,p]=corr(age(groupIndices),edu(groupIndices))

end
