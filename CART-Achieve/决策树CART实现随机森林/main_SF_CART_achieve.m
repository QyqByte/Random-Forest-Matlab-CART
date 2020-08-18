clear
clc

[allresultch2,~,~] = xlsread('C:\Users\Administrator\Desktop\allresultch-2.xlsx');
new_data = data_resize(allresultch2,185,185);
% 如果不需要提取特征，这里就不需要再使用b
% b = [1,72,35,21,70,46,49,73,26,45,68,57,25,28,66,11,41,69];  % RF提取特征（0.1测试集）：0.74368
% b = [1,2,12,14,17,58,77,46,8,7,10,4,42,18,61,70,15,75,40,56,73];  % 欧式距离

originalglszm = new_data(:,b);
Train = originalglszm(:,2:end);
Test = originalglszm(:,1);
[inputdata_col,inputdata_row] = size(Train);
indices=crossvalind('Kfold',Train(1:inputdata_col,inputdata_row),5);  %进行随机分包
meanaccuracy = zeros(1,5);

for k=1:5  %交叉验证k=5，5个包轮流作为测试集
        test = (indices == k);   %获得test集元素在数据集中对应的单元编号
        ktrain = ~test;  %train集元素的编号为非test元素的编号
        P_train=Train(ktrain,:);%从数据集中划分出train样本的数据
        T_train=Test(ktrain,:)';
        P_test=Train(test,:);  %test样本集
        T_test=Test(test,:);


    % Training Forest
    maxGiniImpurity = 0.5; % 基尼纯度不能设置太低，不然会陷入无限循环
    numOfTree = 300;
    baggingSampleSize = 400;
    numRandFeatures = floor(sqrt(size(originalglszm,2))); % floor(x) 函数向下取整；ceil(x) 函数向上取整；round(x) 函数取最接近的整数
    train_data_split = false;
    
    L = trainForest(P_train, T_train, maxGiniImpurity, numOfTree, ...
    baggingSampleSize, numRandFeatures, train_data_split);
    disp('Forest is trained.')
    
    % 测试
%     p_test = P_test(3,:);
    outputlist = zeros(size(P_test,1),1);
    for key = 1:size(P_test,1)
        
        T = testData(L,P_test(key,:));
        outputlist(key,1) = leafLabelDistri(T);
    end
    
        count_B = length(find(T_train == 0));
        count_M = length(find(T_train == 1));
        total_B = length(find(originalglszm(:,1) == 0));
        total_M = length(find(originalglszm(:,1) == 1));
        number_B = length(find(T_test == 0));
        number_M = length(find(T_test == 1));
        number_B_sim = length(find(outputlist == 0& T_test == 0));
        number_M_sim = length(find(outputlist == 1& T_test == 1));
        meanaccuracy(k) = length(find(T_test == outputlist))/length(T_test);
        disp(['病例总数：' num2str(total_B + total_M) ...
        '    良性：' num2str(total_B) '    恶性：' num2str(total_M)]);
        disp(['训练集病例总数：' num2str(length(P_train)) '    良性：' num2str(count_B) ...
        '    恶性：' num2str(count_M)]);
        disp(['测试集病例总数：' num2str(length(P_test)) '    良性：' num2str(number_B) ...
        '    恶性：' num2str(number_M)]);
        disp(['良性乳腺肿瘤确诊：' num2str(number_B_sim) '    误诊：' num2str(number_B - number_B_sim) ...
        '    确诊率：' num2str(number_B_sim/number_B*100) '%']);
        disp(['恶性乳腺肿瘤确诊：' num2str(number_M_sim) '    误诊：' num2str(number_M - number_M_sim) ...
        '    确诊率：' num2str(number_M_sim/number_M*100) '%']);
        disp(['总准确率:' num2str(length(find(T_test == outputlist))/length(T_test))]);
        
    
%     totalmean(i) = mean(meanaccuracy);
end
disp(['五折交叉验证准确率分别为： ' num2str(meanaccuracy) ]);
disp(['平均分类准确率为： ' num2str(mean(meanaccuracy)) ]);
