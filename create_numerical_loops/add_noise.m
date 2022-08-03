function [Ffr_with_noise] = add_noise(Ffr, parameters, slip, cycle_points)
%ADD_NOISE adds noise to numerical hysteresis loops.
%   add_noise(Ffr, slip, cycle_points) returns friction force signal after
%   noise contents are added. The noise contents in frequency domain are
%   obtained from the experimental data after FFT. They include noise for
%   loops with and without gross slip regime separately. Corresponding
%   noise contents are added to different types of numerical loops. When
%   adding noise, the function uses the parameters to create the numerical
%   loops (mu, N, kt & X), and search within all noise data for the one
%   with the closest parameters by finding the Euclidean distance. This is
%   to simulate the real test conditions.
%
%   Ffr is the original force signal, noise will be added to Ffr
%
%   paramters is a m*4 matrix where m is the number of loops. It usually
%   contains mu, N, kt & X.
%
%   slip is a logical variable which specifies whether the gross slip
%   regime is reached.
%
%   cycle_points is the number of points per cycle
%

load noise_info_slip.mat noise_info_slip;
load noise_info_stick.mat noise_info_stick;

m = size(Ffr, 1);
Ffr = repmat(Ffr, 1, 10);  % repeat 10 times so same size as noise content
% F_Ffr = zeros(m, cycle_points*10);
% F_Ffr_with_noise = zeros(m, cycle_points*10);
Ffr_with_noise = zeros(m, cycle_points*10);

for i = 1:m
    F_Ffr = fft(Ffr(i,:));
%     disp(parameters(i,:));
    % assign noise content to force signals
    if slip(i)
        idx = dsearchn(table2array(noise_info_slip(:,2:5)), parameters(i,:));
        F_Ffr_with_noise = F_Ffr + 0.5*noise_info_slip.F_noise(idx,:);
    else
        idx = dsearchn(table2array(noise_info_stick(:,2:5)), parameters(i,:));
        F_Ffr_with_noise = F_Ffr + 0.5*noise_info_stick.F_noise(idx,:);
    end
    
    Ffr_with_noise(i,:) = real(ifft(F_Ffr_with_noise));
end
% change back to the original size
Ffr_with_noise = Ffr_with_noise(:,1:size(Ffr_with_noise,2)/10);

end