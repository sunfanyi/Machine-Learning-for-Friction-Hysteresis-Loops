% close all;
clear variables;

load real_loops.mat;
    
mu = real_loops.mu(real_loops.mu<10);
N = real_loops.N(real_loops.N ~= Inf);
kt = real_loops.kt(real_loops.kt < 500);
X = real_loops.X;

% Plot histograms
figure
subplot(2,2,1)
histogram(mu,100);
title('Friction coefficient \mu');

subplot(2,2,2)
histogram(N,100);
title('Normal load N');

subplot(2,2,3)
histogram(real_loops.kt,100);
title('Contact stiffness kt');

subplot(2,2,4)
histogram(X,100);
title('Displacement amplitude X');

mean(mu)
mean(kt)