
close all 
clear 


%Question 1

sigvecStruct =  load("sigvec.mat"); 
sigvec = (sigvecStruct.sigvec)';

delayedvecs = load("delayedvecs.mat");
r1vec = delayedvecs.r1vec;   
r2vec = delayedvecs.r2vec;  
L = length(sigvec);
figure
plot(r1vec)
xlim([1, 2048])
title("r1vec signal")

figure
plot(r2vec)
title("r2vec signal")
xlim([1, 2048])

%legend("r1vec", "r2vec")

%delta =1;

matchedfiltcoeffs = sigvec(end:-1:1);

filtoutR1vec = filter(matchedfiltcoeffs,1,r1vec);
[MaxVal,IndexR1vec] = max(filtoutR1vec); 

IndexR1vec = IndexR1vec - L;

filtoutR2vec = filter(matchedfiltcoeffs,1,r2vec);
[MaxVal,IndexR2vec] = max(filtoutR2vec);

IndexR2vec = IndexR2vec - L;




% Question 2

delayedvecsQ2= load("delayedvecsQ2.mat");
r1 = delayedvecsQ2.r1;
r2 = delayedvecsQ2.r2;
r3 = delayedvecsQ2.r3;

delta1 = delayedvecsQ2.delta1;
delta2 = delayedvecsQ2.delta2;
delta3 = delayedvecsQ2.delta3;

sigma2_1 = delayedvecsQ2.sigma2_1;
sigma2_2 = delayedvecsQ2.sigma2_2;
sigma2_3 = delayedvecsQ2.sigma2_3;

M = 2048 -128; 

th1 = (norm(sigvec)^2)/2+sigma2_1*log((1- delta1)/delta1*(M-1)); %threshold 
th2 = (norm(sigvec)^2)/2+sigma2_2*log((1- delta2)/delta2*(M-1));
th3 = (norm(sigvec)^2)/2+sigma2_3*log((1- delta3)/delta3*(M-1));

filtoutR1 = filter(matchedfiltcoeffs,1,r1);
[MaxValR1,IndexR1] = max(filtoutR1); 
IndexR1 = IndexR1 - L;

if MaxValR1 >= th1
    estR1 = IndexR1;
else 
    estR1 = M;
end


filtoutR2 = filter(matchedfiltcoeffs,1,r2);
[MaxValR2,IndexR2] = max(filtoutR2); 
IndexR2 = IndexR2 - L;

if MaxValR2 >= th2
    estR2 = IndexR2;
else 
    estR2 = M;
end

filtoutR3 = filter(matchedfiltcoeffs,1,r3);
[MaxValR3,IndexR3] = max(filtoutR3); 
IndexR3 = IndexR3 - L;

if MaxValR3 >= th3
    estR3 = IndexR3;
else 
    estR3 = M;
end




