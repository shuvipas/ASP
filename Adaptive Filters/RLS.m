function [reEr, NR] = RLS(L,lambda, delta,Z,w)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
wRls = zeros(L,1);
P = (1/delta)*eye(L);
error = zeros(length(Z),1);

reEr = zeros(length(Z),1);

for n = L:(length(Z)-1)
    
    U = Z(n: -1:n-L+1);
    dhat = wRls'*U;
    
    error(n+1) = Z(n + 1) - dhat;
    

     k = ((1/lambda).*P*U)./(1+(1/lambda).*U'*P*U);
     wRls =wRls + k.*error(n+1);
     P = (1/lambda).*P-(1/lambda).*k*U'*P;
    
    reEr(n) = 10*log10(((norm(wRls -w))^2)/(norm(w)^2));
    

end
NR = 10*log10(sum(Z.^2)./sum(error.^2)); 
