function [] = plot_numerical_loops(numerical_loops)

numerical_loops = numerical_loops(1:16,:);
x = numerical_loops.x;
Ffr = numerical_loops.Ffr;
CL = numerical_loops.CL;
X = numerical_loops.X;

% plot the loops
figure
for i = 1:16
    subplot(4,4,i)
    plot(x(i,:), Ffr(i,:), 'b.');
    hold on;
    yline(CL(i), '--r');
    yline(-CL(i), '--r');
    xlim([-max(X) max(X)]);
    ylim([-max(Ffr(:)) max(Ffr(:))]);
    xlabel('Relative Displacement [\mu m]');
    if mod(i,4) == 1
        ylabel('Friction Force [N]');
    end
end

end
