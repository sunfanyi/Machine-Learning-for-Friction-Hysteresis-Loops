close all; clear variables;

f = 100;                       % excitation frequency [Hz]
N_cycles = 2;                  % number of cycles to generate
T = N_cycles/f;                % timelength of input [s]
cycle_points = 600;
t = linspace(0,T,N_cycles*cycle_points);

m = 16;
mu = get_random_value('mu',m);     % friction coefficient
N = get_random_value('N',m);       % normal load [N
CL = mu .* N;                      % Coulomb friction limit [N]
kt = get_random_value('kt',m);     % contact stiffness [N/mum]
X = get_random_value('X',m);       % Displ amplitude [mum]

x = X * sin(2*pi*f*t);             % excitation displ [mum]
v = diff(x,[],2) ./ diff(t);       % velocity signal

Ffr = Jenkins_element(kt,x,CL);

% plot the loops
figure
for i = 1:m
%     Ffr(i,:) = Jenkins_element(kt(i),x(i,:),CL(i));
    subplot(4,4,i)
    plot(x(i,:), Ffr(i,:), 'b.');
    hold on;
%     plot(x(i,:), Ffr(i,:), 'b-');
    yline(CL(i), '--r');
    yline(-CL(i), '--r');
    xlim([-max(X) max(X)]);
    ylim([-max(Ffr(:)) max(Ffr(:))]);
    xlabel('Relative Displacement [\mu m]');
    if mod(i,4) == 1
        ylabel('Friction Force [N]');
    end
end
    
% numerical_loops = table(mu,CL,kt,X,x,Ffr,'VariableNames',{'mu','CL','kt','X','x','Ffr'});
% save numerical_loops.mat numerical_loops;
