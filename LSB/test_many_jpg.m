%------------------------3.5 ny--------------------------------------------
file_path =  './data/image';
img_path_list = dir(strcat(file_path,'*.jpg'));%��ȡ���ļ���������jpg��ʽ��ͼ��  
img_num = length(img_path_list);%��ȡͼ��������  
if img_num > 0 %������������ͼ��  
for j = 1:img_num %��һ��ȡͼ��  
image_name = img_path_list(j).name;% ͼ����  
image =  imread(strcat(file_path,image_name));
data=rgb2gray(image);
P{j}=data;
end
end
%--------------------------------------------------------------------------