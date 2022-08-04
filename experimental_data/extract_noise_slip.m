clear variables;
close all;

load("real_loops.mat");
% extract loops with gross slip
loops_slip = real_loops(real_loops.slip == 1, :);

N_cycles = 10;
T = 0.01;       % timelength of input [s]
t = linspace(0, N_cycles*T, N_cycles*600);

m = size(loops_slip,1);
CL = loops_slip.CL;
kt = loops_slip.kt;
mu = loops_slip.mu;
X = loops_slip.X;
N = CL ./ mu;

x = loops_slip.x(1:m,:);
Ffr = loops_slip.Ffr(1:m,:);
% repeat the signal
x = repmat(x, 1, N_cycles);
Ffr = repmat(Ffr, 1, N_cycles);

Ffr_ideal = zeros(m, N_cycles*600);
F_Ffr = zeros(m, N_cycles*600);
F_Ffr_ideal = zeros(m, N_cycles*600);
F_noise = zeros(m, N_cycles*600);

for i = 1:m
    % Remove noise manually
    cd ..\create_numerical_loops
    % use CL, kt, mu values to reconstruct the loop (force response)
    Ffr_offset = true;
    [Ffr_ideal(i,:), ~, ~] = Jenkins_element(kt(i), x(i,:), CL(i), ...
                                                mu(i), Ffr_offset);
    cd ..\experimental_data
    
    F_Ffr(i,:) = fft(Ffr(i,:));
    F_Ffr_ideal(i,:) = fft(Ffr_ideal(i,:));
    F_noise(i,:) = F_Ffr(i,:) - F_Ffr_ideal(i,:);  % extract noise
end

F_noise(:, [11 N_cycles*600-9]) = 0; % delete original frequency
F_noise(F_noise<0) = 0; % delete negative contents

noise_info_slip = table(F_noise, mu, N, kt, X, 'VariableNames', ...
                    {'F_noise', 'mu', 'N', 'kt', 'X'});
save ..\create_numerical_loops\noise_info_slip.mat noise_info_slip;
%% Demonstrate result
i = 1000;
% cd ..
% plot_loops_individual(loops_slip(i,:));
% cd experimental_data

% cd ..
% idx = randperm(size(loops_slip,1));
% plot_loops_individual(loops_slip(idx(1:9),:));
% sgtitle('Gross Slip');
% cd experimental_data

T = t(end) - t(1);  % period
Freq = [0: 1/T : (size(t,2)-1)/T];   %  frequency vector
    
figure;
subplot(2,1,1);
plot(x(i,:), Ffr(i,:));
title('raw');
subplot(2,1,2);
plot(x(i,:), Ffr_ideal(i,:));
title('noise removed');

figure;
subplot(2,1,1);
plot(t, Ffr(i,:),'r.');
hold on;
plot(t, x(i,:));
title('raw');
subplot(2,1,2);
plot(t, Ffr_ideal(i,:));
hold on;
plot(t, x(i,:));
title('noise removed');

figure;
subplot(2,1,1);
plot(Freq, abs(F_Ffr(i,:)), '-+g');
xlabel('Frequency of Ffr with noise');
ylabel('Amplitude');
xlim([0 Freq(end)/2]);  % display up to Nyquist Frequency

subplot(2,1,2);
plot(Freq, abs(F_Ffr_ideal(i,:)), '-+g');
xlabel('Frequency of Ffr without noise');
ylabel('Amplitude');
xlim([0 Freq(end)/2]);  % display up to Nyquist Frequency

figure;
plot(Freq, abs(F_noise(i,:)), '-+g');
xlabel('Frequency of noise content');
ylabel('Amplitude');
xlim([0 Freq(end)/2]);  % display up to Nyquist Frequency