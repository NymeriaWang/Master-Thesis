function evaluation_info = rateCH(data, param)
for j=1:data.count;
tic;
param = trainCH(data.train_data{j}', param);
trainT=toc;

B_u = param.B{1};
B_i = param.B{2};

evaluation_info.B1{j} = B_u
evaluation_info.B2{j}= B_i

B_u = compactbit(B_u'>=0);
B_i = compactbit(B_i'>=0);

%groundtruth = data.groundtruth{1};

evaluation_info.U{j} = B_u
evaluation_info.I{j} = B_i
evaluation_info.trainT{j} = trainT;
end
