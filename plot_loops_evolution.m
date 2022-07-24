function [] = plot_loops_evolution(loops)

n = size(loops, 1);
x = loops.x;
Ffr = loops.Ffr;
t = loops.t;

% plot the x vs. Ffr
figure;
for i = 1:n
    subplot(3,1,1)
    plot(x(i,:), Ffr(i,:));
    hold on;
    xlabel('Relative Displacement [\mu m]');
    ylabel('Friction Force [N]');
    
    subplot(3,1,2);
    plot(t(i,:),x(i,:));
    hold on
    ylabel('Relative Displacement [\mu m]');
    
    subplot(3,1,3);
    plot(t(i,:),Ffr(i,:));
    hold on
    xlabel('Time [s]');
    ylabel('Friction Force [N]');
end
