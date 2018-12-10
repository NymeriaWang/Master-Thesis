addpath(genpath('./hashing'));%��hashing����ļ��к�����������ļ�LCH,CH��ӵ�MATLAB����·�������
addpath('./tool');%��tool�ļ���ӵ�����·�������
nbits = 96;%     ��Щ�����ؼ����ؾ��ǹ�ϣ����ĳ��ȣ�����������ϣ���볤��Խ�����ô���ͼƬ�ļ���׼ȷ�ʾ�Խ�ߡ�

M = [1 5 10 20 50 100 200 500 1000:1000:3000];%M=1 5 10 20 50 100 200 500 1000 2000 3000

exp_data = construct_ME();%Ӧ��construct_dataset-movielen�����Ľ��Ϊexp_data,ʵ������.
for j=1:exp_data.count
pos{j} = [M size(exp_data.groundtruth{j}, 2)];%groundtruth����ԭʼ�������Ԥ����ľ�������������Ƚϣ�pos=[M exp_data.groundtruth��������item��,2]
    CHparam.pos{j} = pos{j};
end
    CHparam.nbits = nbits;%CHparam.nbits��ֵ�ֱ�ȡ16 32 64
    CHparam.lambda = 1e0;%3/(nbits(i)/16);%�����Ц��ǹ���ĺ���E=Equan+��Erate�еĹ̶�Ȩֵ����������Ϊ1
    CHparam.sparse = 0;
    CH_eva_info= rateCH(exp_data, CHparam);%rateCH��һ������ 
 for j=1:exp_data.count
    CH_eva_info.B1{j}
    CH_eva_info.B2{j}
    CH_eva_info.U{j}
    CH_eva_info.I{j}
    CH_eva_info.trainT{j}
    
    rcv=CH_eva_info.B2{j}'*CH_eva_info.B1{j}
    x=1/(2*nbits)   
    %rcv=(rcv*x+0.5)*255
    rcv=rcv*x+0.5 
    rcv=double(rcv)
    rcv=floor(unitba(rcv))
    result=rcv

    [row1, column1]=size(CH_eva_info.B2{j});
    T1=row1*column1;
    [row2, column2]=size(CH_eva_info.B1{j});
    T2=row2*column2;
    T=T1+T2;
    [row, column]=size(exp_data.train_data{j});
    U=row*column*8;
    w(j)=U/T;
    
   s=find(rcv<105)
   rcv(s)=0;
   s=find(rcv>175)
   rcv(s)=255
    
   figure(2*j)
   imshow(rcv,[0,255]);
   title('��ֵ100')

   size_rcv=size(rcv)
   number_rcv=size_rcv(1)*size_rcv(2)
   plus=0;
   for g=1:number_rcv
       plus=plus+(rcv(g)-exp_data.train_data{j}(g))^2
   end
   MSE{j}=plus/(number_rcv)
   PSNR{j}=10*log10(((2^8-1)^2)/MSE{j})
   
 end
 
 figure(2*exp_data.count+1)
 plot(w);
 title('compression ratio');
