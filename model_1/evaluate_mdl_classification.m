function [error_loops] = evaluate_mdl_classification(mdl, Xtrain, ...
                                    ytrain, Xtest, ytest, loops_test)

% if ~mdl.ConvergenceInfo.Converged
%     fprintf('not convergent\n');
% else
%     fprintf('convergent\n');
% end

y_pred = predict(mdl, Xtest);
if ~isnan(Xtrain)
    fprintf('Training Accuracy: %0.2f%% | ', ...
                mean(predict(mdl, Xtrain) == ytrain)*100)
end
fprintf('Test Accuracy : %0.2f%% | Failures: %d over %d\n\n', ...
        mean(y_pred == ytest)*100, ...
        mean(y_pred ~= ytest)*size(ytest,1), size(ytest,1));

error_idx = find(y_pred ~= ytest);
error_loops = loops_test(error_idx, :);

figure;
if length(error_idx) > 9
    error_idx = randsample(error_idx, 9);
end

for i = 1:length(error_idx)
    subplot(3,3,i);
    plot(loops_test.x(error_idx(i),:), loops_test.Ffr(error_idx(i),:), 'b.');
    xlabel('Relative Displacement [\mu m]');
    if mod(i,3) == 1
        ylabel('Friction Force [N]');
    end

    if loops_test.slip(error_idx(i))
        title(sprintf('%d: slip', error_idx(i)));
    else
        title(sprintf('%d: stick', error_idx(i)));
    end
end

end