function [test_data] = extract_data()

x = zeros(34, 600);
Ffr = zeros(34, 600);

ktL = zeros(34,1);
ktR = zeros(34,1);
mu = zeros(34,1);

N = zeros(34,1);
X = zeros(34,1);
A_norm = zeros(34,1);
A_worn = zeros(34,1);

for cp = 1:34
    path = [pwd,'\..\Data Round Robin\steady state values\',num2str(cp),'.mat'];
    load(path);
    
    x(cp,:) = hyst(:,1);
    Ffr(cp,:) = hyst(:,2);
    
    n_kt = length(output.kL);
    n_mu = length(output.mu);
    % some are not really steady state, so choose a range
    if cp == 1
        ktL(cp) = mean(output.kL,'omitnan');
        ktR(cp) = mean(output.kR,'omitnan');
        mu(cp) = mean(output.mu(1100:n_mu),'omitnan');
    elseif cp == 5
        ktL(cp) = nan;
        ktR(cp) = nan;
        mu(cp) = nan;
    elseif cp == 6
        ktL(cp) = nan;
        ktR(cp) = nan;
        mu(cp) = nan;
    elseif cp == 7
        ktL(cp) = mean(output.kL(100:n_kt),'omitnan');
        ktR(cp) = mean(output.kR(100:n_kt),'omitnan');
        mu(cp) = mean(output.mu,'omitnan');
    elseif cp == 8
        ktL(cp) = mean(output.kL,'omitnan');
        ktR(cp) = mean(output.kR,'omitnan');
        temp = output.mu;
        mu(cp) = mean(temp((temp>0.5) & (temp<1)),'omitnan');
    elseif cp == 11
        ktL(cp) = mean(output.kL,'omitnan');
        ktR(cp) = mean(output.kR,'omitnan');
        temp = output.mu;
        mu(cp) = mean(temp(temp>0.5),'omitnan');
    elseif cp == 13
        ktL(cp) = mean(output.kL(1:80),'omitnan');
        ktR(cp) = mean(output.kR(1:80),'omitnan');
        mu(cp) = mean(output.mu(1:450),'omitnan');
    elseif cp == 17
        ktL(cp) = mean(output.kL,'omitnan');
        ktR(cp) = mean(output.kR,'omitnan');
        mu(cp) = 0;
    elseif cp == 20
        ktL(cp) = nan;
        ktR(cp) = nan;
        mu(cp) = nan;
    elseif cp == 22
        ktL(cp) = mean(output.kL(1:60),'omitnan');
        ktR(cp) = mean(output.kR(1:60),'omitnan');
        mu(cp) = mean(output.mu(1:350),'omitnan');
    elseif cp == 29
        ktL(cp) = mean(output.kL(1:100),'omitnan');
        ktR(cp) = ktL(cp);
        mu(cp) = mean(output.mu(1:300),'omitnan');
    elseif cp == 33
        ktL(cp) = mean(output.kL(1:40),'omitnan');
        ktR(cp) = mean(output.kR(1:40),'omitnan');
        mu(cp) = mean(output.mu(1:280),'omitnan');
    elseif cp == 34
        ktL(cp) = mean(output.kL(100:n_kt),'omitnan');
        ktR(cp) = mean(output.kR(100:n_kt),'omitnan');
        mu(cp) = mean(output.mu(200:n_mu),'omitnan');
    else
        ktL(cp) = mean(output.kL,'omitnan');
        ktR(cp) = mean(output.kR,'omitnan');
        mu(cp) = mean(output.mu,'omitnan');
    end
    
    N(cp) = input.Normal_Load_N;
    X(cp) = input.Sliding_displ_mum;
    A_norm(cp) = input.Nominal_Area_mm2;
    A_worn(cp) = input.Worn_Area_mm2;
end

kt = (ktL + ktR) / 2;
slip = single(mu ~= 0);

test_data = table(ktL, ktR, kt, mu, slip, N, X, A_norm, A_worn, x, Ffr, ...
            'VariableNames', ...
            {'ktL','ktR','kt','mu','slip','N','X','A_norm','A_worn','x','Ffr'});
test_data(isnan(test_data.kt),:) = [];

end