%% Animate AMBER-P First
addpath('tools');
if ~isfolder('Results/AMBER-P/Posteriors')
    mkdir('Results/AMBER-P/Posteriors')
end

load('Results/AMBER-P/Exp-Data/Alg.mat')

names = {'$a_1$','$a_3$','$a_4$','$a_5$','$a_2$'};

figure(1);
selectedParams = 1:5;

% All combinations of 3 parameters
C = nchoosek(selectedParams,3);

% Only plot combination of  average velocity, impact velocity, and max
% height tau
choices = 5;

for i = 1:size(alg.data_matrix_inds,1)
    
    X = alg.data_matrix_inds(1:i,:);
    y = alg.labels(1:i);
    
    % include actions in X
    maxInd = max(X,[],'all');
    
    points_to_sample = alg.visited_actions_a(1:maxInd,:);
    
    %%% Update Prior over visited points
    post_mean = getPosterior(alg,points_to_sample,X,y);
    
    for c = 1
    
        dims = selectedParams(C(c,:));
        dimInds = C(choices(c),:);    
        
        reduced_subset = points_to_sample(:,dimInds);
        [unique_subset,ia,ic] = unique(reduced_subset,'rows');
        mean_unique = zeros(size(unique_subset,1),1);
        
        for j = 1:length(ia)
            mean_inds = (ic == j);
            mean_unique(j) = mean(post_mean(mean_inds));
        end
        
        
        if all(mean_unique == 0)
            colors = mean_unique;
        else
            colors = (mean_unique-min(mean_unique))/(max(mean_unique)-min(mean_unique));
        end
        scatter3(unique_subset(:,1),unique_subset(:,2),unique_subset(:,3),1000,colors,'filled');
        
        if c == 1
            title(sprintf('Iteration %i',i),'Color',[1 1 1]);
        end
        
        xlim([alg.lower_bounds(dimInds(1)) alg.upper_bounds(dimInds(1))]);
        ylim([alg.lower_bounds(dimInds(2)) alg.upper_bounds(dimInds(2))]);
        zlim([alg.lower_bounds(dimInds(3)) alg.upper_bounds(dimInds(3))]);
        
        xticklabels([]);
        yticklabels([]);
        zticklabels([]);
        
        xlabel(names(dimInds(1)),'Color','w','Position',[0.463405711224176,-0.82357938135172,0.397934497601332]);
        ylabel(names(dimInds(2)),'Color','w','Position',[0.287520360467046,-0.473464126873793,0.405073255387493]);
        zlabel(names(dimInds(3)),'Color','w','Rotation',0);
        
        
        set(gca, 'Color', 'w');
%         view(curax,[-441.9000   39.0000])
        grid on
        
    end
    set(gcf, 'Color', 'k');
    set(gcf,'Position',[1452 66 952 914]);
    
    fontsize(36);
    latexify
    
    if i < 10
        export_fig(sprintf('Results/AMBER-P/Posteriors/iter0%i.png',i),'-dpng');
    else
        export_fig(sprintf('Results/AMBER-P/Posteriors/iter%i.png',i),'-dpng');
    end
end

hold on        
best = scatter3(alg.best_action_p(:,dimInds(1)),alg.best_action_p(:,dimInds(2)),alg.best_action_p(:,dimInds(3)),5000,'p','MarkerEdgeColor','k','MarkerFaceColor','y');
title('Optimal Action','Color',[1 1 1]);
export_fig('Results/AMBER-P/Posteriors/best.png','-dpng');

delete(best)
hold on        
worst_p = alg.visited_actions_a(1,:);
worst = scatter3(worst_p(:,dimInds(1)),worst_p(:,dimInds(2)),worst_p(:,dimInds(3)),5000,'MarkerEdgeColor','r','LineWidth',5);
title('Minimum Utility','Color',[1 1 1]);
export_fig('Results/AMBER-P/Posteriors/worst.png','-dpng');

delete(worst)
hold on        
middle_p = alg.visited_actions_a(16,:);
middle = scatter3(middle_p(:,dimInds(1)),middle_p(:,dimInds(2)),middle_p(:,dimInds(3)),5000,'s','MarkerEdgeColor','b','LineWidth',5);
title('Middle Utility','Color',[1 1 1]);
export_fig('Results/AMBER-P/Posteriors/middle.png','-dpng');

hold off;

%% Animate AMBER-P First
close all
addpath('tools');
if ~isfolder('Results/AMBER-S/Posteriors')
    mkdir('Results/AMBER-S/Posteriors')
end

load('Results/AMBER-S/Exp-Data/Alg.mat')

names = {'$a_1$','$a_3$','$a_4$','$a_5$','$a_2$'};

figure(1);
selectedParams = 1:5;
C = nchoosek(selectedParams,3);

