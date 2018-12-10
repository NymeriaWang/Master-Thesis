function [recall, precision, rate] = recall_precision(Wtrue, Dhat,  max_hamm)
%
% Input:
%    Wtrue = true neighbors [Ntest * Ndataset], can be a full matrix NxN
%    Dhat  = estimated distances
%
% Output:
%
%                  exp. # of good pairs inside hamming ball of radius <= (n-1)
%  precision(n) = --------------------------------------------------------------
%                  exp. # of total pairs inside hamming ball of radius <= (n-1)
%
%               exp. # of good pairs inside hamming ball of radius <= (n-1)
%  recall(n) = --------------------------------------------------------------
%                          exp. # of total good pairs

if(nargin < 3)
    max_hamm = max(Dhat(:));
end
hamm_thresh = min(3,max_hamm);

[Ntest, Ntrain] = size(Wtrue);
total_good_pairs = sum(Wtrue(:));


[v ord] = sort(Dhat(:));
[u ind] = unique(v, 'first');
count = [ind(2:end); Ntest*Ntrain+1] - ind;
hist = zeros(max_hamm+1, 1);
hist(u+1) = count;
cumhist = [1; 1+cumsum(hist)];

% find pairs with similar codes
precision = zeros(max_hamm+1,1);
recall = zeros(max_hamm+1,1);
retrieved_pairs = 0;
retrieved_good_pairs = 0;

for n = 1:length(precision)  
    %exp. # of pairs that have small code
    retrieved_pairs = retrieved_pairs + hist(n);
    
    %exp. # of good pairs that have exactly the same code
    retrieved_good_pairs = retrieved_good_pairs + sum(Wtrue(ord(cumhist(n):cumhist(n+1)-1))==1);
    
    precision(n) = retrieved_good_pairs/retrieved_pairs;
    recall(n)= retrieved_good_pairs/total_good_pairs;    
end

