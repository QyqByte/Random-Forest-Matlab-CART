function [ attract ] = attract( nodeImp, subSetList)
% Calculating attractiveness

numOfSubData1 = length(subSetList{2});
numOfSubData2 = length(subSetList{4});
numOfData = numOfSubData1 + numOfSubData2;

imp1 = getImpurity(subSetList{2});
imp2 = getImpurity(subSetList{4});

fraction1 = numOfSubData1/numOfData;
fraction2 = numOfSubData2/numOfData;

attract = nodeImp - imp1*fraction1 - imp2*fraction2;

end

