function drawSamplesFromPrior(obj,dims,num_samples)
%%%%
%  Generate set of 1D objective functions by sampling from a GP prior.
%   Inputs: dims (vector of dimensions to sample from)
%%%%

if nargin < 2
    dims = 1:length(obj.parameters); %
    num_samples = 10;
elseif nargin < 3
    num_samples = 10;
end

figure
for d = 1:length(dims)
    dim = dims(d);
    % Settings:
    variance = obj.settings.signal_variance;  % Amplitude
    noise_var = obj.settings.GP_noise_var;    % Noise
    lengthscale = obj.parameters(dim).lengthscale;     % Wavyness of signal
    num_pts = 50;   % Number of Points to Sample
    
    % Get values based on number of points to sample
%     x_vals = linspace(obj.parameters(dim).lower, obj.parameters(dim).upper, num_pts);
    x_vals = obj.parameters(dim).actions;

    % Put the points into list format:
    points_to_sample = reshape(x_vals,[],1);
    
    % Store number of points to sample over
    [num_pts_sample, state_dim] = size(points_to_sample);
    
    % Instantiate the prior covariance matrix, using a squared exponential
    % kernel in each dimension of the input space:
    GP_prior_cov =  variance * ones(num_pts_sample,num_pts_sample);
    
    for i = 1: num_pts_sample
        
        pt1 = points_to_sample(i, :);
        
        for j = 1: num_pts_sample
            
            pt2 = points_to_sample(j, :);
            
            if lengthscale > 0
                GP_prior_cov(i, j) = GP_prior_cov(i, j) * ...
                    exp(-0.5 * ((pt2 - pt1) / lengthscale)^2);
                
            elseif lengthscale == 0 && pt1 ~= pt2
                
                GP_prior_cov(i, j) = 0;
                
            end
            
        end
    end
    
    GP_prior_cov = GP_prior_cov + noise_var * eye(num_pts_sample);
    
    % Inverse of prior covariance matrix:
    %     GP_prior_cov_inv = (GP_prior_cov)^(-1);
    
    % Gaussian process prior mean:
    mean = 0.5 * ones(num_pts_sample,1);
    
    subplot(4,2,dim)
    for i = 1:num_samples
        % Draw a sample from the GP:
        GP_sample = mvnrnd(mean, GP_prior_cov);
        GP_sample = (GP_sample - min(GP_sample,[],'all'))/(max(GP_sample,[],'all')-min(GP_sample,[],'all'));
        reshape(GP_sample,1,[]);
        plot(x_vals,GP_sample);
        hold on
        xlabel(obj.parameters(dim).name);
        title(obj.parameters(dim).name);
    end
    
end

end