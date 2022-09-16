function [mu, N, kt, X] = get_random_values(m, random_value_generator)
%GET_RANDOM_VALUES generates random values for friction parameters.
%   get_random_values(m, random_value_generator) returns m random values
%   for each output parameter. The returned values are used to obtain
%   numerical hysteresis loops for further machine learning.
%
%   randon_value_generator is the distribution used to generate random
%   values, which can be:
%      'gmdistribution'   The values are from a Gaussian mixture
%                         distribuition. The mean and standard deviation
%                         for each test parameter are estimated from the
%                         values used in past experiments. So the
%                         returned values can be used to obtain
%                         hysteresis loops that are close to the real
%                         experimentl condition.
%      'uniform'          The values are from a uniform distribution. The
%                         values are from a range with constant
%                         probabilities. 
%      'more_stick'       The values are half-random but they are generated
%                         in a way with more loops in stick regime.

if random_value_generator == "gmdistribution"        
    % friction coefficient mu
    mean = [0.67];  % mean
    sd = 0.2;    % standard deviation
    p = ones(1,length(mean)) / length(mean);
    gmd = gmdistribution(mean,sd.^2,p);  % Create the Gaussian Mixture Model
    mu = abs(random(gmd,m));
    
    % normal load N [N]
    mean = [17; 87; 150; 253];
    sd = cat(5, 5, 20, 30, 30);
    p = [18 18 9 3];    
    gmd = gmdistribution(mean,sd.^2,p);
    N = abs(random(gmd,m));
    
    % contact stiffness kt [N/mum]
    mean = [50; 170];
    sd = cat(7, 40, 60);
    p = [19 3];      
    gmd = gmdistribution(mean,sd.^2,p);
    kt = abs(random(gmd,m));
    
    % Displ amplitude X [mum]
    mean = [1; 4; 14; 24.5];
    sd = cat(5, 0.5, 2, 3, 5);
    p = [20 18 20 20];
    gmd = gmdistribution(mean,sd.^2,p);
    X = abs(random(gmd,m));
elseif random_value_generator == "uniform"
    % friction coefficient mu
    interval = [0.2 2];
    mu = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
    
    % normal load N [N]
    interval = [10 300];
    N = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
    
    % contact stiffness kt [N/mum]
    interval = [5 200];
    kt = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
    
    % Displ amplitude X [mum]
    interval = [0.1 30];
    X = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
elseif random_value_generator == "more_stick"
    % friction coefficient mu
%     mean = [0.8];  % mean
%     sd = 0.3;    % standard deviation
%     p = ones(1,length(mean)) / length(mean);
%     gmd = gmdistribution(mean,sd.^2,p);  % Create the Gaussian Mixture Model
%     mu = abs(random(gmd,m));
    interval = [0.2 2];
    mu = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
    
    % normal load N [N]
%     mean = [17; 87; 150; 253];
%     sd = cat(5, 5, 20, 30, 30);
%     p = [9 9 20 30];    
%     gmd = gmdistribution(mean,sd.^2,p);
%     N = abs(random(gmd,m));
    interval = [10 300];
    N = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
    
    % contact stiffness kt [N/mum]
    mean = [50; 170];
    sd = cat(7, 40, 60);
    p = [19 3];      
    gmd = gmdistribution(mean,sd.^2,p);
    kt = abs(random(gmd,m));
    
    % Displ amplitude X [mum]
    mean = [1; 4; 14; 24.5];
    sd = cat(5, 0.5, 2, 3, 5);
    p = [20 20 10 5];
    gmd = gmdistribution(mean,sd.^2,p);
    X = abs(random(gmd,m));
%     interval = [0.1 30];
%     X = interval(1) + (interval(2)-interval(1)) .* rand(m,1);
end

end