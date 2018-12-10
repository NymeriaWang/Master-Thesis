function evaluation_info = rateCH(data, param)

tic;
param = trainCH(data.train_data', param);
trainT=toc;

B_u = param.B{1};
B_i = param.B{2};

evaluation_info.B1 = B_u
evaluation_info.B2 = B_i

B_u = compactbit(B_u'>=0);
B_i = compactbit(B_i'>=0);

groundtruth = data.groundtruth{1};

evaluation_info.U = B_u
evaluation_info.I = B_i
evaluation_info.trainT = trainT;