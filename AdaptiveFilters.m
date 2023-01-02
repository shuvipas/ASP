Fs = 48e3;
n =10*Fs;
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
N2 = (1/4).*N2;
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
    RVec{L}(i) = alfa2^(i-1)/(1-alfa2^2);
    %p(L, i) = alfa2^(i)/(1-alfa2^2);
    p{L}(i) = alfa2^(i)/(1-alfa2^2);
   end
    R{end+1} = toeplitz(RVec{L});
    w{end +1} = (inv(R{L}))*p{L}';
end

%R1 = toeplitz(RVec(1, 1));
%R2 = toeplitz(RVec(2, 1:2));
%R3 = toeplitz(RVec(3, 1:3));
%R4 = toeplitz(RVec(4, 1:4));
%R5 = toeplitz(RVec(5, :));
%p1 = p(1,1);
%p2 = p(2,1:2);
%p3 = p(3,1:3);
%p4 = p(4,1:4);
%p5 = p(5,1:5);
%W1 = (inv(R1))*p1';
%W2 = (inv(R2))*p2';
%W3 = (inv(R3))*p3';
%W4 = (inv(R4))*p4';
%W5 = (inv(R5))*p5';


b = 1;
  
Zhat=[] ;
for i = 1:5
    b = [0; w{i}];
    Zhat{end+1} = filter(b,1,Z);   
end

%er = {0,0,0,0,0};
er= {};
for L =1:5
    er{end + 1} = Z - Zhat{L};
end

scaledZ2 = sqrt(19/219).*Z;
%sound(scaledZ2, Fs);

scaleder= {};
for L =1:5
    scaleder{end + 1} = sqrt(19/219)*er{L};
end
sound(scaleder{5}, Fs);