% Only plot combination of  average velocity, impact velocity, and max
% height tau
choices = 5;
for i = 1:size(alg.data_matrix_inds,1)
    
    X = alg.data_matrix_inds(1:i,:);
    y = alg.labels(1:i);
    
    % include actions in X
    maxInd = max(X,[],'all');
    
    points_to_sample = alg.visited_actions_a(1:maxInd,:);
    
    %%% Update Prior over visited points
    post_mean = getPosterior(alg,points_to_sample,X,y);
    
    for c = 1
    
        dims = selectedParams(C(c,:));
        dimInds = C(choices(c),:);    
        
        reduced_subset = points_to_sample(:,dimInds);
        [unique_subset,ia,ic] = unique(reduced_subset,'rows');
        mean_unique = zeros(size(unique_subset,1),1);
        
        for j = 1:length(ia)
            mean_inds = (ic == j);
            mean_unique(j) = mean(post_mean(mean_inds));
        end
        
        
        if all(mean_unique == 0)
            colors = mean_unique;
        else
            colors = (mean_unique-min(mean_unique))/(max(mean_unique)-min(mean_unique));
        end
        scatter3(unique_subset(:,1),unique_subset(:,2),unique_subset(:,3),1000,colors,'filled');
        
        if c == 1
            title(sprintf('Iteration %i',i),'Color',[1 1 1]);
        end
        
        xlim([alg.lower_bounds(dimInds(1)) alg.upper_bounds(dimInds(1))]);
        ylim([alg.lower_bounds(dimInds(2)) alg.upper_bounds(dimInds(2))]);
        zlim([alg.lower_bounds(dimInds(3)) alg.upper_bounds(dimInds(3))]);
        
        xlabel(names(dimInds(1)),'Color','w','Position',[0.463405711224176,-0.82357938135172,0.397934497601332]);
        ylabel(names(dimInds(2)),'Color','w','Position',[0.287520360467046,-0.473464126873793,0.405073255387493]);
        zlabel(names(dimInds(3)),'Color','w','Rotation',0);
        
        xticklabels([]);
        yticklabels([]);
        zticklabels([]);
        
        set(gca, 'Color', 'w');
        grid on
        
    end
    set(gcf, 'Color', 'k');
    set(gcf,'Position',[1452 66 952 914]);
    
    amberTools.graphics.fontsize(36);
    amberTools.graphics.latexify
    
    if i < 10
        export_fig(sprintf('Results/AMBER-S/Posteriors/iter0%i.png',i),'-dpng');
    else
        export_fig(sprintf('Results/AMBER-S/Posteriors/iter%i.png',i),'-dpng');
    end
end

hold on        
best = scatter3(alg.best_action_p(:,dimInds(1)),alg.best_action_p(:,dimInds(2)),alg.best_action_p(:,dimInds(3)),5000,'p','MarkerEdgeColor','k','MarkerFaceColor','y');
title('Optimal Action','Color',[1 1 1]);
export_fig('Results/AMBER-S/Posteriors/best.png','-dpng');

delete(best)
hold on        
worst_p = alg.visited_actions_a(5,:);
worst = scatter3(worst_p(:,dimInds(1)),worst_p(:,dimInds(2)),worst_p(:,dimInds(3)),5000,'MarkerEdgeColor','r','LineWidth',5);
title('Minimum Utility','Color',[1 1 1]);
export_fig('Results/AMBER-S/Posteriors/worst.png','-dpng');

delete(worst)
hold on        
middle_p = alg.visited_actions_a(9,:);
middle = scatter3(middle_p(:,dimInds(1)),middle_p(:,dimInds(2)),middle_p(:,dimInds(3)),5000,'s','MarkerEdgeColor','b','LineWidth',5);
title('Middle Utility','Color',[1 1 1]);
export_fig('Results/AMBER-S/Posteriors/middle.png','-dpng');

hold off;

%% %%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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



function post_mean = getPosterior(obj,points_to_sample,X,y)

[prior_cov, prior_cov_inv] = calculatePrior(obj,points_to_sample);

num_features = size(points_to_sample,1); %number of points in subspace

% Solve convex optimization problem to obtain the posterior mean reward
% vector via Laplace approximation
r_init = zeros(num_features,1); %initial guess

% The posterior mean is the solution to the optimization problem
options = optimoptions('fmincon','SpecifyObjectiveGradient',true);
post_mean = fmincon(@(f) preference_GP_objective(f,X,...
    y,prior_cov_inv,...
    obj.settings.preference_noise), ...
    r_init,[],[],[],[],[],[],[],options);

end


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

function [prior_cov, prior_cov_inv] = calculatePrior(obj,points_to_include)

signal_variance = obj.settings.signal_variance;
GP_noise_var = obj.settings.GP_noise_var;

% Calculate Prior over subset V (linear subspace and previously visited
% points)
[prior_cov, prior_cov_inv] = gp_prior(points_to_include,signal_variance,obj.lengthscales, GP_noise_var);

end

