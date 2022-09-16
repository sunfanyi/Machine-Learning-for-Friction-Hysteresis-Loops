close all;
clear variables;

load evoluation_mu_kt.mat

cp = 2;
data = eval(sprintf('cp%d',cp));
display = true;
[mu_filtered, kt_filtered, t] = filter_data(data, display);


subplot(2,1,1);
t_ss = 1300;  % time when mu reaches the steady state
range1 = 5;
range2 = t_ss/10;
xline(t_ss,'r--');
c1 = corrcoef(mu_filtered(t < range1), kt_filtered(t < range1));
disp(c1(1,2))
c2 = corrcoef(mu_filtered(t < range2 & t > range1), kt_filtered(t < range2 & t > range1));
disp(c2(1,2))
c3 = corrcoef(mu_filtered(t < t_ss & t > range2), kt_filtered(t < t_ss & t > range2));
disp(c3(1,2))

title(sprintf('cp%d => 0<t<%d: c = %0.2f | %d<t<%d: c = %0.2f | %d<t<%d: c = %0.2f',...
    cp, range1, c1(1,2), range1, range2, c2(1,2), range2, t_ss, c3(1,2)));