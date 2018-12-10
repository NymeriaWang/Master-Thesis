function [D, R, P, C, B] = CH(X, nbit, lambda, spi)
rand('state', sum(100*clock));
n_iter = 50;

[n m] = size(X);

d1 = sum(X,1);
[idx jdx vv] = find(d1);
d1 = sparse(idx, jdx, 1./sqrt(vv));
D{1} = d1;


d2 = sum(X,2)';
[idx jdx vv] = find(d2);
d2 = sparse(idx, jdx, 1./sqrt(vv));
D{2} = d2;

Uh = (bsxfun(@times, X, d1));%speedup
C{1} = mean(Uh);
Uh = full(bsxfun(@minus, Uh, C{1}))';

Ug = (bsxfun(@times, X, d2'));
C{2} = mean(Ug');
Ug = full(bsxfun(@minus, Ug', C{2}))';


%% init P
% [P{1}, l, ~] = svds(Uh, nbit);
% [P{2}, l, ~] = svds(Ug, nbit);  
if(n > m)
    [P{1}, l] = eigs(Uh*Uh', nbit); 
    
    [P{2}, l] = eigs(Ug'*Ug, nbit);%speedup by AA^Tv = \lambda v
    P{2} = normc(Ug*P{2});

else
    [P{1}, l] = eigs(Uh'*Uh, nbit);%speedup by AA^Tv = \lambda v
    P{1} = normc(Uh*P{1});
    
    [P{2}, l] = eigs(Ug*Ug', nbit);
end
Uh = P{1}'*Uh;
Ug = P{2}'*Ug;

if(nargin > 3)
    nz_idx = find(X(:)>0);
else
    nz_idx = [1:n*m]';
end
b = X(nz_idx);

nz = length(nz_idx);
%% init R

R{1} = eye(nbit);
R{2} = eye(nbit);
B{1} = sign(double(R{1}*Uh>=0) - 0.5);
B{2} = sign(double(R{2}*Ug>=0) - 0.5);

% CH to find optimal rotation
for iter=0:n_iter   
        
    %update S
    M = 1 + (1/nbit)*reshape(B{1}'*B{2}, n*m, 1);
    M = M(nz_idx)/2;
    sv = (M'*b)/(M'*M); 
    S_hat = eye(nbit)*(sv/(2*nbit));     

    % updata B1
    Q = (1/(n*nbit))*R{1}*Uh+(lambda/(nz))*S_hat*B{2}*(X'-sv/2);%*nbit
    [U sigma V] = svds(Q,nbit);
    B{1} = sign(double(U*V'>=0) - 0.5);
        
    % updata B2
    Q = (1/(m*nbit))*R{2}*Ug+(lambda/(nz))*S_hat*B{1}*(X-sv/2);%*nbit
    [U sigma V] = svds(Q,nbit);
    B{2} = sign(double(U*V'>=0) - 0.5);    
    
    % show objective value
    obj1 = (1/(n*nbit))*norm(B{1}-R{1}*Uh,'fro')^2;
    obj2 = (1/(m*nbit))*norm(B{2}-R{2}*Ug,'fro')^2;
    obj3 = (lambda/(nz))*norm(M*sv-b)^2;
    obj(iter+1) = obj1+obj2+obj3;
%     fprintf('%d iter, %f, obj = %f,\t%f,\t%f,\t%f\n', iter, sv, obj1, obj2, obj3, obj(iter+1));
    
    if(iter > 1 && obj(iter+1) > obj(iter))
        break;
    end
    
    %update R1
    [U sigma V] = svd(B{1}*Uh');
    R{1} = U*V'; 
    
    %update R2
    [U sigma V] = svd(B{2}*Ug');
    R{2} = U*V';

end

D{3} = sv;

