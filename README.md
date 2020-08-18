# Random-Forest-Matlab-CART
使用决策树ID3，C4.5，CART分别生成随机森林

1 ID3，C4.5 决策树实现随机森林，具体用法如下所示：

opts= struct;
    opts.depth= 9;
    opts.numTrees= 300;
    opts.numSplits= 6; % 为随机选择特征计算以后的循环次数。
    opts.verbose= false; % 当其为true的时候可以详细显示正在构建的树木
    opts.classifierID= [1,2,3,4]; % 1-决策树桩，2-二维线性决策学习，3-二维二次曲线分段学习（圆锥曲线学习），4-RBF弱学习:选取实例，根据距离阈值进行决策
    opts.classifierCommitFirst= false; % 当其为true的时候，opts.classifierID 中的算法，将随机选取其中一个（若为false，则会运行所有算法，并留取表现最优的）
    opts.algorithmclass = 2; % 当其为1的时候，使用ID3算法，当其为2的时候，使用C4.5算法
   
model= forestTrain(P_train, T_train, opts); % 进行模型训练
T_sim = forestTest(m, P_test,opts); % 使用测试集进行测试

注：如果你想添加自己的决策树算法，在 weakTrain.m 函数中添加额外的 elseif 语句即可（需相应的在 weakTest.m 函数中添加测试判断语句 elseif）。

2 CART 决策树实现随机森林，具体用法如下所示：

   % Training Forest
   maxGiniImpurity = 0.48; % 基尼纯度不能设置太低，不然会陷入无限循环
   numOfTree = 30; % 生成的决策树颗数
   baggingSampleSize = 400; % 对训练数据进行预处理，将所有的训练数据再随机分开提取，用于构建决策树
   numRandFeatures = floor(sqrt(size(originalglszm,2))); % floor(x) 函数向下取整；ceil(x) 函数向上取整；round(x) 函数取最接近的整数
   train_data_split = false; % 只有当这个参数设置为true时，baggingSampleSize 才会工作
    
   L = trainForest(P_train, T_train, maxGiniImpurity, numOfTree, ...
   baggingSampleSize, numRandFeatures, train_data_split);
   disp('Forest is trained.')
    
   % 测试

   outputlist = zeros(size(P_test,1),1); % 将对每个样本的预测结果填入该数组中
   for key = 1:size(P_test,1)
        
       T = testData(L,P_test(key,:));
       outputlist(key,1) = leafLabelDistri(T);
   end
