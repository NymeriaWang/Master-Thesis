function exp_data = construct_ME()
%data constrcution
addpath('./tool/');
addpath('./data/image');%将这两个文件夹设置为搜索优先路径

file_path = '.\image\';
img_path_list = dir(strcat(file_path,'*.jpg'));%获取该文件夹中所有jpg格式的图像  
img_num = length(img_path_list);%获取图像总数量  
if img_num > 0 %有满足条件的图像  
for j = 1:img_num %逐一读取图像  
image_name = img_path_list(j).name;% 图像名  
image =  imread(strcat(file_path,image_name));
data=rgb2gray(image);


figure(2*j-1)
imshow(data);
title('原图')
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