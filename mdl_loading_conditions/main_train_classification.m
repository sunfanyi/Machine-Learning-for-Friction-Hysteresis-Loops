clear variables; close all;

test_data = extract_data();
m = size(test_data,1);
pct_training = 0.8;

%% Input: Load | Displacement | Nominal area
acc = zeros(100,1);
for i = 1:size(acc,1)
    idx = randperm(m);
    % split testing and training set
    data_train = test_data(idx(1:round(pct_training*m)),:);
    data_test = test_data(idx(round(pct_training*m)+1:end),:);

    Xtrain = [data_train.N data_train.X data_train.A_norm];
    ytrain = data_train.slip;
    Xtest = [data_test.N data_test.X data_test.A_norm];
    ytest = data_test.slip;

    mdl = fitcnet(Xtrain,ytrain,'Standardize',true);

    y_pred = predict(mdl, Xtest);
    acc(i) = mean(y_pred == ytest)*100;
end
fprintf('Input: Load | Displacement | Nominal area -> Avg accuracy =  %0.2f%%\n',mean(acc));

%% Input: Load | Displacement
acc = zeros(100,1);
for i = 1:size(acc,1)
    idx = randperm(m);
    % split testing and training set
    data_train = test_data(idx(1:round(pct_training*m)),:);
    data_test = test_data(idx(round(pct_training*m)+1:end),:);

    Xtrain = [data_train.N data_train.X];
    ytrain = data_train.slip;
    Xtest = [data_test.N data_test.X];
    ytest = data_test.slip;

    mdl = fitcnet(Xtrain,ytrain,'Standardize',true);

    y_pred = predict(mdl, Xtest);
    acc(i) = mean(y_pred == ytest)*100;
end
fprintf('Input: Load | Displacement -> Avg accuracy =  %0.2f%%\n',mean(acc));

%% Input: Load | Nominal area
acc = zeros(100,1);
for i = 1:size(acc,1)
    idx = randperm(m);
    % split testing and training set
    data_train = test_data(idx(1:round(pct_training*m)),:);
    data_test = test_data(idx(round(pct_training*m)+1:end),:);

    Xtrain = [data_train.N data_train.A_norm];
    ytrain = data_train.slip;
    Xtest = [data_test.N data_test.A_norm];
    ytest = data_test.slip;

    mdl = fitcnet(Xtrain,ytrain,'Standardize',true);

    y_pred = predict(mdl, Xtest);
    acc(i) = mean(y_pred == ytest)*100;
end
fprintf('Input: Load | Nominal area -> Avg accuracy =  %0.2f%%\n',mean(acc));

%% Input: Displacement | Nominal area
acc = zeros(100,1);
for i = 1:size(acc,1)
    idx = randperm(m);
    % split testing and training set
    data_train = test_data(idx(1:round(pct_training*m)),:);
    data_test = test_data(idx(round(pct_training*m)+1:end),:);

    Xtrain = [data_train.X data_train.A_norm];
    ytrain = data_train.slip;
    Xtest = [data_test.X data_test.A_norm];
    ytest = data_test.slip;

    mdl = fitcnet(Xtrain,ytrain,'Standardize',true);

    y_pred = predict(mdl, Xtest);
    acc(i) = mean(y_pred == ytest)*100;
end
fprintf('Input: Displacement | Nominal area -> Avg accuracy =  %0.2f%%\n',mean(acc));

%% Input: Displacement
acc = zeros(100,1);
for i = 1:size(acc,1)
    idx = randperm(m);
    % split testing and training set
    data_train = test_data(idx(1:round(pct_training*m)),:);
    data_test = test_data(idx(round(pct_training*m)+1:end),:);

    Xtrain = [data_train.X];
    ytrain = data_train.slip;
    Xtest = [data_test.X];
    ytest = data_test.slip;

    mdl = fitcnet(Xtrain,ytrain,'Standardize',true);

    y_pred = predict(mdl, Xtest);
    acc(i) = mean(y_pred == ytest)*100;
end
fprintf('Input: Displacement -> Avg accuracy =  %0.2f%%\n',mean(acc));
