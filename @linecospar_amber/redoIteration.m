function redoIteration(obj, num_samples)

% remove from visited actions
[~,ind] = ismember(obj.currentAction,obj.visited_actions_a,'row');
obj.visited_actions_a(ind,:) = [];

if obj.iteration == 1

    a0_ind = randi(obj.num_points_to_sample,num_samples,1);
    obj.currentAction = obj.points_to_sample(a0_ind,:); 
    obj.currentActionInd = reshape(1:num_samples,[],1); % First action in visited_actions_a
    obj.visited_actions_a = obj.currentAction;
else
    
    %%% Get Linear Subspace
    obj.getSubspace; % updates obj.linear_subspace
    
    %%% Update Subset V
    obj.subset_V = [obj.visited_actions_a;obj.linear_subspace_l];

    %%% Interpolate Posterior over Subset V
    obj.calculatePosterior; % interpolates over obj.subset_V

    %%% Draw new samples from calculated posterior posterior_model_G
    [actions, actionInds, ~] = obj.drawSamples(num_samples);
    obj.currentAction = actions;
    obj.currentActionInd = actionInds;
    
end


end