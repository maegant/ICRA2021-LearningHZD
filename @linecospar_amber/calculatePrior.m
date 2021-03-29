function [prior_cov, prior_cov_inv] = calculatePrior(obj,points_to_include)

signal_variance = obj.settings.signal_variance;
GP_noise_var = obj.settings.GP_noise_var;

% Calculate Prior over subset V (linear subspace and previously visited
% points)
[prior_cov, prior_cov_inv] = gp_prior(points_to_include,signal_variance,obj.lengthscales, GP_noise_var);

%%%%%%%%%%%%%%%%%%%%%%%%%%% Helper Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [prior_cov, prior_cov_inv] = gp_prior(points_to_sample,signal_variance,lengthscales, GP_noise_var)
% Points over which objective function was sampled. These are the points over
% which we will draw samples.

prior_cov = kernel(points_to_sample,signal_variance,GP_noise_var,lengthscales);
prior_cov_inv = prior_cov^(-1);

end

function cov = kernel(X,variance, GP_noise_var, lengthscales)
% Function: calculate the covariance matrix using the squared exponential kernel

[num_pts_sample, state_dim] = size(X);

cov =  variance * ones(num_pts_sample,num_pts_sample);
for i = 1:num_pts_sample
    pt1 = X(i, :);
    for j = 1:num_pts_sample
        pt2 = X(j, :);
        for dim = 1: state_dim
            lengthscale = lengthscales(dim);
            if lengthscale > 0
                cov(i, j) = cov(i, j) * ...
                    exp(-0.5 * ((pt2(dim) - pt1(dim)) / lengthscale)^2);
            elseif lengthscale == 0 && pt1(dim) ~= pt2(dim)
                cov(i, j) = 0;
            end
        end
    end
end
cov = cov + GP_noise_var * eye(num_pts_sample);
end








end