function evaluation_info = performance_rate(B_tst, B_db, groundtruth, param)

test_num = size(B_tst, 1);
pos = param.pos;
poslen = length(pos);
label_r = zeros(1, poslen);
label_p = zeros(1, poslen);
label_ap = zeros(1, 1);
label_ph2 = zeros(1, 1);
label_ndcg = zeros(1, 1);
% W_truth = zeros(length(B_tst), length(B_db));
D_dist =  hammingDist(B_tst,B_db);
for n = 1:test_num
    % compute your distance
    D_code = D_dist(n,:);%hammingDist(B_tst(n,:),B_db);
    D_truth = groundtruth(n,:);%find(groundtruth(n,:)>0);%ground truth
     
    [P, R, AP, PH2, NDCG] = precall_rate(D_code, D_truth, pos);

    label_r = label_r + R(1:poslen);
    label_p = label_p + P(1:poslen);
    label_ap = label_ap + AP;
    label_ph2 = label_ph2 + PH2;
    label_ndcg = label_ndcg + NDCG;
%     W_truth(n,D_truth) = 1;
end
[r p]= recall_precision(groundtruth>4, D_dist, param.nbits);

evaluation_info.hrecall = r;
evaluation_info.hprecision = p;
evaluation_info.recall=label_r/test_num;
evaluation_info.precision=label_p/test_num;
evaluation_info.ndcg=label_ndcg/test_num;
evaluation_info.AP=label_ap/test_num;
evaluation_info.PH2=label_ph2/test_num;
% evaluation_info.param=param;