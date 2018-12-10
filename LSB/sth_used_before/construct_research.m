function exp_data = construct_research()
%data constrcution
addpath('./tool/');
addpath('./data/image');%���������ļ�������Ϊ��������·��

data=imread('research.png');
data=rgb2gray(data)
data=im2bw(data)

figure(1)
imshow(data);
title('ԭͼ')
data=double(data)



groundtruth = data;

exp_data.ndim = 1; %number of nneighbors per class

exp_data.train_data = data;

exp_data.db_data = data;
exp_data.groundtruth{1} = groundtruth;%single label test

end