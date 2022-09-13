clear variables; close all;

fex = 100;
cycles = cell(34,1);
n_loop = zeros(34, 1);  % number of loops in each condition cp
for cp = 1:34
    path = [pwd,'\..\Data Round Robin\CP',num2str(cp),'\cycle.mat'];
    load(path);
    cycles{cp} = cycle(1,:);
    n_loop(cp) = length(cycle(1,:));
end

n = sum(n_loop);  % total number of loops
for cp = 1:34
    mu_all = [];
    kt_all = [];
    t = [];  % time signal
    T_pre = 0;  % time elapsed when recording the previous loops
    for i = 1:n_loop(cp)
        path = [pwd, '\..\Data Round Robin\CP', num2str(cp), '\cycle', ...
                    num2str(cycles{cp}(i)), '.mat'];
        load(path);

        mu_loop = mu_Fs_ktL_ktR_m1_Fex_slip_muE(:,1);
        kt_loop = (mu_Fs_ktL_ktR_m1_Fex_slip_muE(:,3) + ...
                mu_Fs_ktL_ktR_m1_Fex_slip_muE(:,4)) ./ 2;
        error_idx = (kt_loop <= 0) | (mu_loop < 0) | (mu_loop > 2);
        mu_loop(error_idx) = [];
        kt_loop(error_idx) = [];
        
        T = cycles{cp}(i) / fex;  % time elapsed when recording the current loops
        t_interal = linspace(T_pre, T, length(mu_loop)+1)';
        t = [t; t_interal(2:end)];
        T_pre = T;
        
        mu_all = [mu_all; mu_loop];
        kt_all = [kt_all; kt_loop];
        
    end
    var_name = ['cp', num2str(cp)];
    assignin('base', var_name, [t mu_all kt_all]);
    save('evoluation_mu_kt.mat', var_name, '-append')
end

