clear variables; close all;

load loops_10k.mat;
load("..\real_loops.mat");

% loops = numerical_loops;
loops = real_loops;

n = 1;
t = loops.t(n,:);
x = loops.x(n,:);
Ffr = loops.Ffr(n,:);

cd ..
plot_loops_evolution(loops(n,:));
cd model_1

%% FFT
F_x = fft(x);
F_Ffr = fft(Ffr);
T = t(end) - t(1);  % period
Freq = [0: 1/T : (length(t)-1)/T];   %  frequency vector

figure;
subplot(2,1,1);
plot(Freq, abs(F_x), '-+g')
xlabel('Frequency of x (Hz)')
ylabel('Amplitude')
xlim([0 Freq(end)/2])  % display up to Nyquist Frequency

subplot(2,1,2);
plot(Freq, abs(F_Ffr), '-+g')
xlabel('Frequency of Ffr (Hz)')
ylabel('Amplitude')
xlim([0 Freq(end)/2])  % display up to Nyquist Frequency