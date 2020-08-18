function [ headNodeList ] = headNodes( numOfTree )
headNodeList = cell(1,numOfTree);
for i=1:numOfTree
    headNodeList{i} = treeNode();
end

