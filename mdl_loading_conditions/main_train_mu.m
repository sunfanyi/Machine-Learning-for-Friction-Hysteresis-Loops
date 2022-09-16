clear variables; close all;

test_data = extract_data();
test_data(test_data.slip == 0, :) = [];

mean_mu = mean(test_data.mu);
fprintf('experimental mu scatter: %0.2f%%\n', 100*mean(abs(test_data.mu-mean_mu)/mean_mu));

m = size(test_data,1);

error_test = zeros(100,1);
error_train = zeros(100,1);
for i = 1:size(error_test,1)
    idx = randperm(m);
    % split testing and training set
    pct_training = 0.8;
    data_train = test_data(idx(1:round(pct_training*m)),:);
    data_test = test_data(idx(round(pct_training*m)+1:end),:);

    Xtrain = [data_train.N data_train.X data_train.A_norm];
    ytrain = data_train.mu;
    Xtest = [data_test.N data_test.X data_test.A_norm];
    ytest = data_test.mu;

    mdl = fitrnet(Xtrain,ytrain,'Standardize',true);

    y_pred = predict(mdl, Xtest);
    error_test(i) = mean(abs(y_pred-ytest)./ytest)*100;

    y_pred = predict(mdl, Xtrain);
    error_train(i) = mean(abs(y_pred-ytrain)./ytrain)*100;
end

fprintf('Input: Load | Displacement | Nominal area -> Avg test error =  %0.2f%%\n',mean(error_test));
fprintf('Input: Load | Displacement | Nominal area -> Avg train error =  %0.2f%%\n\n',mean(error_train));
