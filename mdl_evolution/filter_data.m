function [mu_filtered, kt_filtered, t_filtered] = filter_data(data, display)
t = data(:,1);
mu = data(:,2);
kt = data(:,3);
    
% Outlier removal using Hampel identifier
% filter after the 1000th loops
mu_hampeled = [mu(1:1000);hampel(mu(1001:end),500,1)];
kt_hampeled = [kt(1:1000);hampel(kt(1001:end),500,1)];
    
% Moving-average filter for noisy data
windowSize = 5; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
mu_filtered = filter(b, a, mu_hampeled);
kt_filtered = filter(b, a, kt_hampeled);

nan_idx = isnan(mu_filtered) | isnan(kt_filtered);
mu_filtered(nan_idx) = [];
kt_filtered(nan_idx) = [];
t_filtered = t(~nan_idx);

if display
figure();
subplot(2,1,1);
    plot(t, mu, '-o','MarkerSize',3);
    hold on;
%     plot(t(1:1000), mu(1:1000), 'x','MarkerSize',3);
    xlabel('time(s)');
    ylabel('mu');
    
subplot(2,1,2);
    plot(t, kt, '-o','MarkerSize',3);
    hold on;
%     plot(t(1:1000), kt(1:1000), 'x','MarkerSize',3);
    xlabel('time(s)');
    ylabel('kt');
    
figure();
subplot(2,1,1);
    plot(t, mu_hampeled, '-o','MarkerSize',3);
    xlabel('time(s)');
    ylabel('mu\_hampeled');
    
subplot(2,1,2);
    plot(t, kt_hampeled, '-o','MarkerSize',3);
    xlabel('time(s)');
    ylabel('kt\_hampeled');
    
figure();
subplot(2,1,1);
    plot(t_filtered, mu_filtered, '-o','MarkerSize',3);
    xlabel('time(s)');
    ylabel('mu\_filtered');
    
subplot(2,1,2);
    plot(t_filtered, kt_filtered, '-o','MarkerSize',3);
    xlabel('time(s)');
    ylabel('kt\_filtered');
end

end