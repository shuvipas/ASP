function [reEr,NR] = LMS(L,mu,Z,w)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
w_lms = zeros(L, 1);
Zhat = zeros(length(Z), 1);
reEr = zeros(length(Z), 1);
estEr = zeros(length(Z), 1);
normW = norm(w);
for n = 1:length(Z)
    for l = 1:L
        if n-l < 1
            break
        else
            Zhat(n) = Zhat(n) + w_lms(l) * Z(n-l);
        end
    end
    estEr(n) = Zhat(n) - Z(n);
    for l = 1:L
        if n-L+(l-1) < 1
            continue
        else
            w_lms(l) = w_lms(l) + mu*Z(n-L+(l-1))*estEr(n);
        end
    end
    reEr(n) = 10*log10((norm(w_lms - w)^2)/(normW^2));
end
NR = 10*log10(sum(Z.^2)/sum(estEr.^2));

end

