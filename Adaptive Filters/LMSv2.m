
function [] = LMSv2(L,mu,Z, name)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

w_lms = zeros(L, 1);
Zhat = zeros(length(Z), 1);
estEr = zeros(length(Z), 1);

M = 10e3;

PSignal = movvar(Z, M); 
for n = L+1:length(Z)

    U = Z(n -1: -1:n-L);
    Zhat(n) =  w_lms'*U;
   
    estEr(n) =Z(n)- Zhat(n);
        w_lms = w_lms + mu*estEr(n)*U;
end    
  NR = 10*log10(sum(Z.^2)/sum(estEr.^2));

  
NR = 10*log10(sum(Z.^2)/sum(estEr.^2));

PError =movvar(estEr, M); 


dbpsig = 10*log10(PSignal);
dbper= 10*log10(PError);
figure
plot(dbpsig)
hold on
plot(dbper)
str = sprintf("%s LMS: L= %d, mu = %f \nnoise reduction = %fdB ",name, L,mu,NR);
title(str)
xlabel("sample number")
ylabel("instantaneous power [dB]")
legend("original noise power", "predection error power")
hold off

end