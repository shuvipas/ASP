function znext = adaptivepredict(zvec)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
L = 4;
delta = 1e-6;
lambda = zeros(length(zvec), 1);
lambda(1) = 0.95;
for n = 2:length(lambda)
    lambda(n) = 0.99*lambda(n-1)+(1-0.99);
end
wRls = zeros(L,1);
P = (1/delta)*eye(L);
error = zeros(length(zvec),1);

for n = L:(length(zvec)-1)
    
     U = zvec(n: -1:n-L+1);
     dhat = wRls'*U;
     error(n+1) = zvec(n + 1) - dhat;
     k = ((1/lambda(n)).*P*U)./(1+(1/lambda(n)).*U'*P*U);
     wRls = wRls + k.*error(n+1);
     P = (1/lambda(n)).*P-(1/lambda(n)).*k*U'*P;
    
end

Un = zvec(length(zvec): -1:length(zvec)-L+1);
znext = wRls'*Un;

end
