close all
clear

Fs =5e6;
D = 3840;
T =4.096e-4;

antenna1 = [0,0];
antenna2 = [D, 0];

sigvecStruct =  load("sigvec.mat"); 
radarPulse = (sigvecStruct.sigvec)';

radarreception = load("radarreception.mat");
r1vec = radarreception.r1vec;
r2vec = radarreception.r2vec;


[d1vec,d2vec,xvec,yvec] = radardetect(r1vec,r2vec,radarPulse);
