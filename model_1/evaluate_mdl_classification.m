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

error_loops = loops_test(y_pred ~= ytest, :);

figure;
i = 1;
while (i <= 9) && (i <= size(error_loops,1))
    subplot(3,3,i);
    plot(error_loops.x(i,:), error_loops.Ffr(i,:), 'b.');
    xlabel('Relative Displacement [\mu m]');
    if mod(i,3) == 1
        ylabel('Friction Force [N]');
    end

    if error_loops.slip(i)
        title('slip');
    else
        title('no slip');
    end
    
    i = i + 1;
end

end