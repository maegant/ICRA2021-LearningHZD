function calculatePosterior(obj)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Calculate P(G|D)
%    
%     Calculate Posterior over the subset V
%     Subset V should include the visited actions and linear subspace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Update Prior over visited points
[~, prior_cov_inv] = obj.calculatePrior(obj.subset_V);

num_features = size(obj.subset_V,1); %number of points in subspace

% Solve convex optimization problem to obtain the posterior mean reward
% vector via Laplace approximation
r_init = zeros(num_features,1); %initial guess

% The posterior mean is the solution to the optimization problem
options = optimoptions('fmincon','SpecifyObjectiveGradient',true);
post_mean = fmincon(@(f) preference_GP_objective(f,obj.data_matrix_inds,...
    obj.labels,prior_cov_inv,...
    obj.settings.preference_noise), ...
    r_init,[],[],[],[],[],[],[],options);

% Obtain inverse of posterior covariance approximation by evaluating the
% objective function's Hessian at the posterior mean estimate:
post_cov_inverse = preference_GP_hessian(post_mean, obj.data_matrix_inds, obj.labels, ...
    prior_cov_inv,  obj.settings.preference_noise);

% Calculate the eigenvectors and eigenvalues of the inverse posterior
% covariance matrix:
[evecs, evals] = eig(post_cov_inverse);
evals = diag(evals);

% Invert the eigenvalues to get the eigenvalues corresponding to the
% covariance matrix:
evals = 1 ./ real(evals);

% Update the object with the posterior model
obj.posterior_model_G.mean = post_mean;
obj.posterior_model_G.cov_evecs = evecs;
obj.posterior_model_G.cov_evals = evals;
obj.posterior_model_G.actions = obj.subset_V;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Helper Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [objective,gradient] = preference_GP_objective(f,...
    data,labels,GP_prior_cov_inv, preference_noise)

%%%
% Evaluate the optimization objective function for finding the posterior
% mean of the GP preference model (at a given point); the posterior mean is
% the minimum of this (convex) objective function.
%
% Inputs:
%     1) f: the "point" at which to evaluate the objective function. This
%           is a length-n vector (n x 1) , where n is the number of points
%           over which the posterior is to be sampled.
%     2)-5): same as the descriptions in the feedback function.
%
% Output: the objective function evaluated at the given point (f).
%%%

% make sure f is column vector
reshape(f,[],1);

objective = 0.5*f'*GP_prior_cov_inv*f;

num_samples = size(data,1);

if ~isempty(data)
    for i = 1:num_samples % go through each pair of data points
        data_pts = data(i,:);
        label = labels(i);
        
        % in the case of a tie:
        if label == 0.5
            %continue
        else
            z = (f(data_pts(label+1)) - f(data_pts((1-label)+1)))...
                /(sqrt(2)*preference_noise);
            objective = objective - log(normcdf(z));
        end
    end
end
gradient = preference_GP_gradient(f, data, labels, GP_prior_cov_inv, preference_noise);


end

function grad = preference_GP_gradient(f, data, labels, GP_prior_cov_inv, preference_noise)
%%%
%     Evaluate the gradient of the optimization objective function for finding
%     the posterior mean of the GP preference model (at a given point).
%
%     Inputs:
%         1) f: the "point" at which to evaluate the gradient. This is a length-n
%            vector, where n is the number of points over which the posterior
%            is to be sampled.
%         2)-5): same as the descriptions in the feedback function.
%
%     Output: the objective function's gradient evaluated at the given point (f).
%%%

grad = GP_prior_cov_inv * f;    % Initialize to 1st term of gradient

num_samples = size(data,1);

if ~isempty(data)
    for i = 1:num_samples   % Go through each pair of data points
        
        data_pts = data(i, :);   % Data points queried in this sample
        label = labels(i);
        
        if label == 0.5
            % continue
        else
            s_pos = data_pts(label+1);
            s_neg = data_pts(1 - label + 1);
            
            z = (f(s_pos) - f(s_neg)) / (sqrt(2) * preference_noise);
            
            value = (normpdf(z) / normcdf(z)) / (sqrt(2) * preference_noise);
            
            grad(s_pos) = grad(s_pos) - value;
            grad(s_neg) = grad(s_neg) + value;
        end
    end
end
end

function hessian = preference_GP_hessian(f, data, labels, GP_prior_cov_inv, preference_noise)
%%%%%
%     Evaluate the Hessian matrix of the optimization objective function for
%     finding the posterior mean of the GP preference model (at a given point).
%
%     Inputs:
%         1) f: the "point" at which to evaluate the Hessian. This is
%            a length-n vector, where n is the number of points over which the
%            posterior is to be sampled.
%         2)-5): same as the descriptions in the feedback function.
%
%     Output: the objective function's Hessian matrix evaluated at the given
%             point (f).
%%%%%

num_samples = size(data,1);

Lambda = zeros(size(GP_prior_cov_inv));

if ~isempty(data)
    for i = 1:num_samples   % Go through each pair of data points
        
        data_pts = data(i,:);  % Data points queried in this sample
        label = labels(i);
        
        if label == 0.5
            %continue
        else
            s_pos = data_pts(label+1);
            s_neg = data_pts((1 - label)+1);
            z = (f(s_pos) - f(s_neg)) / (sqrt(2) * preference_noise);
            
            ratio = normpdf(z) / normcdf(z);
            value = ratio * (z + ratio) / (2 * preference_noise^2);
            
            Lambda(s_pos, s_pos) = Lambda(s_pos, s_pos) + value;
            Lambda(s_neg, s_neg) = Lambda(s_neg, s_neg) + value;
            Lambda(s_pos, s_neg) = Lambda(s_pos, s_neg) - value;
            Lambda(s_neg, s_pos) = Lambda(s_neg, s_pos) - value;
        end
        
    end
end

hessian = GP_prior_cov_inv + Lambda;
end
