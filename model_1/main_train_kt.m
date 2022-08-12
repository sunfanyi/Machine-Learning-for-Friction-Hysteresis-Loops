clear variables;

%% load data
close all; 

fex = 100;  % excitation frequency (Hz)
N_cycles = 2;
cycle_points = 600;
m = 3000;
noise = 'fft';
% random_value_generator = 'gmdistribution';
random_value_generator = 'uniform';
% random_value_generator = 'more_stick';
training_cycles = N_cycles;

cd ..\create_numerical_loops
numerical_loops = create_loops(fex, N_cycles, cycle_points, m, noise, ...
    random_value_generator, training_cycles);
loops = numerical_loops;

fprintf('%0.2f%%\n',nnz(loops.slip==0)/size(loops,1)*100);

% cd ..\experimental_data
% load real_loops.mat;
% loops = real_loops;

cd ..
normalise = false;
idx = randperm(m, 16);
plot_loops_individual(loops(idx,:), normalise);
cd model_1

%% classification
pct_train = 0;
[~, loops_test, ~, ~, Xtest, ytest] = choose_features(loops, ...
                                            'slip', pct_train);
                                        
load mdl_classification.mat;
y_pred = predict(mdl_classification, Xtest);
fprintf('Percentage of loops correctly classified: %0.2f%%\n', ...
            mean(y_pred == ytest)*100);
        
loops_slip = loops_test(y_pred == 1,:);
loops_stick = loops_test(y_pred == 0,:);
fprintf('Number of slip: %d | Number of stick: %d\n\n', ...
                            size(loops_slip, 1), size(loops_stick, 1));

%% (slip) choose features
pct_train = 0.8;
[~, loops_test, Xtrain, ytrain, Xtest, ytest] = choose_features(loops_slip, ...
                                            'kt', pct_train);

%% (slip) Train models
rng('default');
% mdl_kt_slip = fitrsvm(Xtrain, ytrain,...
%             'Standardize', false, ...
%             'OptimizeHyperparameters',{'KernelFunction', 'KernelScale', 'BoxConstraint', 'Epsilon'},...
%             'HyperparameterOptimizationOptions',...
%             struct('AcquisitionFunctionName','expected-improvement-plus'))
mdl_kt_slip = fitrsvm(Xtrain, ytrain,...
            'RemoveDuplicates', false, ...
            'Standardize', false, ...
            'KernelFunction', 'gaussian', ...
            'OptimizeHyperparameters', {'KernelScale', 'BoxConstraint', 'Epsilon'},...
            'HyperparameterOptimizationOptions',...
            struct('AcquisitionFunctionName','expected-improvement-plus'))
                    
%% (slip) Evaluate model performance
fprintf('\n========== slip ==========\n');
fprintf('Training error: %0.2f%%\n', ...
            mean(abs((predict(mdl_kt_slip, Xtrain)-ytrain)./ytrain))*100);
[y_pred_slip, error_slip] = evaluate_mdl_reg(mdl_kt_slip, Xtest, ytest);
title('Slip');


%% (stick) choose features
% pct_train = 0.8;
% [~, ~, Xtrain, ytrain, Xtest, ytest] = choose_features(loops_stick, ...
%                                             'kt', pct_train);
% 
% %% (stick) Train models
% rng('default');
% % mdl_kt_slip = fitrsvm(Xtrain,ytrain,...
% %             'OptimizeHyperparameters','all',...
% %             'HyperparameterOptimizationOptions',...
% %             struct('AcquisitionFunctionName','expected-improvement-plus'))
% mdl_kt_stick = fitrsvm(Xtrain, ytrain,...
%             'RemoveDuplicates', false, ...
%             'KernelScale', 'auto', ...
%             'Standardize', true, ...
%             'KernelFunction', 'linear', ...
%             'OptimizeHyperparameters',{'BoxConstraint', 'Epsilon'},...
%             'HyperparameterOptimizationOptions',...
%             struct('AcquisitionFunctionName','expected-improvement-plus'))
%                     
% %% (stick) Evaluate model performance
% fprintf('\n========== stick ==========\n');
% fprintf('Training error: %0.2f%%\n', ...
%             mean(abs((predict(mdl_kt_stick, Xtrain)-ytrain)./ytrain))*100);
% [y_pred_stick, error_stick] = evaluate_mdl_kt(mdl_kt_stick, Xtest, ytest);
% title('stick');

