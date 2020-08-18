# Random-Forest-Matlab-CART
使用决策树ID3，C4.5，CART分别生成随机森林

1、ID3，C4.5 决策树实现随机森林，具体用法如下所示：

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
