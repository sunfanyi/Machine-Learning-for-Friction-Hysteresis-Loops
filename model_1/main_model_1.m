clear variables;

%% generate numerical data
close all; 

f = 100;
N_cycles = 2;
cycle_points = 600;
m = 10000;
% random_value_generator = 'gmdistribution';
random_value_generator = 'uniform';
training_cycles = N_cycles;

cd ..
numerical_loops = create_loops(f, N_cycles, cycle_points, m,...
    random_value_generator, training_cycles);
plot_numerical_loops(numerical_loops);
cd model_1

% save loops_10k.mat numerical_loops;

%% choose features for training

% load loops_10k.mat

% raw x vs. F data
% X = [numerical_loops.x numerical_loops.Ffr];

% slope between two consecutive points
X = diff(numerical_loops.Ffr,1,2) ./ diff(numerical_loops.x,1,2);

% derivative of x and Ffr over time
% dxdt = diff(numerical_loops.x,1,2) ./ diff(numerical_loops.t,1,2);
% dFdt = diff(numerical_loops.Ffr,1,2) ./ diff(numerical_loops.t,1,2);
% X = [dxdt dFdt];

% y = numerical_loops.mu;
y = numerical_loops.kt;

m = size(X,1);
Xtrain = X(1:0.8*m,:);
ytrain = y(1:0.8*m,:);
Xtest = X(0.8*m+1:end,:);
ytest = y(0.8*m+1:end,:);

% normalise data
[Xtrain, mu, sigma] = normalise_features(Xtrain);
Xtest = (Xtest-mu)./sigma;


%% linear regression
% rng('default')

holdout = 0.25;
opts = struct('HoldOut', holdout);
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
%              'Learner', 'leastsquares', ...
%              'Regularization', 'ridge', ...
%              'Solver', 'lbfgs', ...
%              'OptimizeHyperparameters', 'lambda', ...
%              'HyperparameterOptimizationOptions', ...
%              struct('AcquisitionFunctionName','expected-improvement-plus'))
linearmdl = fitrlinear(Xtrain, ytrain, ...
             'Learner', 'leastsquares', ...
             'Regularization', 'ridge', ...
             'Solver', 'lbfgs', ...
             'OptimizeHyperparameters', 'lambda', ...
             'HyperparameterOptimizationOptions', opts)

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
%          'OptimizeHyperparameters','all',...
%          'HyperparameterOptimizationOptions',...
%          struct('AcquisitionFunctionName','expected-improvement-plus'))
% save SVMmdl_dxdFdt_opt.mat SVMmdl_dxdFdt_opt;

% load SVMmdl_5;
% cur_model = SVMmdl_5;
% SVMmdl = fitrsvm(Xtrain, ytrain, ...
%             'BoxConstraint', cur_model.ModelParameters.BoxConstraint, ...
%             'Epsilon', cur_model.ModelParameters.Epsilon, ...
%             'KernelFunction', 'linear', ...
%             'KernelScale', cur_model.ModelParameters.KernelScale, ...
%             'Standardize', 0)

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
% load linearmdl_2;
y_pred = predict(linearmdl,Xtest);
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


