function [d1vec,d2vec,xvec,yvec] = radardetect(r1vec,r2vec,sigvec)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
r1vec = r1vec(:);
r2vec = r2vec(:);
sigvec = sigvec(:);
L = length(sigvec);


Fs =5e6;
D = 3840;
T =4.096e-4;
N = length(r1vec)/(T*Fs);
r1vec =reshape(r1vec, [T*Fs, N]);
r2vec =reshape(r2vec, [T*Fs, N]);
d1vec = zeros(N,1);
d2vec = zeros(N,1);
xvec = zeros(N,1);
yvec = zeros(N,1);

for i = 1:N
    matchedfiltcoeffs = sigvec(end:-1:1);

    filtoutR1vec = filter(matchedfiltcoeffs,1,r1vec(:, i));
    [MaxVal1,IndexR1vec] = max(filtoutR1vec); 
    IndexR1vec = IndexR1vec - L;
    d1vec(i) = IndexR1vec; 

    filtoutR2vec = filter(matchedfiltcoeffs,1,r2vec(:, i));
    [MaxVal2,IndexR2vec] = max(filtoutR2vec); 
    IndexR2vec = IndexR2vec - L;
    d2vec(i) = IndexR2vec; 
end

c =3e8;
d1 = zeros(N,1);
d2 = zeros(N,1);
for i =1:N
    d1(i) = d1vec(i)*(1/Fs)*c;
    d2(i) = d2vec(i)*(1/Fs)*c;
    
    A = 0.25*d1(i)^2;
    B = (d2(i) -0.5*d1(i))^2;
    
    xvec(i) = (A-B)/(2*D)+0.5*D;
    yvec(i) = sqrt(A - xvec(i)^2); 
end


figure
plot(xvec, yvec)
hold on
plot(xvec, yvec, '.')
title("Estimated path of the airplane")
xlabel("[m]")
ylabel("[m]")
hold off





end
