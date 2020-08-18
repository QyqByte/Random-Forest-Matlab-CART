function [ ] = constructNode( node, set, labels, maxImp, numRandFeatures)
% Training nodes on a decision tree recursively untill max impurity 
% satisfied

% Best split among randomly choosen features，利用这个函数随机选择numRandFeatures个特征里面最佳的
separationPoint = getSeparation(set, labels, numRandFeatures);
% Current node Impurity，得到当前节点的基尼指数
separationPoint(1) = getImpurity(labels);
% Setting current node info
setData(node, separationPoint);
% Prepairing 2 sub nodes.
subNode1 = treeNode();
subNode2 = treeNode();
% Connecting 2 subnodes to current node
setHigher(subNode1, node);
setLower(subNode2, node);
% Prepairing the subsets，将训练集以特定点（separationPOint（2））来将训练集分割成两个子集
subSets = getSubSets(set, labels, separationPoint(3), separationPoint(2));
%subSetList{1} = subSet1;   subSetList{2} = labels1;    subSetList{3} = subSet2;    subSetList{4} = labels2;
imp1 = getImpurity(subSets{2});
imp2 = getImpurity(subSets{4});

% Stop condition of the recursion and training subsets of current node.当前节点的递归和训练子集的停止条件
if (imp1 < maxImp)
    setData(subNode1, subSets{2});
else
    constructNode(subNode1, subSets{1}, subSets{2}, maxImp, ...
        numRandFeatures);
end

if (imp2 < maxImp)
    setData(subNode2, subSets{4});
else
    constructNode(subNode2, subSets{3}, subSets{4}, maxImp, ...
        numRandFeatures);
end
end