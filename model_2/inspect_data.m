clc;clear variables; close all;

cp = 34;
path = [pwd,'\..\Data Round Robin\steady state values\',num2str(cp),'.mat'];
load(path);

x = hyst(:,1);
Ffr = hyst(:,2);

ktL = output.kL;
ktR = output.kR;
mu = output.mu;
if length(ktL) < length(ktR)
    disp(length(ktL));
    disp(length(ktR));
    disp(length(mu));
    ktR = ktR(1:length(ktL));
elseif length(ktL) > length(ktR)
    disp(length(ktL));
    disp(length(ktR));
    disp(length(mu));
    ktL = ktL(1:length(ktR));
end
kt = (ktL + ktR) / 2;


% disp(length(ktL));
% disp(length(ktR));
% disp(length(mu));
    
figure();
    plot(x,Ffr);

figure();
    subplot(2,2,1);
    plot(ktL);
    yline(mean(ktL,'omitnan'),'--');
    title(['mean ktL = ',num2str(mean(ktL,'omitnan'))]);
    
    subplot(2,2,2);
    plot(ktR);
    yline(mean(ktR),'--');
    title(['mean ktR = ',num2str(mean(ktR,'omitnan'))]);

    subplot(2,2,3);
    plot(kt);
    yline(mean(kt,'omitnan'),'--');
    title(['mean ktL = ',num2str(mean(kt,'omitnan'))]);

    subplot(2,2,4);
    plot(mu);
    yline(mean(mu,'omitnan'),'--');
    title(['mean mu = ',num2str(mean(mu,'omitnan'))]);

    sgtitle(['CP',num2str(cp)]);




N = input.Normal_Load_N;
X = input.Sliding_displ_mum;
A_norm = input.Nominal_Area_mm2;
A_worn = input.Worn_Area_mm2;
