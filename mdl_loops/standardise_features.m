function [X_std, mu, sigma] = standardise_features(X)

mu = mean(X);
sigma = std(X);
X_std = (X-mu) ./ sigma;

end