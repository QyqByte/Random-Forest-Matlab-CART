function [ cluster ] = testData( treeList, testPoint )
clusList = cell(1,length(treeList));
for i=1:length(treeList)
    class = followNode(treeList{i},testPoint);
    clusList{i} = class;
end
cluster = clusList;
end