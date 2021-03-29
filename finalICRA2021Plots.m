rigid_path = 'Results/AMBER-P/Exp-Data/Alg.mat';
spring_path = 'Results/AMBER-S/Exp-Data/Alg.mat';

if ispc
    rigid_path = strrep(rigid_path,'/','\');
    spring_path = strrep(spring_path,'/','\');
end

%% First: rigid body
close all;

load(rigid_path)

f = figure(1);
plotResults(alg,f,1,16)
print(f,'RigidPosteriors.png','-dpng','-r600');

%% Second: spring legs
load(spring_path,'alg')

f = figure(2);
plotResults(alg,f,5,9)
print(f,'SpringPosteriors.png','-dpng','-r600');

%% Plotting function
function plotResults(obj,fig,worstInd,midInd)


param_labels = {'Average Velocity','Min Foot Clearance',...
                'Impact Velocity', 'Step Length', 'Clearance Tau'};
            
% hard coded for 5 parameters
algInds = 1:obj.state_dim;

% all combinations of 3 parameters
C = nchoosek(1:obj.state_dim,3);

combInds = [5,10];

% find mid ind
worst_action = obj.visited_actions_a(worstInd,:);
mid_action = obj.visited_actions_a(midInd,:);

for c = 1:2
    combInd = combInds(c);
    dims = obj.selectedParams(C(combInd,:));
    dimInds = C(combInd,:);
    
    subplot(1,2,c);
    curax = gca(fig);
        
    if isempty(obj.subset_V)
        cla;
    else
        reduced_subset = obj.subset_V(:,dimInds);
        [unique_subset,ia,ic] = unique(reduced_subset,'rows');
        mean_unique = zeros(size(unique_subset,1),1);

        for j = 1:length(ia)
            mean_inds = (ic == j);
            mean_unique(j) = mean(obj.posterior_model_G.mean(mean_inds));
        end


        if all(mean_unique == 0)
            colors = mean_unique;
        else
            colors = (mean_unique-min(mean_unique))/(max(mean_unique)-min(mean_unique));
        end
        scatter3(curax,unique_subset(:,1),unique_subset(:,2),unique_subset(:,3),100,colors,'filled');
    
        hold on
        scatter3(curax,obj.best_action_p(:,dims(1)),obj.best_action_p(:,dims(2)),obj.best_action_p(:,dims(3)),400,'p','MarkerEdgeColor','k','MarkerFaceColor','y');
        
        % plot mid action
        scatter3(curax,mid_action(:,dims(1)),mid_action(:,dims(2)),mid_action(:,dims(3)),300,'s','MarkerEdgeColor','b','LineWidth',2);

        % plot worst action
        scatter3(curax,worst_action(:,dims(1)),worst_action(:,dims(2)),worst_action(:,dims(3)),300,'MarkerEdgeColor','r','LineWidth',2);
                
    end
    
    xlabel(param_labels{dims(1)},'Rotation',20,'HorizontalAlignment','center','FontWeight','Bold');
    ylabel(param_labels{dims(2)},'Rotation',-35,'HorizontalAlignment','center','FontWeight','Bold');
    zlabel(param_labels{dims(3)});
%     title(curax,sprintf('Iteration %i',obj.iteration));
    
    xlim(curax,[obj.lower_bounds(dimInds(1)) obj.upper_bounds(dimInds(1))]);
    ylim(curax,[obj.lower_bounds(dimInds(2)) obj.upper_bounds(dimInds(2))]);
    zlim(curax,[obj.lower_bounds(dimInds(3)) obj.upper_bounds(dimInds(3))]);
    xticks(curax,obj.parameters(obj.selectedParams(dimInds(1))).actions);
    yticks(curax,obj.parameters(obj.selectedParams(dimInds(2))).actions);
    zticks(curax,obj.parameters(obj.selectedParams(dimInds(3))).actions);
    
    if any(dimInds(1) == [1,2,3,4,5])
        xticklabel = num2cell(obj.parameters(obj.selectedParams(dimInds(1))).actions);
        xticklabel(2:2:end-1) = {''};
        xticklabels(xticklabel);
    end
    if any(dimInds(2) == [1,2,3,4,5])
        yticklabel = num2cell(obj.parameters(obj.selectedParams(dimInds(2))).actions);
        yticklabel(2:2:end-1) = {''};
        yticklabels(yticklabel);
    end
    
    view(3)    
    grid(curax, 'on');
    axis square
    
end

c = colorbar;
c.Position = [0.9365 0.0946 0.0192 0.8150];

fontsize(14);
latexify

fig.Position = [1312 465 770 333];
drawnow

end
