function znext = adaptivepredict(zvec)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
L=5;
delta=1e-9;
lambda = 0.5;


wRls = zeros(L,1);
P = (1/delta)*eye(L);
error = zeros(length(zvec),1);
estEr = zeros(length(zvec),1);


for n = L:(length(zvec)-1)
    
    U = zvec(n: -1:n-L+1);
    dhat = wRls'*U;
    
    error(n+1) = zvec(n + 1) - dhat;
    

     k = ((1/lambda).*P*U)./(1+(1/lambda).*U'*P*U);
     wRls =wRls + k.*error(n+1);
     P = (1/lambda).*P-(1/lambda).*k*U'*P;
    
end
NR = 10*log10(sum(zvec.^2)./sum(estEr.^2)); 
Un = zvec(length(zvec): -1:length(zvec)-L+1);
znext = wRls'*Un;


end
