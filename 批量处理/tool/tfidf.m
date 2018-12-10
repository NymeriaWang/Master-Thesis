function [fea idf] = tfidf(fea, idf)
%  fea is a document-term frequency matrix, this function return the tfidf ([1+log(tf)]*log[N/df])
%  weighted document-term matrix.
%    

[nSmp,mFea] = size(fea);
[idx,jdx,vv] = find(fea);

if(nargin < 2)
    df = full(sum(sparse(idx,jdx,1),1));

    df(df==0) = 1;
    idf = log(nSmp./df);
    idf = idf';
end

tffea = sparse(idx,jdx,log(vv)+1);

fea2 = tffea';

MAX_MATRIX_SIZE = 20000; % You can change this number based on your memory.
nBlock = ceil(MAX_MATRIX_SIZE*MAX_MATRIX_SIZE/mFea);
for i = 1:ceil(nSmp/nBlock)
    if i == ceil(nSmp/nBlock)
        smpIdx = (i-1)*nBlock+1:nSmp;
    else
        smpIdx = (i-1)*nBlock+1:i*nBlock;
    end
    fea2(:,smpIdx) = fea2(:,smpIdx) .* idf(:,ones(1,length(smpIdx)));
end

fea = (fea2);% normc
% %Now each column of fea2 is the tf-idf vector.
% %One can further normalize each vector to unit by using following codes:
% 
% if bNorm
%    fea = NormalizeFea(fea2,0)'; 
% end

% fea is the final document-term matrix.