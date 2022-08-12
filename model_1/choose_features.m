function [loops_train, loops_test, Xtrain, ytrain, Xtest, ytest] = ...
    choose_features(loops, response, pct_training)

m = size(loops,1);
idx = randperm(m);
% split testing and training set
loops_train = loops(idx(1:round(pct_training*m)),:);
loops_test = loops(idx(round(pct_training*m)+1:end),:);

if response == "kt"
    dFdx = diff(loops_train.Ffr,1,2) ./ diff(loops_train.x,1,2);
    dFdt = diff(loops_train.Ffr,1,2) ./ diff(loops_train.t,1,2);
    dxdt = diff(loops_train.x,1,2) ./ diff(loops_train.t,1,2);
    x_range = max(loops_train.x,[],2) - min(loops_train.x,[],2);
    Ffr_range = max(loops_train.Ffr,[],2) - min(loops_train.Ffr,[],2);
%     Xtrain = [loops_train.area./x_range loops_train.area./Ffr_range dFdx dFdt];
%     Xtrain = [loops_train.area./x_range loops_train.area./Ffr_range dFdx];
%     Xtrain = [loops_train.area x_range Ffr_range dFdx];
    Xtrain = [dFdx dFdt dxdt];
    ytrain = loops_train.kt;

    dFdx = diff(loops_test.Ffr,1,2) ./ diff(loops_test.x,1,2);
    dFdt = diff(loops_test.Ffr,1,2) ./ diff(loops_test.t,1,2);
    dxdt = diff(loops_test.x,1,2) ./ diff(loops_test.t,1,2);
    x_range = max(loops_test.x,[],2) - min(loops_test.x,[],2);
    Ffr_range = max(loops_test.Ffr,[],2) - min(loops_test.Ffr,[],2);
%     Xtest = [loops_test.area./x_range loops_test.area./Ffr_range dFdx dFdt];
%     Xtest = [loops_test.area./x_range loops_test.area./Ffr_range dFdx];
%     Xtest = [loops_test.area x_range Ffr_range dFdx];
    Xtest = [dFdx dFdt dxdt];
    ytest = loops_test.kt;
    
    [Xtrain, mu, sigma] = standardise_features(Xtrain);
    Xtest = (Xtest-mu)./sigma;
elseif response == "slip"
    x_range = max(loops_train.x,[],2) - min(loops_train.x,[],2);
    Ffr_range = max(loops_train.Ffr,[],2) - min(loops_train.Ffr,[],2);
    Xtrain = [loops_train.area./x_range loops_train.area./Ffr_range];
    ytrain = loops_train.slip;
    
    x_range = max(loops_test.x,[],2) - min(loops_test.x,[],2);
    Ffr_range = max(loops_test.Ffr,[],2) - min(loops_test.Ffr,[],2);
    Xtest = [loops_test.area./x_range loops_test.area./Ffr_range];
    ytest = loops_test.slip;
elseif response == "CL"
    x_range = max(loops_train.x,[],2) - min(loops_train.x,[],2);
    Ffr_range = max(loops_train.Ffr,[],2) - min(loops_train.Ffr,[],2);
%     Xtrain = [loops_train.Ffr Ffr_range loops_train.area./x_range loops_train.area./Ffr_range];
    Xtrain = [loops_train.Ffr];
    ytrain = loops_train.CL;
    
    x_range = max(loops_test.x,[],2) - min(loops_test.x,[],2);
    Ffr_range = max(loops_test.Ffr,[],2) - min(loops_test.Ffr,[],2);
%     Xtest = [loops_test.Ffr Ffr_range loops_test.area./x_range loops_test.area./Ffr_range];
    Xtest = [loops_test.Ffr];
    ytest = loops_test.CL;
end

% % normalise data
% [Xtrain, mu, sigma] = standardise_features(Xtrain);
% Xtest = (Xtest-mu)./sigma;

end