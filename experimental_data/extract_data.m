clear variables; close all;

cycles = cell(34,1);
n_loop = zeros(34, 1);  % number of loops in each condition cp
for cp = 1:34
    path = [pwd,'\..\Data Round Robin\CP',num2str(cp),'\cycle.mat'];
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
Corners = zeros(n, 4);

T = 1/fex;       % timelength of input [s]
t = linspace(0,T-T/cycle_points,cycle_points);
t = repmat(t, n, 1);  % for now each loop has same time signal

idx = 1;
for cp = 1:34
    for i = 1:n_loop(cp)
        path = [pwd, '\..\Data Round Robin\CP', num2str(cp), '\cycle', ...
                    num2str(cycles{cp}(i)), '.mat'];
        load(path);
        
        temp_x = make_periodic(hyst(:,1)');
        temp_Ffr = make_periodic(hyst(:,2)');
%         temp_x = hyst(:,1);
%         temp_Ffr = hyst(:,2);

        % find the point with x closest to 0 while F>0
        [val,~] = min(abs(temp_x(temp_Ffr > 0)));
        if isempty(val)
            idx = idx + 1;
            n = n - 1;
            fprintf('all force signals are negative CP%d/cycle%d.mat\n',cp,cycles{cp}(i));
            continue;
        end
        % change the starting point of the loop
        start_idx = find(abs(temp_x) == val);
        x(idx,:) = circshift(temp_x, (cycle_points-start_idx+1));
        Ffr(idx,:) = circshift(temp_Ffr, (cycle_points-start_idx+1));

%         x(idx,:) = temp_x;
%         Ffr(idx,:) = temp_Ffr;
        
        mu(idx) = mu_Fs_ktL_ktR_m1_Fex_slip_muE(end,1);
        CL(idx) = mu_Fs_ktL_ktR_m1_Fex_slip_muE(end,2);
        kt(idx) = (mu_Fs_ktL_ktR_m1_Fex_slip_muE(end,3) + ...
                mu_Fs_ktL_ktR_m1_Fex_slip_muE(end,4)) / 2;
        X(idx) = mu_Fs_ktL_ktR_m1_Fex_slip_muE(end,7);
        Corners(idx,:) = corners;
        CP(idx) = cp;
        loop_idx(idx) = cycles{cp}(i);
        
        if kt(idx) <= 0
            fprintf('negative kt in CP%d/cycle%d.mat\n',cp,cycles{cp}(i));
        end
        if mu(idx) < 0
            fprintf('negative mu in CP%d/cycle%d.mat\n',cp,cycles{cp}(i));
        elseif mu(idx) >= 2
            fprintf('mu >= 2 in CP%d/cycle%d.mat\n',cp,cycles{cp}(i));
        elseif isnan(mu(idx))
            fprintf('missing mu in CP%d/cycle%d.mat\n',cp,cycles{cp}(i));
        end
            
        idx = idx + 1;
    end
end

N = CL ./ mu;
slip = single(mu ~= 0);
area = polyarea(x, Ffr, 2)*10^(-6);  % area after noise is added
real_loops_original = table(mu, N, CL, kt, area, slip, X, Corners, CP, loop_idx, x, Ffr, t, ...
            'VariableNames', ...
            {'mu','N','CL','kt','area','slip','X','Corners','CP','loop_idx','x','Ffr','t'});
        
real_loops = real_loops_original;
real_loops(real_loops.CP == 0,:) = [];  % delete rows with incorrect data
real_loops(real_loops.kt <= 0,:) = [];  % delete rows with negative kt
real_loops(real_loops.mu < 0,:) = [];  % delete rows with negative mu
real_loops(isnan(real_loops.mu),:) = []  % delete rows without mu, CL & N
real_loops(real_loops.mu >= 2,:) = [];  % delete rows with very high mu

cd ..
plot_loops_individual(real_loops([1 20 50 70 100 120 140 160 200],:));
cd experimental_data
save real_loops.mat real_loops;
save real_loops_original.mat real_loops_original;

% i = 1;
% subplot(3,1,1);
% plot(x(i,corners), Ffr(i,corners),'rx');
% subplot(3,1,2);
% plot(t(i,corners), x(i,corners),'rx');
% subplot(3,1,3);
% plot(t(i,corners), Ffr(i,corners),'rx');