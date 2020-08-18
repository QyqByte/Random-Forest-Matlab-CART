function [ subSetList ] = getSubSets( set, labels, feature, point )
% Spliting the set to 2 subsets from a given point and feature vector.
subSetList = cell(1,4);

feVector = set(:,feature);
ind = feVector >= point;

subSet1 = set(ind,:);
labels1 = labels(ind);

subSet2 = set(~ind,:);
labels2 = labels(~ind);

subSetList{1} = subSet1;
subSetList{2} = labels1;
subSetList{3} = subSet2;
subSetList{4} = labels2;
end