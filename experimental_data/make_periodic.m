function [F] = make_periodic(F_raw)
%MAKE_PERIODIC makes the raw signal periodic.
%   make_periodic(F_raw) returns a periodic signal with the value of first
%   point euivalent to the value of the last point. This solves the problem
%   of discontinuity and makes the signal continous after concatted, and
%   thereby preventing the spectral leakage problem during FFT.
%

diff = F_raw(:,1) - F_raw(:,end);
if diff == 0
    F = F_raw;
else
    n = size(F_raw,2);
    F = zeros(size(F_raw));
    for i = 1:n
        F(:,i) = F_raw(:,i) + (i-1) / n .* diff;
    end
end

end