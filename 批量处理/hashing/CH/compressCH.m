function [B, U] = compressCH(X, CHparam, opt)

X = single(full(bsxfun(@times, X, CHparam.D{opt})));
X = single(full(X));
sampleMean = single(full(CHparam.C{opt}));
X = X - repmat(sampleMean, size(X,1), 1);

X = X * CHparam.pc{opt};
R = CHparam.R{opt};
X = X*R';
U = X >= 0;
B = compactbit(U);
