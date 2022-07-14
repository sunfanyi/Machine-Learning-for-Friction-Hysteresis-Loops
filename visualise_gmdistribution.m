close all; clear variables;

% Plot histograms
figures

subplot(2,2,1)
value = get_random_value('mu',10000);
histogram(value,100);
title('Friction coefficient \mu');

subplot(2,2,2)
value = get_random_value('N',10000);
histogram(value,100);
title('Normal load N');

subplot(2,2,3)
value = get_random_value('kt',10000);
histogram(value,100);
title('Contact stiffness kt');

subplot(2,2,4)
value = get_random_value('X',10000);
histogram(value,100);
title('Displacement amplitude X');