function strvec = bitstream2text(bitsvec)

bitsvec = bitsvec(:);
bitsmat = reshape(bitsvec,8,floor(length(bitsvec)/8));
intvec = (2.^(7:-1:0))*bitsmat;
strvec = char(intvec);
