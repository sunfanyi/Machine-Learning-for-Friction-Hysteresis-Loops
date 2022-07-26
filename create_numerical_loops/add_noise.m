function [Ffr_with_noise] = add_noise(Ffr, cycle_points)

load F_Ffr_noise.mat F_Ffr_noise;

n = size(Ffr, 1);
F_Ffr = zeros(n, cycle_points);
F_Ffr_with_noise = zeros(n, cycle_points);
Ffr_with_noise = zeros(n, cycle_points);

for i = 1:n
    F_Ffr(i,:) = fft(Ffr(i,:));
    
    idx = randsample(size(F_Ffr_noise,1),1);
    F_Ffr_with_noise(i,:) = F_Ffr(i,:) + F_Ffr_noise(idx,:);
    
    Ffr_with_noise(i,:) = real(ifft(F_Ffr_with_noise(i,:)));
end


end