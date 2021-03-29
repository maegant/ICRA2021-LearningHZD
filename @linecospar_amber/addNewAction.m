function newAction = addNewAction(obj)

    rand_ind = randi(obj.num_points_to_sample,1);
    newAction = obj.points_to_sample(rand_ind,:);
    
    obj.currentAction = [obj.currentAction; newAction]; 
    
     %update the sample ind to be it's index in terms of the
     %visited_actions index numbers
    if ismember(newAction,obj.visited_actions_a,'row')
        ind = find(newAction == obj.visited_actions_a);
        newActionInd = ind(1);
    else
        newActionInd = size(obj.visited_actions_a,1);
        obj.visited_actions_a = cat(1,obj.visited_actions_a,newAction);
    end
    
    obj.currentActionInd = [obj.currentActionInd; newActionInd];
    
end