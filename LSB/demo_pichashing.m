addpath(genpath('./hashing'));%��hashing����ļ��к�����������ļ�LCH,CH��ӵ�MATLAB����·�������
addpath('./tool');%��tool�ļ���ӵ�����·�������
nbits =128;%     ��Щ�����ؼ����ؾ��ǹ�ϣ����ĳ��ȣ�����������ϣ���볤��Խ�����ô���ͼƬ�ļ���׼ȷ�ʾ�Խ�ߡ�

M = [1 5 10 20 50 100 200 500 1000:1000:3000];%M=1 5 10 20 50 100 200 500 1000 2000 3000

exp_data = construct_lena();%Ӧ��construct_dataset-movielen�����Ľ��Ϊexp_data,ʵ������.

pos = [M size(exp_data.groundtruth, 2)];%groundtruth����ԭʼ�������Ԥ����ľ�������������Ƚϣ�pos=[M exp_data.groundtruth��������item��,2]
n=1;
 CHparam.nbits = nbits;%CHparam.nbits��ֵ�ֱ�ȡ16 32 64
    CHparam.pos = pos;
    CHparam.lambda = 1e0;%3/(nbits(i)/16);%�����Ц��ǹ���ĺ���E=Equan+��Erate�еĹ̶�Ȩֵ����������Ϊ1
    CHparam.sparse = 0;
    CH_eva_info= rateCH(exp_data, CHparam);%rateCH��һ������ 
 
    CH_eva_info.B1
    CH_eva_info.B2
    CH_eva_info.U
    CH_eva_info.I
    CH_eva_info.trainT
    filename='secret.txt'
    hidehash(filename,CH_eva_info.B1, CH_eva_info.B2);
    
    jnt=CH_eva_info.B2'*CH_eva_info.B1
    x=1/(2*nbits)
    rcv=jnt*x+0.5
    rcv=unitba(rcv)%change the pixel to uint8 type
    why=rcv
    
    [row1, column1]=size(CH_eva_info.B2);
    T1=row1*column1;
    [row2, column2]=size(CH_eva_info.B1);
    T2=row2*column2;
    T=T1+T2;
    [row, column]=size(exp_data.train_data);
    U=row*column*8;
    w=U/T;               %calculate the compression ratio


    rcv=why
    s=find(rcv>200)
    rcv(s)=228;    
    s=find(rcv>110&rcv<200)
    rcv(s)=150;
    s=find(rcv<110)
    rcv(s)=50; 
    
%        size_rcv=size(rcv)
%    number_rcv=size_rcv(1)*size_rcv(2)
%    plus=0;
%    for g=1:number_rcv
%        plus=plus+(rcv(g)-exp_data.train_data(g))^2
%    end
%    MSE=plus/(number_rcv)
%    PSNR=10*log10(((2^8-1)^2)/MSE)
%     
  figure(4)
  imshow(rcv,[0,255]);
  title('threshold:110') 
  
  
    
    
    

 