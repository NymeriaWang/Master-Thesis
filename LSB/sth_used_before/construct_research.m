function exp_data = construct_research()
%data constrcution
addpath('./tool/');
addpath('./data/image');%将这两个文件夹设置为搜索优先路径

data=imread('research.png');
data=rgb2gray(data)
data=im2bw(data)

figure(1)
imshow(data);
title('原图')
data=double(data)



groundtruth = data;

exp_data.ndim = 1; %number of nneighbors per class

exp_data.train_data = data;

exp_data.db_data = data;
exp_data.groundtruth{1} = groundtruth;%single label test

end