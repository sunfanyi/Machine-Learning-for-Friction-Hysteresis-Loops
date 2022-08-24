clear variables;

%% load data
close all; 

fex = 100;  % excitation frequency (Hz)
N_cycles = 2;
cycle_points = 600;
m = 6000;
noise = 'fft';
% random_value_generator = 'gmdistribution';
random_value_generator = 'uniform';
% random_value_generator = 'more_stick';
training_cycles = N_cycles;

cd ..\create_numerical_loops
numerical_loops = create_loops(fex, N_cycles, cycle_points, m, noise, ...
    random_value_generator, training_cycles);
loops = numerical_loops;
cd ..\model_1

% cd ..\experimental_data
% load real_loops.mat;
% loops = real_loops;


%% classification
pct_train = 0;
[~, loops_test, ~, ~, Xtest, ytest] = choose_features(loops, ...
                                            'slip', pct_train);
                                        
load mdl_classification.mat;
y_pred = predict(mdl_classification, Xtest);
fprintf('Percentage of loops correctly classified: %0.2f%%\n', ...
            mean(y_pred == ytest)*100);
        
loops_slip = loops_test(y_pred == 1,:);
% loops_stick = loops_test(y_pred == 0,:);

cd ..
normalise = false;
idx = randperm(size(loops_slip,1), 16);
plot_loops_individual(loops_slip(idx,:), normalise);
cd model_1

%% choose features
pct_train = 0.8;
[~, loops_test, Xtrain, ytrain, Xtest, ytest] = choose_features(loops_slip, ...
                                            'CL', pct_train);

%% Train models
rng('default');
mdl_CL = fitrsvm(Xtrain, ytrain,...
        'RemoveDuplicates', true, ...
        'Standardize', true, ...
        'KernelFunction', 'gaussian', ...
        'OptimizeHyperparameters', {'KernelScale', 'BoxConstraint', 'Epsilon'},...
        'HyperparameterOptimizationOptions',...
        struct('AcquisitionFunctionName','expected-improvement-plus'))

%% Evaluate model performance
fprintf('\n========== CL ==========\n');
fprintf('Training error: %0.2f%%\n', ...
            mean(abs((predict(mdl_CL, Xtrain)-ytrain)./ytrain))*100);
[y_pred, error] = evaluate_mdl_reg(mdl_CL, Xtest, ytest);