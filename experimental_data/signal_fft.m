clear variables;

% load("..\model_1\loops_10k.mat");
load("real_loops.mat");
%% 
close all;

% loops = numerical_loops;
loops = real_loops;

n = size(loops,1);
t = loops.t(1:n,:);
x = loops.x(1:n,:);
Ffr = loops.Ffr(1:n,:);

cd ..
plot_loops_individual(loops(1:16,:));
sgtitle('Real Loops');
cd experimental_data

%% FFT
F_Ffr_noise = zeros(n, 600);
Freq_noise = zeros(n, 600);

for i = 1:n
    F_x = fft(x(i,:));
    F_Ffr = fft(Ffr(i,:));
    T = t(i,end) - t(i,1);  % period
    Freq = [0: 1/T : (size(t,2)-1)/T];   %  frequency vector
    
%     extract the noise signal
    F_Ffr_noise(i,:) = [0 0 F_Ffr(3:end)];
    Freq_noise(i,:) = Freq;
end

save ..\create_numerical_loops\F_Ffr_noise.mat F_Ffr_noise;

figure;
subplot(2,1,1);
plot(Freq, abs(F_x), '-+g');
xlabel('Frequency of x (Hz)');
ylabel('Amplitude');
xlim([0 Freq(end)/2]);  % display up to Nyquist Frequency

subplot(2,1,2);
plot(Freq, abs(F_Ffr), '-+g');
xlabel('Frequency of Ffr (Hz)');
ylabel('Amplitude');
xlim([0 Freq(end)/2]);  % display up to Nyquist Frequency

% figure;
% plot(Freq_noise(n,:), abs(F_Ffr_noise(n,:)), '-+g');
% xlabel('Frequency of Ffr (Hz)');
% ylabel('Amplitude');
% title('Noise');
% xlim([0 Freq_noise(n,end)/2]);  % display up to Nyquist Frequency

%% ifft (add noise to numerical loops)
load("..\model_1\loops_10k.mat");
loops = numerical_loops;

n = size(loops,1);
t = loops.t(1:n,:);
x = loops.x(1:n,:);
Ffr = loops.Ffr(1:n,:);

F_Ffr = zeros(n, 600);
F_Ffr_with_noise = zeros(n, 600);
Ffr_with_noise = zeros(n, 600);

for i = 1:n
    F_x = fft(x(i,:));
    F_Ffr(i,:) = fft(Ffr(i,:));
    T = t(i,end) - t(i,1);  % period
    Freq = [0: 1/T : (size(t,2)-1)/T];   %  frequency vector
    
    idx = randsample(size(F_Ffr_noise,1),1);
    F_Ffr_with_noise(i,:) = F_Ffr(i,:) + F_Ffr_noise(idx,:);
    
    Ffr_with_noise(i,:) = real(ifft(F_Ffr_with_noise(i,:)));
end

%% show results
i = 1;
figure;
subplot(2,1,1);
plot(Freq, abs(F_Ffr(i,:)), '-+g');
xlabel('Frequency of Ffr (Hz)');
ylabel('Amplitude');
title('Original numerical signal')
xlim([0 Freq(end)/2]);  % display up to Nyquist Frequency

subplot(2,1,2);
plot(Freq, abs(F_Ffr_with_noise(i,:)), '-+g');
xlabel('Frequency of Ffr (Hz)');
ylabel('Amplitude');
title('Numerical signal with noise')
xlim([0 Freq(end)/2]);  % display up to Nyquist Frequency

loops_with_noise = loops;
loops_with_noise.Ffr = Ffr_with_noise;

i = 1:16;
cd ..
plot_loops_individual(loops(i,:));
sgtitle('Original numerical loops');
plot_loops_individual(loops_with_noise(i,:));
sgtitle('Numerical loops with noise');
cd experimental_data