function [X_norm, mu, sigma] = normalise_features(X)

mu = mean(X);
sigma = std(X);
X_norm = (X-mu) ./ sigma;

end