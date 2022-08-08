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

%% choose features for training
x_range = max(loops.x,[],2) - min(loops.x,[],2);
Ffr_range = max(loops.Ffr,[],2) - min(loops.Ffr,[],2);
X = [loops.area./x_range loops.area./Ffr_range];  % predictor

y = loops.slip;  % response

m = size(X,1);
pct = 0.8;  % percentage training set
idx = randperm(m);
Xtrain = X(idx(1:round(pct*m)),:);
ytrain = y(idx(1:round(pct*m)),:);
Xtest = X(idx(round(pct*m)+1:end),:);
ytest = y(idx(round(pct*m)+1:end),:);
loops_test = loops(idx,:);

%% Training
rng('default');
classification_mdl = fitcsvm(Xtrain, ytrain,...
            'Standardize', true, ...
            'KernelFunction', 'gaussian', ...
            'OptimizeHyperparameters',{'BoxConstraint','KernelScale'},...
            'HyperparameterOptimizationOptions',...
            struct('AcquisitionFunctionName','expected-improvement-plus'))

% save classification_mdl.mat classification_mdl
%% Evaluate model performance
fprintf('Accuracy on test set:\n');
error_loops_test = evaluate_mdl_classification(classification_mdl, ...
                        Xtrain, ytrain, Xtest, ytest, loops_test);
sgtitle('misclassification in test set');
                            
% try predicting experimental loops
x_range = max(real_loops.x,[],2) - min(real_loops.x,[],2);
Ffr_range = max(real_loops.Ffr,[],2) - min(real_loops.Ffr,[],2);
X_real = [real_loops.area./x_range real_loops.area./Ffr_range];
y_real = real_loops.slip;

fprintf('Accuracy on experimental loops:\n');
error_loops_real = evaluate_mdl_classification(classification_mdl, ...
                    nan, nan, X_real, y_real, real_loops);
sgtitle('misclassification in real loops');

% try predicting numerical loops
x_range = max(numerical_loops.x,[],2) - min(numerical_loops.x,[],2);
Ffr_range = max(numerical_loops.Ffr,[],2) - min(numerical_loops.Ffr,[],2);
X_numerical = [numerical_loops.area./x_range numerical_loops.area./Ffr_range];
y_numerical = numerical_loops.slip;

fprintf('Accuracy on numerical loops:\n');
error_loops_numerical = evaluate_mdl_classification(classification_mdl, ...
                    nan, nan, X_numerical, y_numerical, numerical_loops);
sgtitle('misclassification in numerical loops');