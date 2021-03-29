function getSubspace(obj)

lb = obj.lower_bounds;
ub = obj.upper_bounds;

if obj.isCoordinateAligned
    %%% Coordinate Aligned:
    direction = zeros(1,obj.state_dim);
    rand_coordinate = randi([1,obj.state_dim],1);
    direction(rand_coordinate) = 1;
    
    % get points along line in positive direction
    linear_subspace = obj.best_action_p;
    n = 1;
    new_point = obj.best_action_p + n.*obj.discretization(rand_coordinate).*direction;
    while isValidPoint(obj,new_point)
        % append new_point
        linear_subspace = cat(1,linear_subspace,new_point);
        
        % get next new_point
        n = n+1;
        new_point = obj.best_action_p + n.*obj.discretization(rand_coordinate).*direction;
        
    end
    
    % get points along line in negative direction
    n = 1;
    new_point = obj.best_action_p - n.*obj.discretization(rand_coordinate).*direction;
    while isValidPoint(obj,new_point)
        % append new_point
        linear_subspace = cat(1,new_point,linear_subspace);
        
        % get next new_point
        n = n+1;
        new_point = obj.best_action_p - n.*obj.discretization(rand_coordinate).*direction;
        
    end
    
else %not coordinate aligned
    
    % Get random point in space
    randAction = obj.best_action_p;
    while (randAction == obj.best_action_p)
        a0_ind = randi(obj.num_points_to_sample,1,1);
        randAction = obj.points_to_sample(a0_ind,:); 
    end
    
    direction = (randAction - obj.best_action_p)/norm(randAction - obj.best_action_p);
    
%     direction = randn([1,obj.state_dim]);
%     direction = direction / norm(direction); % scale direction to have norm 1
%     
    % get points along line in positive direction
    linear_subspace = obj.best_action_p;
    n = 1;
    new_point = obj.best_action_p + n.*obj.discretization.*direction;
    while isValidPoint(obj,new_point)
        % append new_point
        linear_subspace = cat(1,linear_subspace,new_point);
        
        % get next new_point
        n = n+1;
        new_point = obj.best_action_p + n.*obj.discretization.*direction;
        
    end
    
    % get points along line in negative direction
    n = 1;
    new_point = obj.best_action_p - n.*obj.discretization.*direction;
    while isValidPoint(obj,new_point)
        % append new_point
        linear_subspace = cat(1,new_point,linear_subspace);
        
        % get next new_point
        n = n+1;
        new_point = obj.best_action_p - n.*obj.discretization.*direction;
        
    end
end

obj.linear_subspace_l = linear_subspace;
end


function isValid = isValidPoint(obj,point)
if any(point < obj.lower_bounds)
    isValid = false;
elseif any(point > obj.upper_bounds)
    isValid = false;
else
    isValid = true;
end
end
