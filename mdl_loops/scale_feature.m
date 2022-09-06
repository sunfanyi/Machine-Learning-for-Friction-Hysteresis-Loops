function [x_norm, scale_factor] = scale_feature(x)

scale_factor = max(x,[],2) - min(x,[],2);
x_norm = (x - min(x,[],2)) ./ scale_factor;

end