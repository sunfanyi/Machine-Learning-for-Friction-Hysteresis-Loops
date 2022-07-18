close all; clear variables;

%% generate numerical data
f = 100;
N_cycles = 2;
cycle_points = 600;
m = 1000;
random_value_generator = 'gmdistribution';
training_cycles = N_cycles;

cd ..
numerical_loops = create_loops(f, N_cycles, cycle_points, m,...
    random_value_generator, training_cycles);
plot_numerical_loops(f, N_cycles, cycle_points, ...
            random_value_generator, training_cycles);
cd model_1

% save numerical_loops.mat numerical_loops;

X = [numerical_loops.x numerical_loops.Ffr];
y = numerical_loops.mu;

m = size(X,1);
Xtrain = X(1:0.8*m,:);
ytrain = y(1:0.8*m,:);
Xtest = X(0.8*m+1:end,:);
ytest = y(0.8*m+1:end,:);

%% linear SVM
rng('default')
% linearSVMmdl = fitrsvm(Xtrain,ytrain,...
%              'OptimizeHyperparameters','auto',...
%              'HyperparameterOptimizationOptions',...
%              struct('AcquisitionFunctionName','expected-improvement-plus'))
% save linearSVMmdl.mat linearSVMmdl;

linearSVMmdl_noopt = fitrsvm(Xtrain,ytrain);
% save linearSVMmdl_noopt.mat linearSVMmdl_noopt;

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
% load GaussSVMmdl_noopt;
y_pred = predict(linearSVMmdl_noopt,Xtest);
error = mean(abs((y_pred-ytest)./ytest));

figure;
% randomly choose n samples to display
n = 20;
smp_idx = randi(length(y_pred),[n,1]);
plot(y_pred(smp_idx,:),'bx-');
hold on;
plot(ytest(smp_idx,:),'kx-');
% plot([1:n; 1:n], [ytest(smp_idx,:) y_pred(smp_idx,:)]','r');
legend('predicted mu','actual mu');
title(sprintf('Error: %0.2f%%', 100*error));



