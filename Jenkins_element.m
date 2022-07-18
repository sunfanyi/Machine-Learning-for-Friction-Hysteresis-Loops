function [F] = Jenkins_element(kt,x,CL)

F = zeros(size(x));
slip = zeros(size(x,1),1);

% pct_chattering = 0.2*rand(size(x,1),1) + 0.9;

for t = 1:size(x,2)
    F(:,t) = kt .* (x(:,t) - slip);

    % the loops which CL is reached at t:
    idx = abs(F(:,t)) > CL;

    F(idx,t) = (CL(idx) .* sign(F(idx,t)));
    slip(idx) = (x(idx,t) - F(idx,t)./kt(idx));

    % add chattering
%     F(idx,t) = F(idx,t).*(abs(1+0.1*randn(nnz(idx),1)).*pct_chattering(idx));
end

end

% visualise the chattering distribution:
% hist((0.9+0.2*rand(5000,1)).*abs(1+0.1*randn(5000,1)),100)





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
