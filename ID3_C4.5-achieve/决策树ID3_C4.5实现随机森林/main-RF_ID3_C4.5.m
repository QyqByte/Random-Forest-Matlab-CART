clear 
clc
%warning off 
% 导入数据

 % [allresultch2,~,~] = xlsread('D:\随机森林数据库\qiEXC\qi\2\pi2.xlsx');
[allresultch2,~,~] = xlsread('C:\Users\Administrator\Desktop\allresultch-2.xlsx');

new_data = data_resize(allresultch2,185,185);

% b = [1,3,40,12,24,36,48,75,71,58,67,52,33,56,72,25,76]; % 第一期 0.575
% b = [1,71,10,63,27,47,67,80,35,18,52,60,69,54,49,62,72]; % 第二期 0.69167
% b = [1,71,49,20,46,5,65,24,3,44,33,4,70,64,37,34,17,68,25]; % 第三期 0.65806
% b = [1,3,53,27,12,48,68,44,75,60,24,71,77,58,65,70,79]; % 第四期 0.66452
% b = [1,10,5,20,16,4,18,29,8,67,48,64,26,27,40,12,68,35,59]; % 第五期 0.69677
b = [1,72,35,21,70,46,49,73,26,45,68,57,25,28,66,11,41,69];  % RF提取特征（0.1测试集）：0.64667，0.65311(C4.5)

 data = new_data(:,b);
% data = allresultch2(:,b);
Train = data(:,2:end);
Test = data(:,1);

accuracy = zeros(1,5);
% for i = 1:5
   [inputdata_col,inputdata_row] = size(Train);
    indices=crossvalind('Kfold',Train(1:inputdata_col,inputdata_row),5);  %进行随机分包
   

    for k=1:5  %交叉验证k=5，5个包轮流作为测试集
        test = (indices == k);   %获得test集元素在数据集中对应的单元编号
        ktrain = ~test;  %train集元素的编号为非test元素的编号
        P_train=Train(ktrain,:);%从数据集中划分出train样本的数据
        T_train=Test(ktrain,:);
        P_test=Train(test,:);  %test样本集
        T_test=Test(test,:);

    
     P_train= bsxfun(@rdivide, bsxfun(@minus, P_train, mean(P_train)), var(P_train) + 1e-10); 
     P_test= bsxfun(@rdivide, bsxfun(@minus, P_test, mean(P_test)), var(P_test) + 1e-10); 
    


     % 创建随机森林

%     rand('state', 0);
%     randn('state', 0);

    opts= struct;
    opts.depth= 9;
    opts.numTrees= 300;
    opts.numSplits= 6; % 为随机选择特征计算以后的循环次数。
    opts.verbose= false; % 当其为true的时候可以详细显示正在构建的树木
    opts.classifierID= [1,2,3,4]; % 1-决策树桩，2-二维线性决策学习，3-二维二次曲线分段学习（圆锥曲线学习），4-RBF弱学习:选取实例，根据距离阈值进行决策
    opts.classifierCommitFirst= false; % 当其为true的时候，opts.classifierID 中的算法，将随机选取其中一个（若为false，则会运行所有算法，并留取表现最优的）
    opts.algorithmclass = 2; % 当其为1的时候，使用ID3算法，当其为2的时候，使用C4.5算法

    tic;
    m= forestTrain(P_train, T_train, opts);
    timetrain= toc;
    tic;
    T_sim = forestTest(m, P_test,opts);
    timetest= toc;
    
    
% Look at classifier distribution for fun, to see what classifiers were
% chosen at split nodes and how often
fprintf('Classifier distributions:\n');
classifierDist= zeros(1, 4);
unused= 0;
for b=1:length(m.treeModels)
    for j=1:length(m.treeModels{b}.weakModels)
        cc= m.treeModels{b}.weakModels{j}.classifierID;
        if cc>1 %otherwise no classifier was used at that node
            classifierDist(cc)= classifierDist(cc) + 1;
        else
            unused= unused+1;
        end
    end
end
fprintf('%d nodes were empty and had no classifier.\n', unused);
for b=1:4
    fprintf('Classifier with id=%d was used at %d nodes.\n', b, classifierDist(b));
end

    % 结果分析
    count_B = length(find(T_train == 0));
    count_M = length(find(T_train == 1));
    total_B = length(find(data(:,1) == 0));
    total_M = length(find(data(:,1) == 1));
    number_B = length(find(T_test == 0));
    number_M = length(find(T_test == 1));
    number_B_sim = length(find(T_sim == 0& T_test == 0));
    number_M_sim = length(find(T_sim == 1& T_test == 1));

    disp(['病例总数：' num2str(length(data)) ...
    '    良性：' num2str(total_B) '    恶性：' num2str(total_M)]);
    disp(['训练集病例总数：' num2str(length(Train)) '    良性：' num2str(count_B) ...
    '    恶性：' num2str(count_M)]);
    disp(['测试集病例总数：' num2str(length(Test)) '    良性：' num2str(number_B) ...
    '    恶性：' num2str(number_M)]);
    disp(['良性乳腺肿瘤确诊：' num2str(number_B_sim) '    误诊：' num2str(number_B - number_B_sim) ...
    '    确诊率：' num2str(number_B_sim/number_B*100) '%']);
    disp(['恶性乳腺肿瘤确诊：' num2str(number_M_sim) '    误诊：' num2str(number_M - number_M_sim) ...
    '    确诊率：' num2str(number_M_sim/number_M*100) '%']);
    disp(['平均准确率： ' num2str(length(find(T_test == T_sim))/length(T_test)) ]);
    accuracy(k) = length(find(T_test == T_sim))/length(T_test);
    fprintf('Training accuracy = %.2f\n', mean(T_sim == T_test));
end 
disp(['每次平均准确率为： ' num2str(accuracy)]);
disp([ ' 总分类率：' num2str(mean(accuracy)) ]);

