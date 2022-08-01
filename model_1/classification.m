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
x_range = max(loops.x,[],2) - min(loops.x,[],2);
Ffr_range = max(loops.Ffr,[],2) - min(loops.Ffr,[],2);

%% choose features for training

% load loops_10k.mat
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
% load linearmdl_3;
if ~SVMmdl.ConvergenceInfo.Converged
    disp('not convergent');
else
    disp('convergent');
end

% % try predicting experimental data
% cd ..\experimental_data
% load real_loops.mat;
% dFdx = diff(real_loops.Ffr,1,2) ./ diff(real_loops.x,1,2);
% X = [real_loops.area x_range Ffr_range dFdx];
% ytest = real_loops.kt;
% cd ..\model_1

y_pred = predict(SVMmdl, Xtest);
fprintf('Training Accuracy: %0.2f %%| Test Accuracy : %0.2f %% | Failures: %d over %d\n', ...
        mean(predict(SVMmdl, Xtrain) == ytrain)*100, ...
        mean(y_pred == ytest)*100, ...
        mean(y_pred ~= ytest)*size(ytest,1), size(ytest,1));

figure;
error_loops = loops_test(y_pred ~= ytest, :);
if size(error_loops,1) > 9
    error_loops = error_loops(1:9, :);
end

for i = 1:size(error_loops,1)
    subplot(3,3,i);
    plot(error_loops.x(i,:), error_loops.Ffr(i,:), 'b.');
    xlabel('Relative Displacement [\mu m]');
    if mod(i,3) == 1
        ylabel('Friction Force [N]');
    end
end
