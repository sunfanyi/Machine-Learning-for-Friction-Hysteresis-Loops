clear variables;

%% generate numerical data
close all; 

fex = 100;  % excitation frequency (Hz)
N_cycles = 2;
cycle_points = 600;
m = 1000;
noise = true;
% random_value_generator = 'gmdistribution';
random_value_generator = 'uniform';
training_cycles = N_cycles;

cd ..\create_numerical_loops
numerical_loops = create_loops(fex, N_cycles, cycle_points, m, noise, ...
    random_value_generator, training_cycles);
loops = numerical_loops;

% cd ..\experimental_data
% load real_loops.mat;
% loops = real_loops;

% load loops_1k_uniform.mat
% loops = loops_1k_uniform;

cd ..\model_1
loops = loops(loops.mu ~= 0,:);
[x_norm, x_range] = scale_feature(loops.x);
[Ffr_norm, Ffr_range] = scale_feature(loops.Ffr);

n = 16;
figure;
for i = 1:n
    subplot(sqrt(n),sqrt(n),i)
    plot(x_norm(i,:), Ffr_norm(i,:), 'b.');
    hold on;
    plot(x_norm(i,1), Ffr_norm(i,1), 'rx');
    xlabel('Relative Displacement [\mu m]');
    if mod(i,sqrt(n)) == 1
        ylabel('Friction Force [N]');
    end
    title(sprintf('rangeX: %0.2f. rangeF: %0.2f', x_range(i), Ffr_range(i)));
end

%%
cd ..
plot_loops_individual(loops(55,:));
cd model_1
%% choose features for training

% load loops_10k.mat

% scaled x & F
X = [x_range Ffr_range x_norm Ffr_norm];

y = loops.mu;
% y = loops.kt;
% y = loops.E;

m = size(X,1);
pct = 0.8;  % percentage training set
idx = randperm(m);
Xtrain = X(idx(1:round(pct*m)),:);
ytrain = y(idx(1:round(pct*m)),:);
Xtest = X(idx(round(pct*m)+1:end),:);
ytest = y(idx(round(pct*m)+1:end),:);

% normalise data
% [Xtrain, mu, sigma] = standarise_features(Xtrain);
% Xtest = (Xtest-mu)./sigma;

rng('default');

%% SVM
% rng('default')
SVMmdl = fitrsvm(Xtrain, ytrain,...
        'OptimizeHyperparameters','all',...
        'HyperparameterOptimizationOptions',...
        struct('AcquisitionFunctionName','expected-improvement-plus'))
% SVMmdl = fitrsvm(Xtrain, ytrain,...
%         'RemoveDuplicates', false, ...
%         'KernelScale', 'auto', ...
%         'Standardize', false, ...
%         'KernelFunction', 'linear', ...
%         'OptimizeHyperparameters',{'BoxConstraint', 'Epsilon'},...
%         'HyperparameterOptimizationOptions',...
%         struct('AcquisitionFunctionName','expected-improvement-plus'))
% save SVMmdl_dxdFdt_opt.mat SVMmdl_dxdFdt_opt;

%% Evaluate model performance
% load linearmdl_3;
if ~SVMmdl.ConvergenceInfo.Converged
    disp('not convergent');
else
    disp('convergent');
end

% % try predicting experimental data
% load SVMmdl_7;
% cd ..\experimental_data
% load real_loops.mat;
% Xtest = diff(real_loops.Ffr,1,2) ./ diff(real_loops.x,1,2);
% ytest = real_loops.kt;
% cd ..\model_1

y_pred = predict(SVMmdl, Xtest);
error = (y_pred-ytest)./ytest;

figure;
% randomly choose n samples to display
n = 30;
smp_idx = randi(length(y_pred),[n,1]);
plot(y_pred(smp_idx,:),'bx-');
hold on;
plot(ytest(smp_idx,:),'kx-');
% plot([1:n; 1:n], [ytest(smp_idx,:) y_pred(smp_idx,:)]','r');
legend('predicted','actual');
[max_error, idx] = max(abs(error));
title(sprintf('mean error: %0.2f%%, highest error: %0.2f%% at %0.0f%th', ...
            100*mean(abs(error)), 100*max_error, idx));
figure;
plot(error,'x');


