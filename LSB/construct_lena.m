function exp_data = construct_lena()
%data constrcution
addpath('./tool/');
addpath('./data/image');%将这两个文件夹设置为搜索优先路径




load('lena.mat');
data=lena512;

figure(1)
imshow(data,[0,255]);
title('Initial Picture')
data=double(data)



groundtruth = data;

exp_data.ndim = 1; %number of nneighbors per class

exp_data.train_data = data;

exp_data.db_data = data;
exp_data.groundtruth{1} = groundtruth;%single label test

end