function model = treeTrain(X, Y, opts)
% Train a random tree
% X is NxD, each D-dimensional row is a data point
% Y is Nx1 discrete labels of classes
% returned model is to be directly plugged into treeTest

d= 5; % max depth of the tree

if nargin < 3, opts= struct; end
if isfield(opts, 'depth'), d= opts.depth; end

u= unique(Y); % u = 0，1
[N, D]= size(X);% N = 555， D = 17
nd= 2^d - 1; % 当d = 5时， nd = 31
numInternals = (nd+1)/2 - 1; % = 15
numLeafs= (nd+1)/2; % 16

weakModels= cell(1, numInternals);   % 返回一个1*numInternals 的元胞数组
% if we can afford to store as non-sparse (100MB array, say), it is
% slightly faster.
if storage([N nd]) < 100 
    dataix= zeros(N, nd); % boolean indicator of data at each node
else
    dataix= sparse(N, nd); % 创建稀疏矩阵
end
    
leafdist= zeros(numLeafs, length(u)); % leaf distribution

% Propagate data down the tree while training weak classifiers at each node
for n = 1: numInternals
    
    % get relevant data at this node
    if n==1 
        reld = ones(N, 1)==1;
        Xrel= X;
        Yrel= Y;
    else
        reld = dataix(:, n)==1;
        Xrel = X(reld, :);
        Yrel = Y(reld);
    end
    
    % train weak model
    weakModels{n}= weakTrain(Xrel, Yrel, opts);
    
    % split data to child nodes
    yhat= weakTest(weakModels{n}, Xrel, opts);
    
    dataix(reld, 2*n)= yhat;
    dataix(reld, 2*n+1)= 1 - yhat; % since yhat is in {0,1} and double
end

% Go over leaf nodes and assign class statistics
for n= (nd+1)/2 : nd % 16：32
    reld= dataix(:, n);
    hc = histc(Y(reld==1), u); % 直方图上的bin计数
    hc = hc + 1; % Dirichlet prior 狄利克雷优先
    leafdist(n - (nd+1)/2 + 1, :)= hc / sum(hc);
end

model.leafdist= leafdist;
model.depth= d;
model.classes= u;
model.weakModels= weakModels;
end
