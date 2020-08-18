function new_data = data_resize(numallsour,pos_num,neg_num)
data_col = size(numallsour,1);
data_row = size(numallsour,2);
new_data = zeros(pos_num+neg_num,data_row);
new_datatmp = zeros(pos_num+neg_num,data_row);
%%
%分类
m = 1;n = 1;
for i = 1:data_col
    if numallsour(i,1) == 1
        pos(m,:) = numallsour(i,:);
        m = m+1;
    else
        neg(n,:) = numallsour(i,:);
        n = n+1;
    end
end
%%
%随机选取阴阳
k = rand(1,neg_num);
[~,n] = sort(k);
neg_r = neg(n(1:neg_num),:);
k = rand(1,pos_num);
[~,n] = sort(k);
pos_r = pos(n(1:pos_num),:);
%%
%数据生成并乱序
new_datatmp(1:neg_num,:) = neg_r(:,:);
new_datatmp(neg_num+1:pos_num+neg_num,:) = pos_r(:,:);
k = rand(1,pos_num+neg_num);
[~,n] = sort(k);
new_data = new_datatmp(n,:);
