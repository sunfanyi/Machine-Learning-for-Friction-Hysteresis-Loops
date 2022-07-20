close all; clear variables;

m = 10000;
% random_value_generator = 'gmdistribution';
random_value_generator = 'uniform';
[mu, N, kt, X] = get_random_values(m, random_value_generator);
    
% Plot histograms
figure
subplot(2,2,1)
histogram(mu,100);
title('Friction coefficient \mu');

subplot(2,2,2)
histogram(N,100);
title('Normal load N');

subplot(2,2,3)
histogram(kt,100);
title('Contact stiffness kt');

subplot(2,2,4)
histogram(X,100);
title('Displacement amplitude X');