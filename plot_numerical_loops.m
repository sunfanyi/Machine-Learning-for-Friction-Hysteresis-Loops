function [] = plot_numerical_loops(f, N_cycles, cycle_points, ...
            random_value_generator, training_cycles)

m = 16;
numerical_loops = create_loops(f, N_cycles, cycle_points, ...
            m, random_value_generator, training_cycles);
x = numerical_loops.x;
Ffr = numerical_loops.Ffr;
CL = numerical_loops.CL;
X = numerical_loops.X;

% plot the loops
figure
for i = 1:m
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
