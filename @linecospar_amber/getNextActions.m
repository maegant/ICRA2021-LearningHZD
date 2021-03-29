function getNextActions(obj, newDataInds, y, C, num_samples)
% Use Bayesian optimization with pairwise preferences to tackle the dueling 
% bandit problem. Rather than standard GP regression, use the model from Chu and
% Ghahramani, which specifically accounts for preferences.
% 
% This is a program which receives preference data and uses this data to select
% actions.

%%% Update Actions 
obj.lastAction = obj.currentAction;
obj.lastActionInd = obj.currentActionInd;
obj.iteration = obj.iteration+1;

%%% Add actions to history
obj.history_actions = [obj.history_actions; obj.currentAction];

%%% Update Posterior from User Feedback
obj.updatePosterior(newDataInds,y);

%%% Update best action
[~,bestInd] = max(obj.posterior_model_F.mean);
obj.best_action_p = obj.visited_actions_a(bestInd,:);

%%% Get Linear Subspace
obj.getSubspace; % updates obj.linear_subspace based on obj.best_action_p

%%% Update Subset V
obj.subset_V = [obj.visited_actions_a;obj.linear_subspace_l];

%%% Interpolate Posterior over Subset V
obj.calculatePosterior; % interpolates over obj.subset_V

%%% Draw new samples from calculated posterior posterior_model_G
[actions, actionInds, ~] = obj.drawSamples(num_samples);
obj.currentAction = actions;
obj.currentActionInd = actionInds;




end


