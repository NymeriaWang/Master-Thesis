function evaluation_info = evaluateCH(data, param)

tic;
param = trainCH(data.train_data', param);
trainT=toc;

%dim 1
for i = 1:data.ndim
   
    if(i == 1)     
        dbdata = data.db_data;
    else      
        dbdata = data.db_data';
    end
    
    [B_db, U] = compressCH(dbdata', param, i);
    if(isfield(data, 'groundtruth'))
        tstdata = data.test_data{i};
        groundtruth = data.groundtruth{i};

        tic;
        [B_tst, U] = compressCH(tstdata', param, i);
    
        compressT=toc;
        
        evaluation_info = performance(B_tst, B_db, groundtruth, param);
        evaluation_info.trainT = trainT;
        evaluation_info.compressT = compressT;
    else
        D_dist =  -hammingDist(B_db,B_db);
        evaluation_info.AP = compute_avg_top(D_dist);
    end
end