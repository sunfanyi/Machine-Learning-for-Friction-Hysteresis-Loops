clear variables;

%% load data
close all;

fex = 100;  % excitation frequency (Hz)
N_cycles = 2;
cycle_points = 600;
m = 5000;
noise = 'fft';
random_value_generator = 'more_stick';
training_cycles = N_cycles;

cd ..\create_numerical_loops
numerical_loops = create_loops(fex, N_cycles, cycle_points, m, noise, ...
    random_value_generator, training_cycles);

cd ..\experimental_data
load real_loops.mat;

% Use numerical loops + real loops as the training set
loops = outerjoin(numerical_loops, real_loops, 'MergeKeys', true);

fprintf('%0.2f%%\n',nnz(loops.slip==0)/size(loops,1));

pct_train = 0.8;
[~, loops_test, Xtrain, ytrain, Xtest, ytest] = choose_features(loops, ...
                        "slip", pct_train);

%% Training
rng('default');
mdl_classification = fitcsvm(Xtrain, ytrain,...
            'Standardize', true, ...
            'KernelFunction', 'gaussian', ...
            'OptimizeHyperparameters',{'BoxConstraint','KernelScale'},...
            'HyperparameterOptimizationOptions',...
            struct('AcquisitionFunctionName','expected-improvement-plus'))
        
% save mdl_classification.mat mdl_classification
%% Evaluate model performance
fprintf('Training Accuracy: %0.2f%%\n\n ', ...
            mean(predict(mdl_classification, Xtrain) == ytrain)*100);
        
fprintf('Accuracy on testing set:\n');
error_loops_test = evaluate_mdl_classification(mdl_classification, ...
                        Xtest, ytest, loops_test);
sgtitle('misclassification in testing set');
                            
% try predicting experimental loops
x_range = max(real_loops.x,[],2) - min(real_loops.x,[],2);
Ffr_range = max(real_loops.Ffr,[],2) - min(real_loops.Ffr,[],2);
X_real = [real_loops.area./x_range real_loops.area./Ffr_range];
y_real = real_loops.slip;

fprintf('Accuracy on experimental loops:\n');
error_loops_real = evaluate_mdl_classification(mdl_classification, ...
                    X_real, y_real, real_loops);
sgtitle('misclassification in real loops');

% try predicting numerical loops
x_range = max(numerical_loops.x,[],2) - min(numerical_loops.x,[],2);
Ffr_range = max(numerical_loops.Ffr,[],2) - min(numerical_loops.Ffr,[],2);
X_numerical = [numerical_loops.area./x_range numerical_loops.area./Ffr_range];
y_numerical = numerical_loops.slip;

fprintf('Accuracy on numerical loops:\n');
error_loops_numerical = evaluate_mdl_classification(mdl_classification, ...
                    X_numerical, y_numerical, numerical_loops);
sgtitle('misclassification in numerical loops');