function [p, r, ap, ph2] = precall2(score,truth, M)

%%% number of true samples
num_truesamples=length(truth);
%%% number of samples
numds=length(score);

%%% score is the computed hamming distance
[sorted_val, sorted_ind]=sort(score); 
sorted_truefalse=ismember(sorted_ind, truth);
 
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