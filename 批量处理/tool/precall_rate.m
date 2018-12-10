function [p, r, ap, ph2, ndcg] = precall_rate(score,rate, M)

%%% number of true samples
truth = find(rate>4);
num_truesamples=length(truth);
%%% number of samples
numds=length(score);

%%% score is the computed hamming distance
[sorted_val, sorted_ind]=sort(score); 
sorted_truefalse=ismember(sorted_ind, truth);
rate_truefalse = rate(sorted_ind);
[sorted_rate, ~] = sort(rate, 'descend');

Hamm_M = M;   
truepositive=cumsum(sorted_truefalse);

% hd2_ind=find(score<=2);%hamming distance < 2
% if isempty(hd2_ind)
%     ph2=0;
% else
%     ph2=sum(ismember((hd2_ind), truth))/length(hd2_ind);
% end

hd2_ind=find(sorted_val<=2, 1, 'last');%score<=2);%hamming distance < 2
if isempty(hd2_ind)
    ph2 = 0;
else
    ph2 = truepositive(hd2_ind)/hd2_ind;
end

r=truepositive(Hamm_M)/num_truesamples;
p=truepositive(Hamm_M)./(Hamm_M);%[1:numds];
ap = apcal2(score,truth);

discount = zeros(1, numds);
discount(1) = 1;
ndcg = zeros(1, length(Hamm_M));
rel = (2.^rate_truefalse-1)./log2(2:Hamm_M(end)+1);
idcg = (2.^sorted_rate-1)./log2(2:Hamm_M(end)+1);
for i = 1:length(Hamm_M)
    m = Hamm_M(i);
    %discount(1:m) = rel(1:m)./log2(2:m+1);
    %discount = discount / sum(discount);
    ndcg(i) = sum(rel(1:m))/sum(idcg(1:m));%discount * sorted_truefalse'; 
end


