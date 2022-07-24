clear variables; close all;

cycles = cell(34,1);
n_loop = zeros(34, 1);  % number of loops in each condition cp
for cp = 1:34
    path = [pwd,'\Data Round Robin\CP',num2str(cp),'\cycle.mat'];
    load(path);
    cycles{cp} = cycle(1,:);
    n_loop(cp) = length(cycle(1,:));
end

fex = 100;  % excitation frequency (Hz)
cycle_points = 600;

n = sum(n_loop);  % total number of loops
x = zeros(n, cycle_points);
Ffr = zeros(n, cycle_points);
mu = zeros(n, 1);
CL = zeros(n, 1);
kt = zeros(n, 1);
X = zeros(n, 1);
CP = zeros(n, 1);
loop_idx = zeros(n, 1);

T = 1/fex;       % timelength of input [s]
t = linspace(0,T,cycle_points);
t = repmat(t, n, 1);  % for now each loop has same time signal

idx = 1;
for cp = 1:34
    for i = 1:n_loop(cp)
        path = [pwd, '\Data Round Robin\CP', num2str(cp), '\cycle', ...
                    num2str(cycles{cp}(i)), '.mat'];
        load(path);
        x(idx,:) = hyst(:,1);
        Ffr(idx,:) = hyst(:,2);
        mu(idx) = mu_Fs_ktL_ktR_m1_Fex_slip_muE(end,1);
        CL(idx) = mu_Fs_ktL_ktR_m1_Fex_slip_muE(end,2);
        kt(idx) = (mu_Fs_ktL_ktR_m1_Fex_slip_muE(end,3) + ...
                mu_Fs_ktL_ktR_m1_Fex_slip_muE(end,4)) / 2;
        X(idx) = mu_Fs_ktL_ktR_m1_Fex_slip_muE(end,7);
        CP(idx) = cp;
        loop_idx(idx) = cycles{cp}(i);
        idx = idx + 1;
    end
end

N = CL ./ mu;
real_loops = table(mu, N, CL, kt, X, CP, loop_idx, x, Ffr, t, ...
            'VariableNames', {'mu','N','CL','kt','X','CP','loop_idx','x','Ffr','t'});
plot_loops_evolution(real_loops(1:1,:));
% save real_loops.mat real_loops

% i = 1;
% subplot(3,1,1);
% plot(x(i,corners), Ffr(i,corners),'rx');
% subplot(3,1,2);
% plot(t(i,corners), x(i,corners),'rx');
% subplot(3,1,3);
% plot(t(i,corners), Ffr(i,corners),'rx');

