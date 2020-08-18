function [ impurity ] = getImpurity( labels )
% Calculating Gini Impurity
if(isempty(labels))
    impurity=0;
else
    [elements, ~] = hist(labels, unique(labels));
    for i=1:length(elements)
        elements(i)=(elements(i)/length(labels))^2;
    end
    impurity = 1-sum(elements);
end
end