function F = Jenkins_element(kt,x,CL)

F = zeros(size(x));
slip = zeros(size(x,1),1);

% pct_chattering = rand(size(x,1),1) - 0.5;
% pct_chattering = zeros(size(x,1),1);

for t = 1:size(x,2)
    F(:,t) = kt .* (x(:,t) - slip);
%     F_temp = F(:,t);

    % the loops which CL is reached at t:
    idx = abs(F(:,t)) > CL;
    
    F(idx,t) = (CL(idx) .* sign(F(idx,t)));
    slip(idx) = (x(idx,t) - F(idx,t)./kt(idx));
    
    % add chattering
%     F(:,t) = F_temp + F_temp * (rand()*pct_chattering);
%     F(:,t) = F_temp;
end

end

% function F = Jenkins_element(kt,x,CL)
% 
% slip = 0;
% for t = 1:length(x)
%     F(t) = kt * (x(t)-slip);
%     if abs(F(t)) > CL
%         F(t) = CL * sign(F(t));
%         slip = x(t)-F(t)/kt;
%     end
% end
