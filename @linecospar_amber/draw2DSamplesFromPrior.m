function draw2DSamplesFromPrior(obj,dims,num_samples)
%%%%
%  Generate set of 2D objective functions by sampling from a GP prior.
%%%%

if nargin < 3
    num_samples = 1;
end

% Settings:
variance = obj.settings.signal_variance;  % Amplitude
noise_var = obj.settings.GP_noise_var;    % Noise
lengthscales = [obj.parameters(dims(1)).lengthscale,obj.parameters(dims(2)).lengthscale];     % Wavyness of signal
num_pts = [obj.parameters(dims(1)).num_actions, obj.parameters(dims(2)).num_actions];   % Number of Points to Sample
% num_pts = [30, 30];   % Number of Points to Sample

% Get values based on number of points to sample
x_vals = linspace(obj.parameters(dims(1)).lower, obj.parameters(dims(1)).upper, num_pts(1));
y_vals = linspace(obj.parameters(dims(2)).lower, obj.parameters(dims(2)).upper, num_pts(2));

% Define grid of points over which to evaluate the objective function:
num_sample_points = prod(num_pts);  % Total number of points in grid

% Put the points into list format:
points_to_sample = zeros(num_sample_points, 2);
for i = 1:length(x_vals)
    x_val = x_vals(i);
    for j = 1:length(y_vals)
        y_val = y_vals(j);
        points_to_sample(num_pts(2) * (i-1) + j, :) = [x_val, y_val];
    end
end

% Gaussian process prior mean:
mean = 0.5 * ones(num_sample_points,1);

% Instantiate the prior covariance matrix, using a squared exponential
% kernel in each dimension of the input space:
GP_prior_cov =  variance * ones(num_sample_points,num_sample_points);

for i= 1:num_sample_points
    
    pt1 = points_to_sample(i, :);
    
    for j=1:num_sample_points
        
        pt2 = points_to_sample(j, :);
        
        for dim = 1:2
            
            lengthscale = lengthscales(dim);
            
            if lengthscale > 0
                GP_prior_cov(i, j) = GP_prior_cov(i,j)*exp(-0.5 * ((pt2(dim) - pt1(dim)) / lengthscale)^2);
                
            elseif lengthscale == 0 && pt1(dim) ~= pt2(dim)
                
                GP_prior_cov(i, j) = 0;
            end
        end
    end
end

GP_prior_cov = GP_prior_cov + noise_var * eye(num_sample_points);

% For plotting GP samples:
[Y, X] = meshgrid(x_vals, y_vals);

figure
for i = 1:num_samples
    % Draw a sample from the GP:
    GP_sample = mvnrnd(mean, GP_prior_cov);
    GP_sample = reshape(GP_sample,num_pts(2), num_pts(1));
    GP_sample = (GP_sample - min(GP_sample,[],'all'))/(max(GP_sample,[],'all')-min(GP_sample,[],'all'));

    surf(Y,X,GP_sample);
    hold on
    xlabel(obj.parameters(dims(1)).name);
    ylabel(obj.parameters(dims(2)).name);
end

end