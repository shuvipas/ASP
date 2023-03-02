function bitsvec = text2bitstream(strvec)

intvec = double(strvec);
bitsmat = (dec2bin(intvec,8)-double('0'))'; 
% substract the ASCII value of '0'. 
% the ASCII value of '1' is larger by 1
bitsvec = bitsmat(:);