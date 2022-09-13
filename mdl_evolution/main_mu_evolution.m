close all;
clear variables;

load evoluation_mu_kt.mat

cd ..\experimental_data
load real_loops
cd ..\mdl_evolution
cp = 20;
loops = real_loops(real_loops.CP == cp,:);

mu_actual = real_loops.mu(real_loops.CP == cp);
mu_predicted = zeros(length(mu_actual),1);

% classification
pct_train = 0;
cd ..\mdl_loops
[~, loops_test, ~, ~, Xtest, ytest] = choose_features(loops, ...
                                            'slip', pct_train, false);

load mdl_classification.mat;
y_pred = predict(mdl_classification, Xtest);
        
slip_idx = (y_pred == 1);
loops_slip = loops_test(slip_idx,:);

% choose features
pct_train = 0;
[~, ~, ~, ~, Xtest, ~] = choose_features(loops_slip, ...
                                            'CL', pct_train, false);

% Prediction
load mdl_CL.mat;
CL = predict(mdl_CL, Xtest);
mu_predicted(slip_idx) = CL ./ loops_slip.N;

figure;
plot(mu_actual)
hold on;
plot(mu_predicted);
legend('mu\_actual','mu\_predicted');

cd ..\mdl_evolution