function addParameters(obj, params)

for i = 1:length(params)
    currentParam = params(i);
    switch currentParam
        case 1
            if isempty(obj.selectedParams)
                obj.selectedParams = 1;
                obj.discretization = obj.parameters(1).discretization;
                obj.lower_bounds = obj.parameters(1).lower;
                obj.upper_bounds = obj.parameters(1).upper;
            elseif ~any(obj.selectedParams == 1)
                obj.selectedParams(end+1) = 1;
                obj.discretization(end+1) = obj.parameters(1).discretization;
                obj.lower_bounds(end+1) = obj.parameters(1).lower;
                obj.upper_bounds(end+1) = obj.parameters(1).upper;
            end
        case 2
            if isempty(obj.selectedParams)
                obj.selectedParams = 2;
                obj.discretization = obj.parameters(2).discretization;
                obj.lower_bounds = obj.parameters(2).lower;
                obj.upper_bounds = obj.parameters(2).upper;
            elseif ~any(obj.selectedParams == 2)
                obj.selectedParams(end+1) = 2;
                obj.discretization(end+1) = obj.parameters(2).discretization;
                obj.lower_bounds(end+1) = obj.parameters(2).lower;
                obj.upper_bounds(end+1) = obj.parameters(2).upper;
            end
        case 3
            if isempty(obj.selectedParams)
                obj.selectedParams = 3;
                obj.discretization = obj.parameters(3).discretization;
                obj.lower_bounds = obj.parameters(3).lower;
                obj.upper_bounds = obj.parameters(3).upper;
            elseif ~any(obj.selectedParams == 3)
                obj.selectedParams(end+1) = 3;
                obj.discretization(end+1) = obj.parameters(3).discretization;
                obj.lower_bounds(end+1) = obj.parameters(3).lower;
                obj.upper_bounds(end+1) = obj.parameters(3).upper;
            end
        case 4
            if isempty(obj.selectedParams)
                obj.selectedParams = 4;
                obj.discretization = obj.parameters(4).discretization;
                obj.lower_bounds = obj.parameters(4).lower;
                obj.upper_bounds = obj.parameters(4).upper;
            elseif ~any(obj.selectedParams == 4)
                obj.selectedParams(end+1) = 4;
                obj.discretization(end+1) = obj.parameters(4).discretization;
                obj.lower_bounds(end+1) = obj.parameters(4).lower;
                obj.upper_bounds(end+1) = obj.parameters(4).upper;
            end
        case 5
            if isempty(obj.selectedParams)
                obj.selectedParams = 5;
                obj.discretization = obj.parameters(5).discretization;
                obj.lower_bounds = obj.parameters(5).lower;
                obj.upper_bounds = obj.parameters(5).upper;
            elseif ~any(obj.selectedParams == 5)
                obj.selectedParams(end+1) = 5;
                obj.discretization(end+1) = obj.parameters(5).discretization;
                obj.lower_bounds(end+1) = obj.parameters(5).lower;
                obj.upper_bounds(end+1) = obj.parameters(5).upper;
            end
        case 6
            if isempty(obj.selectedParams)
                obj.selectedParams = 6;
                obj.discretization = obj.parameters(6).discretization;
                obj.lower_bounds = obj.parameters(6).lower;
                obj.upper_bounds = obj.parameters(6).upper;
            elseif ~any(obj.selectedParams == 6)
                obj.selectedParams(end+1) = 6;
                obj.discretization(end+1) = obj.parameters(6).discretization;
                obj.lower_bounds(end+1) = obj.parameters(6).lower;
                obj.upper_bounds(end+1) = obj.parameters(6).upper;
            end
        case 7
            if isempty(obj.selectedParams)
                obj.selectedParams = 7;
                obj.discretization = obj.parameters(7).discretization;
                obj.lower_bounds = obj.parameters(7).lower;
                obj.upper_bounds = obj.parameters(7).upper;
            elseif ~any(obj.selectedParams == 7)
                obj.selectedParams(end+1) = 7;
                obj.discretization(end+1) = obj.parameters(7).discretization;
                obj.lower_bounds(end+1) = obj.parameters(7).lower;
                obj.upper_bounds(end+1) = obj.parameters(7).upper;
            end
        case 8
            if isempty(obj.selectedParams)
                obj.selectedParams = 8;
                obj.discretization = obj.parameters(8).discretization;
                obj.lower_bounds = obj.parameters(8).lower;
                obj.upper_bounds = obj.parameters(8).upper;
            elseif ~any(obj.selectedParams == 8)
                obj.selectedParams(end+1) = 8;
                obj.discretization(end+1) = obj.parameters(8).discretization;
                obj.lower_bounds(end+1) = obj.parameters(8).lower;
                obj.upper_bounds(end+1) = obj.parameters(8).upper;
            end
    end
    
end

end