
close all
clear all


Fs = 48e3;
n = 10*Fs;
alfa = 0.5;
G = randn(n, 1);
b = 1;
a1 = [1, -alfa];
X = filter(b, a1, G);
N = randn(n, 1);
Z = X + N;


empMeanZ = 1/n*sum(Z);
empVarZ = 1/n*sum(Z.^2);

scaledZ = sqrt(3/14).*Z;
%sound(scaledZ, Fs);

alfa2 = 0.9;
N2 = randn(n, 1);
N2 = sqrt(1/2).*N2;
G2 = randn(n, 1);
b2 = 1;
a2 = [1, -alfa2];
X2 = filter(b2, a2, G2);
Z2 = X2 + N2;

RVec = {0, [0 0], [0 0 0], [0 0 0 0], [0 0 0 0 0]};
p = {0, [0 0], [0 0 0], [0 0 0 0], [0 0 0 0 0]};
R= {};
w = {};
for L = 1:5
    
   for i = 1:L 
    if i == 1
        RVec{L}(i) = alfa2^(i-1)/(1-alfa2^2) + 0.5;
    else
        RVec{L}(i) = alfa2^(i-1)/(1-alfa2^2);
    end
    p{L}(i) = alfa2^(i)/(1-alfa2^2);
   end
    R{end+1} = toeplitz(RVec{L});
    w{end+1} = (inv(R{L}))*p{L}';
end
 
Zhat = [] ;
for i = 1:5
    b = [0; w{i}];
    Zhat{end+1} = filter(b,1,Z2);   
end

er = {};
for L =1:5
    er{end+1} = Z2 - Zhat{L};
end

scaledZ2 = sqrt(19/219).*Z2;
%sound(scaledZ2, Fs);

scaleder = {};
for L =1:5
   scaleder{end+1} = sqrt(19/219)*er{L};
end
%sound(scaleder{5}, Fs);


avgEr = {};
for L = 1:5
    avgEr{end+1} = (1/n)*sum(er{L}.^2); 

end


NR = {};
sumz2 = sum(Z2.^2); 
for L = 1:5
    NR{end+1} = 10*log10(sumz2/n.*avgEr{L});

end


% Question 2
%{
eigenR = eigs(R{4});
mu = [0.001 0.01 0.1 0.2];
erNorm = {zeros(100, 1) zeros(100, 1) zeros(100, 1) zeros(100, 1)};
for i = 1:4
    w_gd = [0; 0; 0; 0];
    for j = 1:100
        erNorm{i}(j) = norm(w_gd - w{4});
        delta = mu(i)*(p{4}'-R{4}*w_gd);
        w_gd = w_gd + delta;
    end
end        

x_ax = linspace(0, 99);
reEr = {zeros(100, 1) zeros(100, 1) zeros(100, 1) zeros(100, 1)};
normW = norm(w{4});
for i = 1:4
    for j = 1:100
        reEr{i}(j) = 10*log10(erNorm{i}(j)^2/normW^2);
    endFs
end
%normFactor = 20/max(reEr{4});
figure;
plot(x_ax, reEr{1}, 'r')
hold on
plot(x_ax, reEr{2}, 'b')
plot(x_ax, reEr{3}, 'g')
plot(x_ax, reEr{4}, 'm')
ylim([-40 20]);
hold off

%}

%Question 3 
%{
filterOrder = [1 2 4];
mu = [1e-2 1e-3 1e-4];

noiseReduction = {[0 0 0], [0 0 0], [0 0 0]};%L =i [1e-2 1e-3 1e-4]
relitiveError= {{zeros(n,1), zeros(n,1), zeros(n,1)},{zeros(n,1), zeros(n,1), zeros(n,1)},{zeros(n,1), zeros(n,1), zeros(n,1)}};
for u = 1:3
    for l =1:3
        [relitiveError{l}{u}, noiseReduction{l}(u)] = LMS(filterOrder(l),mu(u),Z2,w{filterOrder(l)});
        figure
        plot(relitiveError{l}{u})
        ylim([-10 20])
        str = sprintf("filter Order: L = %d,  mu = %d noise reduction = %f",filterOrder(l),mu(u),noiseReduction{l}(u) ); 
        title(str)

    end
end
%}

%Question 4
%{
L=2;
lambda = 0.99;
delta = [1e-4 1e-3 1e-2 1e-1];% need to do on more delta values

for d =1:4
    %[reEr, NR] = RLS(L,lambda, delta,Z,w)
    [reEr, NR] =  RLS(L,lambda, delta(d),Z2,w{2});
    figure
    plot(reEr)
     str = sprintf("relative coefficient error: delta = %g, NR =  %g", delta(d), NR);
     title(str)

end
%}

%Question 5

%[city,Fs] = audioread('city.wav');
%[airplane,Fs] = audioread('airplane.wav');
%[cafe,Fs] = audioread('cafe.wav');
%[vacuumcleaner,Fs] = audioread('vacuumcleaner.wav');

%LMSv2(L,mu,Z, name)
L5 = 5;
mu = 0.1;

%LMSv2(L5, mu ,city, "city.wav")
%LMSv2(L5, mu ,airplane, "airplane.wav")
%LMSv2(L5, mu ,cafe, "cafe.wav")
%LMSv2(L5, mu ,vacuumcleaner, "vacuumcleaner.wav")





% RLSv2(L,lambda, delta,Z, name)

lambda5 = 0.99;
delta5 = 1e-4;


%RLSv2(L5,lambda5, delta5, city, "city.wav")
%RLSv2(L5,lambda5, delta5, airplane, "airplane.wav")
%RLSv2(L5,lambda5, delta5, cafe, "cafe.wav")
%RLSv2(L5,lambda5, delta5, vacuumcleaner, "vacuumcleaner.wav")



%Q6
znext = adaptivepredict(Z2(1:length(Z2)-1));







