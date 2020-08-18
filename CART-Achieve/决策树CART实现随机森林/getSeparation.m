function [ bestSplitPoint ] = getSeparation(set, labels, numRandFeatures)
% Get best splitting point among the randomly selected numRandFeatures. 

% Selecting random features
randomDimention = randi(size(set,2),1,numRandFeatures);
% Best point for each randomly selected features.
bestPoints = zeros(numRandFeatures,3);
for i= 1:length(randomDimention)
    bestPoints(i,:) = bestPointOnFeature(set,labels,randomDimention(i));
end
bestSplitPoint = bestPoints(1,:);
for i=2:length(randomDimention)
    if(bestSplitPoint(1) < bestPoints(i,1))
        bestSplitPoint = bestPoints(i,:);
    end
end
end