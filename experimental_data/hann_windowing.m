close all; clear variables;
load real_loops.mat

loops = real_loops;

cd ..
idx = randsample(size(loops,1), 9);
plot_loops_individual(loops(idx, :));
cd experimental_data

cycle_points = size(loops.x, 2);
loops.Ffr = hann(cycle_points)'.*loops.Ffr;
% change the starting point of the loop
for i = 100
    x = loops.x(i,:);
    Ffr = loops.Ffr(i,:);
    % find the point with x closest to 0 while F>0
    [val,~] = min(abs(x(Ffr > 0)));

    start_idx = find(abs(x) == val);
    loops.x(i,:) = circshift(x, (cycle_points-start_idx+1));
    loops.Ffr(i,:) = circshift(Ffr, (cycle_points-start_idx+1));
end

cd ..
plot_loops_individual(loops(idx, :));
cd experimental_data



% 
% n = size(loops, 1);
% x = loops.x;
% Ffr = loops.Ffr;
% t = loops.t;
% CL = loops.CL;
% X = loops.X;
% Corners = loops.Corners;
% 
% figure;
% i = 1090;
% plot_loops_evolution(real_loops(i,:));
% subplot(3,1,1);
% plot(x(i,Corners(i,:)), Ffr(i,Corners(i,:)),'rx');
% subplot(3,1,2);
% plot(t(i,Corners(i,:)), x(i,Corners(i,:)),'rx');
% subplot(3,1,3);
% plot(t(i,Corners(i,:)), Ffr(i,Corners(i,:)),'rx');
%%
close all;

dt = 0.01;
T = 1.2;
t = 0:dt:T-dt;
x = sin(2*pi*t);
figure; plot(t,x)

t2 = 0:dt:T*10-dt;
x2 = repmat(x,1,10);
figure; plot(t2,x2);

x = x .* hann(length(x))';
figure; plot(t,x);

x3 = repmat(x,1,10);
figure; plot(t2,x3);

F = fft(x2);
T = t2(end) - t2(1);  % period
Freq = [0: 1/T : (size(t2,2)-1)/T];   %  frequency vector
figure;
plot(Freq, abs(F), '-+g');
xlabel('Frequency of Ffr raw');
ylabel('Amplitude');
xlim([0 Freq(end)/2]);  % display up to Nyquist Frequency

F_hann = fft(x3);
T = t2(end) - t2(1);  % period
Freq = [0: 1/T : (size(t2,2)-1)/T];   %  frequency vector
figure;
plot(Freq, abs(F_hann), '-+g');
xlabel('Frequency of Ffr after hann window');
ylabel('Amplitude');
xlim([0 Freq(end)/2]);  % display up to Nyquist Frequency