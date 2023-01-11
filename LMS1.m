function [reEr,NR] = LMS1(L,mu,Z,w)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
w_lms = zeros(L, 1);
Zhat = zeros(length(Z), 1);
reEr = zeros(length(Z), 1);
estEr = zeros(length(Z), 1);
normW = norm(w);

for n = L+1:length(Z)
	U = Z(n -1: -1:n-L);
    Zhat(n) =  w_lms'*U;
    estEr(n) = Z(n)- Zhat(n);
    c = w_lms - w;
    reEr(n) = 10*log10(((norm(c))^2)/(normW^2));
    w_lms = w_lms + mu*estEr(n)*U;  
end    
  
NR = 10*log10(sum(Z.^2)/sum(estEr.^2));

end
