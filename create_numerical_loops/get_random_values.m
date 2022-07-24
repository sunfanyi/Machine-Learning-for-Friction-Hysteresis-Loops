function [mu, N, kt, X] = get_random_values(m, random_value_generator)
%GET_RANDOM_VALUES generates random values for friction parameters.
%   get_random_values(m, random_value_generator) returns m random values
%   for each output parameter. The returned values are used to obtain
%   numerical hysteresis loops for further machine learning.
%   randon_value_generator is the distribution used to generate random
%   values, which can be:
%      'gmdistribution'   The values are from a Gaussian mixture
%                         distribuition. The mean and standard deviation
%                         for each test parameter are estimated from the
%                         values used in past experiments. So the
%                         returned values can be used to obtain
%                         hysteresis loops that are close to the real
%                         experimentl condition.

if random_value_generator == "gmdistribution"        
    % friction coefficient mu
    mean = [0.9];  % mean
    sd = 0.2;    % standard deviation
    p = ones(1,length(mean)) / length(mean);
    gmd = gmdistribution(mean,sd.^2,p);  % Create the Gaussian Mixture Model
    mu = abs(random(gmd,m));
    
    % normal load N [N]
    mean = [17; 87; 150; 253];
    sd = cat(5, 15, 20, 30, 30);
    p = [18 18 9 12];    
    gmd = gmdistribution(mean,sd.^2,p);
    N = abs(random(gmd,m));
    
    % contact stiffness kt [N/mum]
    mean = [20; 60; 110; 300; 600; 1400];
    sd = cat(7, 5, 10, 20, 100, 150, 150);
    p = [19 15 3 7 8 5];      
    gmd = gmdistribution(mean,sd.^2,p);
    kt = abs(random(gmd,m));
    
    % Displ amplitude X [mum]
    mean = [1; 4; 24.5; 50];
    sd = cat(5, 0.5, 4, 5, 10);
    p = [20 18 9 9];
    gmd = gmdistribution(mean,sd.^2,p);
    X = abs(random(gmd,m));
elseif random_value_generator == "uniform"
    % friction coefficient mu
    interval = [0.2 1.8];
    mu = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
    
    % normal load N [N]
    interval = [10 400];
    N = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
    
    % contact stiffness kt [N/mum]
    interval = [5 2000];
    kt = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
    
    % Displ amplitude X [mum]
    interval = [0.1 100];
    X = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
end

end