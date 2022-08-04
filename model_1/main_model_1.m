clear variables;

%% generate numerical data
close all; 

fex = 100;  % excitation frequency (Hz)
N_cycles = 2;
cycle_points = 600;
m = 1000;
noise = 'fft';
random_value_generator = 'gmdistribution';
% random_value_generator = 'uniform';
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

cd ..
normalise = false;
plot_loops_individual(loops(1:16,:), normalise);
cd model_1
%% choose features for training

% load loops_10k.mat

% raw x vs. F data
% X = [loops.x loops.Ffr];

% slope between two consecutive points
X = diff(loops.Ffr,1,2) ./ diff(loops.x,1,2);

% derivative of x and Ffr over time
% dxdt = diff(loops.x,1,2) ./ diff(loops.t,1,2);
% dFdt = diff(loops.Ffr,1,2) ./ diff(loops.t,1,2);
% X = [dxdt dFdt];

% y = loops.mu;
y = loops.kt;

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

%% linear regression
% rng('default')

% holdout = 0.25;
% opts = struct('HoldOut', holdout);
% optimizableParams = hyperparameters('fitrlinear', Xtrain, ytrain)
% optimizableParams = optimizableParams(1)  % lambda only
% 
% linearmdl = fitrlinear(Xtrain, ytrain, ...
%              'Learner','leastsquares', ...
%              'OptimizeHyperparameters',optimizableParams, ...
%              'HyperparameterOptimizationOptions', opts)
% linearmdl = fitrlinear(Xtrain, ytrain, ...
%              'OptimizeHyperparameters','auto', ...
%              'HyperparameterOptimizationOptions', opts)
% linearmdl = fitrlinear(Xtrain, ytrain, ...
%              'Regularization', 'ridge', ...
%              'Solver', 'lbfgs', ...
%              'OptimizeHyperparameters','auto', ...
%              'HyperparameterOptimizationOptions', ...
%              struct('AcquisitionFunctionName','expected-improvement-plus'))
% linearmdl = fitrlinear(Xtrain, ytrain, ...
%              'Learner', 'svm', ...
%              'Regularization', 'ridge', ...
%              'Solver', 'lbfgs', ...
%              'OptimizeHyperparameters', 'lambda', ...
%              'HyperparameterOptimizationOptions', ...
%              struct('AcquisitionFunctionName','expected-improvement-plus'))
% linearmdl = fitrlinear(Xtrain, ytrain, ...
%              'Learner', 'svm', ...
%              'Regularization', 'ridge', ...
%              'Solver', 'lbfgs', ...
%              'OptimizeHyperparameters', 'lambda', ...
%              'HyperparameterOptimizationOptions', ...
%              struct('AcquisitionFunctionName','expected-improvement-plus','KFold', 5))
% linearmdl = fitrlinear(Xtrain, ytrain, ...
%              'Learner', 'leastsquares', ...
%              'Regularization', 'ridge', ...
%              'Solver', 'lbfgs', ...
%              'OptimizeHyperparameters', 'lambda', ...
%              'HyperparameterOptimizationOptions', opts)

% load linearmdl_1;
% cur_model = linearmdl_1;
% linearmdl = fitrlinear(Xtrain, ytrain, ...
%             'Lambda', cur_model.Lambda, ...
%             'Learner', cur_model.Learner, ...
%             'Regularization', 'lasso')
% save linearmdl_1.mat linearmdl_1;

% linearmdl = fitrsvm(Xtrain,ytrain);
% save linearmdl_noopt.mat linearmdl_noopt;

%% SVM
% rng('default')
% SVMmdl = fitrsvm(Xtrain,ytrain,...
%         'OptimizeHyperparameters','all',...
%         'HyperparameterOptimizationOptions',...
%         struct('AcquisitionFunctionName','expected-improvement-plus'))
SVMmdl = fitrsvm(Xtrain, ytrain,...
        'RemoveDuplicates', false, ...
        'KernelScale', 'auto', ...
        'Standardize', true, ...
        'KernelFunction', 'linear', ...
        'OptimizeHyperparameters',{'BoxConstraint', 'Epsilon'},...
        'HyperparameterOptimizationOptions',...
        struct('AcquisitionFunctionName','expected-improvement-plus'))
% save SVMmdl_dxdFdt_opt.mat SVMmdl_dxdFdt_opt;

% load SVMmdl_7;
% cur_model = SVMmdl_7;
% SVMmdl = fitrsvm(Xtrain, ytrain, ...
%             'RemoveDuplicates', false, ...
%             'KernelScale', 'auto', ...
%             'Standardize', true, ...
%             'KernelFunction', 'linear', ...
%             'BoxConstraint', cur_model.ModelParameters.BoxConstraint, ...
%             'Epsilon', cur_model.ModelParameters.Epsilon)

% SVMmdl_noopt = fitrsvm(Xtrain,ytrain,'Standardize', true);
% save SVMmdl_noopt.mat SVMmdl_noopt;

%% Guassian SVM
% rng('default')
% [GaussSVMmdl,FitInfo,HyperparameterOptimizationResults] = fitrkernel(Xtrain,ytrain,...
%                  'OptimizeHyperparameters','auto',...
%                  'HyperparameterOptimizationOptions',...
%                  struct('AcquisitionFunctionName','expected-improvement-plus'))
% save GaussSVMmdl.mat GaussSVMmdl;
% 
% GaussSVMmdl_noopt = fitrkernel(Xtrain,ytrain);
% save GaussSVMmdl_noopt.mat GaussSVMmdl_noopt;

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


