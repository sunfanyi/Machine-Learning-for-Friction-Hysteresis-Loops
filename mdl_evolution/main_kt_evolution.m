close all;
clear variables;

load evoluation_mu_kt.mat

cd ..\experimental_data
load real_loops
cd ..\mdl_evolution
cp = 10;
loops = real_loops(real_loops.CP == cp,:);

kt_actual = real_loops.kt(real_loops.CP == cp);
kt_predicted = zeros(length(kt_actual),1);

% classification
pct_train = 0;
cd ..\mdl_loops
[~, loops_test, ~, ~, Xtest, ytest] = choose_features(loops, ...
                                            'slip', pct_train, false);

load mdl_classification.mat;
y_pred = predict(mdl_classification, Xtest);
        
slip_idx = (y_pred == 1);
stick_idx = (y_pred == 0);
loops_slip = loops_test(slip_idx,:);
loops_stick = loops_test(stick_idx,:);

% ****************** slip ***********************
% choose features
pct_train = 0;
[~, ~, ~, ~, Xtest, ~] = choose_features(loops_slip, ...
                                            'kt_slip', pct_train, false);
% Prediction
load mdl_kt_slip.mat;
kt_predicted(slip_idx) = predict(mdl_kt_slip, Xtest);

% ****************** slip ***********************
% choose features
pct_train = 0;
[~, ~, ~, ~, Xtest, ~] = choose_features(loops_stick, ...
                                            'kt_stick', pct_train, false);
% Prediction
load mdl_kt_stick.mat;
kt_predicted(stick_idx) = predict(mdl_kt_stick, Xtest);

figure;
plot(kt_actual)
hold on;
plot(kt_predicted);
legend('kt\_actual','kt\_predicted');

cd ..\mdl_evolution