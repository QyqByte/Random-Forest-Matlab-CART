function [ headNodeList ] = trainForest( data, labels, maxImp, ...
    numOfTree, trainingdataSize, numRandFeatures,train_data_split)
% This function trains a random forest returns head/root node list of each tree
% trainingdataSize 为从数据集里随机抽取的用于训练的数据的个数
% Prepairing training data for each tree


if train_data_split
    [dataList, labelList] = Bagging(data, labels, trainingdataSize, numOfTree); % 用于随机分割数据，获得训练用数据集
else
    
    dataList = cell(1,numOfTree);
    labelList = cell(1,numOfTree);
    for i=1:numOfTree
        random = randi(length(data),1,length(data)); %返回一个 由介于1和length(data) 之间的伪随机数组成的 1*trainingSetSize 数组
        dataList{i}= data(random,:);
        labelList{i} = labels(random);
    end
end
% Empty head nodes of each tree
headNodeList = headNodes(numOfTree);

% Training each tree
for i=1:numOfTree
    constructNode(headNodeList{i}, dataList{i}, labelList{i}, maxImp, ...
        numRandFeatures);
end
end