function [ best ] = bestPointOnFeature(set, labels, feature)
% Finding best split point on given feature by comparing attractiveness of
% each point

nodeImp = getImpurity(labels);
best = 0;
[m, ~]= size(set);
for i = 1:m
    L = getSubSets(set,labels,feature,set(i,feature));
    attractive = attract(nodeImp,L);
    if (attractive > best(1))
        best(1) = attractive;
        best(2) = set(i,feature);
    end
end
best(3)= feature;
end