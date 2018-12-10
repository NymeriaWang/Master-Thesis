%function [comp_image_Y,comp_image_U,comp_image_V] = Compress(orig_image)
%Jpeg compression


% Compress ratio setting 
Cratio=inputdlg('Type number to decide the compression ratio');
input=str2double(cell2mat(Cratio));

file_path = '.\image\';

orig_image =  imread(strcat(file_path,'fengjing.jpg'));


RGB=orig_image;
%下面是对 RGB 三个分量进行分离 
R=RGB(:,:,1);
G=RGB(:,:,2);
B=RGB(:,:,3);

%RGB->YUV 
Y=0.299*double(R)+0.587*double(G) +0.114*double(B); 
[xm, xn] = size(Y);             
U=-0.169*double(R)-0.3316*double(G)+0.5*double(B);  
V=0.5*double(R)-0.4186*double(G)-0.0813*double(B);

%产生一个 8*8 的 DCT 变换举证 
T=dctmtx(8);

%进行 DCT 变换 BY BU BV 是 double 类型
BY=blkproc(Y,[8 8],'P1*x*P2',T,T'); 
BU=blkproc(U,[8 8],'P1*x*P2',T,T'); 
BV=blkproc(V,[8 8],'P1*x*P2',T,T'); 

%可变低频分量量化表
for i=1:1:8
    for j=1:1:8
        a(i,j)=1+input*(i+j-1);
    end
end


%  %低频分量量化表
% a=[
% 16 11 10 16 24 40 51 61;
% 12 12 14 19 26 58 60 55;
% 14 13 16 24 40 57 69 55;
% 14 17 22 29 51 87 80 62;
% 18 22 37 56 68 109 103 77; 
% 24 35 55 64 81 104 113 92;                      
% 49  64 78 87 103 121 120 101;                   
% 72 92 95 98 112 100 103 99;
% ]; 

%高频分量量化表
b=[17 18 24 47 99 99 99 99; 
18 21 26 66 99 99 99 99; 
24 26 56 99 99 99 99 99; 
47 66 99 99 99 99 99 99; 
99 99 99 99 99 99 99 99; 
99 99 99 99 99 99 99 99; 
99 99 99 99 99  99 99 99; 
99 99 99 99 99 99 99 99;];

%使用量化表对三个分量进行量化 
BY2=blkproc(BY,[8 8],'round(x./P1)',a); 
BU2=blkproc(BU,[8 8],'round(x./ P1)',b); 
BV2=blkproc(BV,[8 8],'round(x./P1)',b);

%调用压缩函数 
comp_image_Y=img2jpg(BY2,1);        
%comp_image_U=img2jpg(BU2,2);                    
%comp_image_V=img2jpg(BV2,3);



y=comp_image_Y;
for i=1:1:8
    for j=1:1:8
        a(i,j)=1+input*(i+j-1);
    end
end

%高频分量量化表    
b=[17 18 24 47 99 99 99 99;  
 18 21 26 66 99 99 99 99;  
 24 26 56 99 99 99 99 99;  
 47 66 99 99 99 99 99 99;  
 99 99 99 99 99 99 99 99;  
 99 99 99 99 99 99 99 99;  
 99 99 99 99 99 99 99 99;  
 99 99 99 99 99 99 99 99;]; 

order = [1 9  2  3  10 17 25 18 11 4  5  12 19 26 33  ...
    41 34 27 20 13 6  7  14 21 28 35 42 49 57 50  ...
    43 36 29 22 15 8  16 23 30 37 44 51 58 59 52  ...
    45 38 31 24 32 39 46 53 60 61 54 47 40 48 55  ...
    62 63 56 64];
rev = order;                          % 计算反序
for k = 1:length(order)
    rev(k) = find(order == k);
end

xb = (y.numblocks);             % 块的个数
sz = double(y.size);
xn = sz(2);                           % 列数
xm = sz(1);                           % 行数
x = y.r;                              % 压缩后的数据
eob = max(x(:));                      % 返回块尾标志

z = zeros(64, xb);   k = 1;           % 生成 64 * xb 的零矩阵
for j = 1:xb                          % x中的值放入z中，如果遇到eob就转入下一列
    for i = 1:64                       
        if x(k) == eob                  
            k = k + 1;   
            break;          
        else
            z(i, j) = x(k);
            k = k + 1;
        end
    end
end
T=dctmtx(8);                                   %产生一个8*8的DCT变换举证  
z = z(rev, :);                                 % 按order恢复之前排列
x = col2im(z, [8 8], [xm xn], 'distinct');     % 生成矩阵
if y.flag==1
    x = blkproc(x, [8 8], 'x .* P1', a);       % 反量化，乘量化表的值
else
    x = blkproc(x, [8 8], 'x .* P1', b);
end
x = blkproc(x, [8 8], 'P1 * x * P2', T', T);   % 反DCT变换

imshow(x,[0,255]);

   size_rcv=size(x)
   number_rcv=size_rcv(1)*size_rcv(2)
   plus=0;
   for g=1:number_rcv
       plus=plus+(x(g)-Y(g))^2
   end
   MSE=plus/(number_rcv)
   PSNR=10*log10(((2^8-1)^2)/MSE)
   W=number_rcv/comp_image_Y.realsize


%end
%end

