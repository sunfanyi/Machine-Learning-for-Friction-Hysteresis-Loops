function [y_pred, error] = evaluate_mdl_reg(mdl, Xtest, ytest)

if ~mdl.ConvergenceInfo.Converged
    disp('!!!!!!!!!!!!!Not convergent');
else
    fprintf('Convergent with %d iterations.\n', mdl.NumIterations);
end

y_pred = predict(mdl, Xtest);
error = (y_pred-ytest)./ytest;

figure;
% randomly choose n samples to display
n = 30;
smp_idx = randi(length(y_pred),[n,1]);
plot(y_pred(smp_idx,:),'bx-');
hold on;
plot(ytest(smp_idx,:),'kx-');
% plot([1:n; 1:n], [ytest(smp_idx,:) y_pred(smp_idx,:)]','r');
legend('predicted','actual');
[max_error, idx] = max(abs(error));
error_msg = sprintf('mean error: %0.2f%%, highest error: %0.2f%% at %0.0f%th', ...
            100*mean(abs(error)), 100*max_error, idx);
disp(error_msg);
title(error_msg);

figure;
plot(error,'x');

fprintf('total elapsed time: %0.0f\n',mdl.HyperparameterOptimizationResults.TotalElapsedTime);

end
