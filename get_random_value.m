function value = get_random_value(parameter,m)
%   get_random_value(parameter) returns m random values of a test parameter 
%   from a Gaussian mixture distribution. The mean and standard deviation
%   for each test parameter are estimated from the values used in past
%   experiments. The returned value is used to obtain a numerical
%   hysteresis loop that is close to real experimental condition for
%   further machine learning.

if parameter == "mu"
    mu = [0.8];  % mean
    sd = 0.2;    % standard deviation
    p = ones(1,length(m)) / length(m);
elseif parameter == "N"
    mu = [17; 87; 150; 253];
    sd = cat(5, 15, 20, 30, 30);
    p = [18 18 9 12];
elseif parameter == "kt"
    mu = [20; 60; 110; 300; 600; 1400];
    sd = cat(7, 5, 10, 20, 100, 150, 150);
    p = [19 15 3 7 8 5];
elseif parameter == "X"
    mu = [1; 4; 24.5; 50];
    sd = cat(5, 0.5, 4, 5, 10);
    p = [20 18 9 9];
else 
    error('invalid input parameter');
end

% Create the Gaussian Mixture Model
gmd = gmdistribution(mu,sd.^2,p);

value = abs(random(gmd,m));

end