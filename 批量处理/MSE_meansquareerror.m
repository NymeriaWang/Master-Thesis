
for j=1:1
    rcv=CH_eva_info.B2{j}'*CH_eva_info.B1{j}
    x=1/(2*nbits)   
    %rcv=(rcv*x+0.5)*255
    rcv=rcv*x+0.5 
    rcv=double(rcv)
    rcv=floor(unitba(rcv))
    
   s=find(rcv<50)
   rcv(s)=0;
   s=find(rcv>200)
   rcv(s)=255
   
   size_rcv=size(rcv)
   number_rcv=size_rcv(1)*size_rcv(2)
   plus=0;
   for g=1:number_rcv
       plus=plus+(rcv(g)-exp_data.train_data{j}(g))^2
   end
   MSE{j}=plus/(number_rcv)
   PSNR{j}=10*log10(((2^8-1)^2)/MSE{j})
   end