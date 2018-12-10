
[Ix,Iy]=size(exp_data.data2);
 for i=1:1:Iy
 hold on
 X=1:1:Ix;
 Y=exp_data.data2(:,i);
 figure(1)
 scatter(X,Y);
 end
 
