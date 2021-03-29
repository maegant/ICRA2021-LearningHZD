function getFirstActions(obj,num_samples)

dims = obj.selectedParams;
preference_noise = obj.settings.preference_noise;

%%%%%%%%%%%%%%%%%%%% Calculate points to sample %%%%%%%%%%%%%%%%%%%%%%%%%%%
obj.lengthscales = zeros(1,length(obj.selectedParams));
obj.num_actions = zeros(1,length(obj.selectedParams));
for i = 1:length(obj.selectedParams)
    ind = obj.selectedParams(i);
    actions{i} = obj.parameters(ind).actions;
    obj.lengthscales(i) = obj.parameters(ind).lengthscale;
    obj.num_actions(i) = obj.parameters(ind).num_actions;
end

switch length(obj.selectedParams)
    case 1
        obj.points_to_sample = reshape(actions{1},[],1);
    case 2
        [x,y] = ndgrid(actions{1},actions{2});
        obj.points_to_sample = [x(:),y(:)];
    case 3
        [x,y,z] = ndgrid(actions{1},actions{2},actions{3});
        obj.points_to_sample = [x(:),y(:),z(:)];
    case 4
        [x,y,z,a] = ndgrid(actions{1},actions{2},actions{3},actions{4});
        obj.points_to_sample = [x(:),y(:),z(:),a(:)];
    case 5
        [x,y,z,a,b] = ndgrid(actions{1},actions{2},actions{3},actions{4},actions{5});
        obj.points_to_sample = [x(:),y(:),z(:),a(:),b(:)];
    case 6
        [x,y,z,a,b,c] = ndgrid(actions{1},actions{2},actions{3},actions{4},actions{5},actions{6});
        obj.points_to_sample = [x(:),y(:),z(:),a(:),b(:),c(:)];
    case 7
        [x,y,z,a,b,c,d] = ndgrid(actions{1},actions{2},actions{3},actions{4},actions{5},actions{6},actions{7});
        obj.points_to_sample = [x(:),y(:),z(:),a(:),b(:),c(:),d(:)];
    case 8
        [x,y,z,a,b,c,d,e] = ndgrid(actions{1},actions{2},actions{3},actions{4},actions{5},actions{6},actions{7},actions{8});
        obj.points_to_sample = [x(:),y(:),z(:),a(:),b(:),c(:),d(:),e(:)];
end

% Store number of points to sample over, and the number of parameters
[obj.num_points_to_sample, obj.state_dim] = size(obj.points_to_sample);

%%%%%%%%%%%%%%%%% Randomly select first actions to query %%%%%%%%%%%%%%%%%%%

a0_ind = randi(obj.num_points_to_sample,num_samples,1);
obj.currentAction = obj.points_to_sample(a0_ind,:); 
obj.currentActionInd = reshape(1:num_samples,[],1); % First action in visited_actions_a

obj.visited_actions_a = obj.currentAction;

obj.iteration = 1;

end


