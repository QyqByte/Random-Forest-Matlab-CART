function [ output ] = sumLeafProb( L )
clusters = L{1}(2,:);
probability = L{1}(1,:);
for i = 2:length(L) % L 中存放的是十个森林的每个预测分类预测的概率，这里做的是将该十个森林的预测的1和0的该路叠加。
    clust = L{i}(2,:);
    prob = L{i}(1,:);
    for j = 1:length(clust)
        result = find(clusters == clust(j));
        if isempty(result)
            [~, m] = size(clusters);
            clusters(:,m+1) = clust(j);
            probability(:,m+1) = prob(j);
        else
            probability(result) = probability(result)+prob(j);
        end
    end
end
output = [probability ; clusters];
end