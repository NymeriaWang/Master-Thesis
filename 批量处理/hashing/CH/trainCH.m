function CHparam = trainCH(U, CHparam)

nbits = CHparam.nbits;
lambda = CHparam.lambda;

if(isfield(CHparam, 'sparse'))
    [D, R, P, C, B] = CH(U, nbits, lambda, 'sparse');
else
    [D, R, P, C, B] = CH(U, nbits, lambda);
end

CHparam.pc = P;
CHparam.R = R;
CHparam.C = C;       
CHparam.D = D; 
CHparam.B = B; 