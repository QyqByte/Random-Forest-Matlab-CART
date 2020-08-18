function [listTrainSet, listlabelsSet] = Bagging( data, labels, trainingSetSize, numberOfTree)
% Prepare bagging data for each tree.

listTrainSet = cell(1,numberOfTree);
listlabelsSet = cell(1,numberOfTree);
for i=1:numberOfTree
    random = randi(length(data),1,trainingSetSize); %返回一个 由介于1和length(data) 之间的伪随机数组成的 1*trainingSetSize 数组
    listTrainSet{i}= data(random,:);
    listlabelsSet{i} = labels(random);
end
end
