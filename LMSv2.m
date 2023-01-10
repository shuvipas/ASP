function [] = LMSv2(L,mu,Z, name)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
w_lms = zeros(L, 1);
Zhat = zeros(length(Z), 1);
%reEr = zeros(length(Z), 1);
estEr = zeros(length(Z), 1);
%normW = norm(w);
M = 10e3;
PSignal = zeros(length(Z),1);
for n = 1:length(Z)
    if (n - M + 1) < 1 
        PSignal(n) = 1/M*sum(Z(1:n).^2);
    else
        PSignal(n) = 1/M*sum(Z(n-M+1:n).^2);
    end
    
end


for n = 1:length(Z)
   
    for l = 1:L
        if n-l<1
            continue
        end
        Zhat(n) = Zhat(n)+ w_lms(l)*Z(n-l);
    end
    
    estEr(n) = Zhat(n)  - Z(n);
   % c = w_lms -w;
   % reEr(n) = 10*log10(((norm(c))^2)/(normW^2));
    
    
    for l =1:L
        if n-l<1
            continue
        end
        w_lms(l) =+ mu*estEr(n)*Z(n-l);
    end
    
end    
  
NR = 10*log10(sum(Z.^2)/sum(estEr.^2));


PError = zeros(length(Z),1);
for n = 1:length(Z)
    if (n - M + 1) < 1 
        PError(n) = 1/M*sum(estEr(1:n).^2);
    else
        PError(n) = 1/M*sum(estEr(n-M+1:n).^2);
    end
    dbpsig = 10*log10(PSignal);
    dbper= 10*log10(PError);
    figure
    plot(dbpsig)
    hold on
    plot(dbper)
    str = sprintf("%s LMS: L= %d, mu = %f noise reduction = %fdB ",name, L,mu,NR);
    title(str)
    xlabel("sample number")
    ylabel("instantaneous power [dB]")
    legend("original noise power", "predection error power")
    hold off

end

end
