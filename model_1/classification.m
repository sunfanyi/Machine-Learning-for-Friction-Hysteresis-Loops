clear variables;

%% generate numerical data

fex = 100;  % excitation frequency (Hz)
N_cycles = 2;
cycle_points = 600;
m = 3000;
noise = true;
random_value_generator = 'gmdistribution';
% random_value_generator = 'uniform';
% random_value_generator = 'more_stick';
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

%% choose features for training

% load loops_10k.mat
x_range = max(loops.x,[],2) - min(loops.x,[],2);
Ffr_range = max(loops.Ffr,[],2) - min(loops.Ffr,[],2);
dFdx = diff(loops.Ffr,1,2) ./ diff(loops.x,1,2);
X = [loops.area x_range Ffr_range dFdx];

y = loops.slip;

m = size(X,1);
pct = 0.8;  % percentage training set
idx = randperm(m);
Xtrain = X(idx(1:round(pct*m)),:);
ytrain = y(idx(1:round(pct*m)),:);
Xtest = X(idx(round(pct*m)+1:end),:);
ytest = y(idx(round(pct*m)+1:end),:);
loops_test = loops(idx,:);

% normalise data
% [Xtrain, mu, sigma] = standarise_features(Xtrain);
% Xtest = (Xtest-mu)./sigma;

rng('default');

%% fitcsvm
% SVMmdl = fitcsvm(Xtrain,ytrain,...
%         'OptimizeHyperparameters','all',...
%         'HyperparameterOptimizationOptions',...
%         struct('AcquisitionFunctionName','expected-improvement-plus'))
SVMmdl = fitcsvm(Xtrain, ytrain,...
        'Standardize', true, ...
        'KernelFunction', 'gaussian', ...
        'OptimizeHyperparameters',{'BoxConstraint','KernelScale'},...
        'HyperparameterOptimizationOptions',...
        struct('AcquisitionFunctionName','expected-improvement-plus'))
%% Evaluate model performance
close all;
% load linearmdl_3;

fprintf('Accuracy on numerical loops:\n');
error_loops = evaluate_mdl_classification(SVMmdl, Xtrain, ytrain, ...
                                    Xtest, ytest, loops_test);
                            
% try predicting experimental data
cd ..\experimental_data
load real_loops.mat;
cd ..\model_1
x_range = max(real_loops.x,[],2) - min(real_loops.x,[],2);
Ffr_range = max(real_loops.Ffr,[],2) - min(real_loops.Ffr,[],2);
dFdx = diff(real_loops.Ffr,1,2) ./ diff(real_loops.x,1,2);
X_real = [real_loops.area x_range Ffr_range dFdx];
y_real = real_loops.slip;

fprintf('Accuracy on experimental loops:\n');
error_loops_real = evaluate_mdl_classification(SVMmdl, nan, nan, ...
                                    X_real, y_real, real_loops);

