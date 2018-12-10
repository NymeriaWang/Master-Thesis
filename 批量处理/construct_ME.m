function exp_data = construct_ME()
%data constrcution
addpath('./tool/');
addpath('./data/image');%���������ļ�������Ϊ��������·��

file_path = '.\image\';
img_path_list = dir(strcat(file_path,'*.jpg'));%��ȡ���ļ���������jpg��ʽ��ͼ��  
img_num = length(img_path_list);%��ȡͼ��������  
if img_num > 0 %������������ͼ��  
for j = 1:img_num %��һ��ȡͼ��  
image_name = img_path_list(j).name;% ͼ����  
image =  imread(strcat(file_path,image_name));
data=rgb2gray(image);


figure(2*j-1)
imshow(data);
title('ԭͼ')
data=double(data);

P{j}=data;
end
end


for j = 1:img_num

exp_data.groundtruth{j} = P{j};
exp_data.test_imgnum=img_num
exp_data.ndim = 1; %number of nneighbors per class

exp_data.train_data{j} = P{j};
exp_data.count=j;
exp_data.db_data{j} = P{j};
%exp_data.groundtruth{1} = groundtruth;%single label test
end
end