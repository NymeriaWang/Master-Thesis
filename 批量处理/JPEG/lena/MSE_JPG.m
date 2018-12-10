   size_rcv=size(x)
   number_rcv=size_rcv(1)*size_rcv(2)
   plus=0;
   for g=1:number_rcv
       plus=plus+(x(g)-Y(g))^2
   end
   MSE=plus/(number_rcv)
   PSNR=10*log10(((2^8-1)^2)/MSE)
   W=number_rcv/comp_image_Y.realsize