close all;
clear variables;

load evoluation_mu_kt.mat

cp = 3;
data = eval(sprintf('cp%d',cp));
display = true;
[mu_filtered, kt_filtered] = filter_data(data, display);