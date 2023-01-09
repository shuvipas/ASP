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

%R = zeros([5 5]);
RVec = {0, [0 0], [0 0 0], [0 0 0 0], [0 0 0 0 0]};
p = {0, [0 0], [0 0 0], [0 0 0 0], [0 0 0 0 0]};
R= {};
w = {};
for L = 1:5
   for i = 1:L 
    %R(L, i) = alfa2^(i-1)/(1-alfa2^2);
    if i == 1
        RVec{L}(i) = alfa2^(i-1)/(1-alfa2^2) + 0.5;
    else
        RVec{L}(i) = alfa2^(i-1)/(1-alfa2^2);
    end
    %p(L, i) = alfa2^(i)/(1-alfa2^2);
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
    end
end
%normFactor = 20/max(reEr{4});
figure;
plot(x_ax, reEr{1}, 'r')
hold on
plot(x_ax, reEr{2}, 'b')
plot(x_ax, reEr{3}, 'g')
plot(x_ax, reEr{4}, 'm')
ylim([-40 20]);
%Question 3
filterOrder = [1 2 4];
mu = [1e-2 1e-3 1e-4];

%noiseRed = zeros(3,3);
%relativeError = [zeros(n, 3) zeros(n, 3) zeros(n, 3)];
%for i = 1:3
 %   for j = 1:3
  %      [relativeError(:,((i-1)*3+j)), noiseRed(i,j)] = LMS(filterOrder(i),mu(j),Z2,w{filterOrder(i)});
   % end
%end

[RE_ERROR, NO_REDUCTION] = LMS(2,0.0001,Z2,w{2});
   
        
        
