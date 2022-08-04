function [numerical_loops] = create_loops(fex, N_cycles, cycle_points, ...
            m, noise, random_value_generator, training_cycles)
%CREATE_LOOPS generates numerical hysteresis loops for friction parameters.
%   create_loops(fex, N_cycles, cycle_points, m, random_value_generator,
%   training_cycles) returns the information of m numerical hysteresis
%   loops each consist of N_cycles of cycles with random friction
%   parameters, which can be used for further machine learning. 
%
%   fex is the excitation frequency [Hz]
%
%   cycle_points is the number of points each cycle has
%
%   noise is a logical variable specifying whether random noise are added
%   to the numerical loops. The random noise are extracted from the real
%   experimental loops by FFT.
%
%   training_cycles specifies the cycles to be extracted from
%   the evolution of the hysteresis loops, e.g., [2:4] will extract the
%   second to fourth cycles. 
%
%   randon_value_generator is the 
%   distribution used to generate random values, which can be:  
%      'gmdistribution'   The values are from a Gaussian mixture
%                         distribuition. The mean and standard deviation
%                         for each test parameter are estimated from the
%                         values used in past experiments. So the
%                         returned values can be used to obtain
%                         hysteresis loops that are close to the real
%                         experimentl condition.

% set default values
if ~exist('f', 'var') || isempty(fex)
    fex = 100;
end

if ~exist('N_cycles', 'var') || isempty(N_cycles)
    N_cycles = 2;
end

if ~exist('cycle_points', 'var') || isempty(cycle_points)
    cycle_points = 600;
end

if ~exist('m', 'var') || isempty(m)
    m = 1000;
end

if ~exist('noise', 'var') || isempty(noise)
    noise = false;
end

if ~exist('random_value_generator', 'var') || isempty(random_value_generator)
    random_value_generator = 'gmdistribution';
end

if ~exist('training_cycles', 'var') || isempty(training_cycles)
    training_cycles = N_cycles;  % last cycle only
end

T = 1/fex;       % period [s]
t = linspace(0, N_cycles*T - T/cycle_points, N_cycles*cycle_points);
t = repmat(t, m, 1);  % for now each loop has same time signal

[mu, N, kt, X] = get_random_values(m, random_value_generator);
CL = mu .* N;         % Coulomb friction limit [N]

x = X .* sin(2*pi*fex*t);             % excitation displ [mum]
v = diff(x,[],2) ./ diff(t,[],2);       % velocity signal

Ffr_offset = false;
[Ffr, mu, E] = Jenkins_element(kt, x, CL, mu, Ffr_offset);
slip = single(mu ~= 0);

idx = (training_cycles(1)-1)*cycle_points + 1 : training_cycles(end)*cycle_points;
x = x(:,idx);
Ffr = Ffr(:,idx);
t = t(:,idx);

if noise == "fft"
    parameters = [mu N kt X];
    Ffr = add_noise_fft(Ffr, parameters, slip);
    cd ..\experimental_data
    Ffr = make_periodic(Ffr);
    cd ..\create_numerical_loops
% else if noise == "normaldist"
end
area = polyarea(x, Ffr, 2)*10^(-6);  % area after noise is added

numerical_loops = table(mu, N, CL, kt, area, slip, E, X, x, Ffr, t, ...
                'VariableNames',...
                {'mu','N','CL','kt','area','slip','E','X','x','Ffr','t'});

end