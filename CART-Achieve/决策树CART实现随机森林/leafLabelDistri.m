function [ outputlist ] = leafLabelDistri( leafList )
% Given leafList, distribution of the labels is calculated.  

L=cell(1,length(leafList));
for k = 1:length(leafList) % 实现对每棵树的预测结果做一个统计，并分别求出该元胞对预测结果的概率
    classes=unique(leafList{k});
    elements= zeros(1,length(classes));
    for i = 1:length(leafList{k})
        for j=1:length(classes)
            if (leafList{k}(i) == classes(j))
                elements(j)=elements(j)+1;
                break
            end
        end
    end
    elements = elements./length(leafList{k});
    L{k}=[elements ; classes];
end

output = sumLeafProb(L);
output(1,:) = output(1,:)/length(L); %将获得的output对0和1的预测值求和之后再求平均。
if output(1,1)>=output(1,2)
    outputlist = output(2,1);
else
    outputlist = output(2,2);
    
% disp(join(["Percentage :", string(output(1,:))]));
% disp(join(["Label      :", string(output(2,:))]));
end