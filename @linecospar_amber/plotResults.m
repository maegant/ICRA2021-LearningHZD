function plotResults(obj,fig)

gca(fig);

% hard coded for 5 parameters

algInds = 1:obj.state_dim;

% all combinations of 3 parameters
C = nchoosek(1:obj.state_dim,3);

for c = 1%:size(C,1)
    dims = obj.selectedParams(C(c,:));
    dimInds = C(c,:);
    
    %     subplot(2,5,c);
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
    
    end
    
    xlabel(curax,strrep(obj.parameters(dims(1)).name,'_',' '));
    ylabel(curax,strrep(obj.parameters(dims(2)).name,'_',' '));
    zlabel(curax,strrep(obj.parameters(dims(3)).name,'_',' '));
    title(curax,sprintf('Iteration %i',obj.iteration));
    
    xlim(curax,[obj.lower_bounds(dimInds(1)) obj.upper_bounds(dimInds(1))]);
    ylim(curax,[obj.lower_bounds(dimInds(2)) obj.upper_bounds(dimInds(2))]);
    zlim(curax,[obj.lower_bounds(dimInds(3)) obj.upper_bounds(dimInds(3))]);
    xticks(curax,obj.parameters(obj.selectedParams(dimInds(1))).actions);
    yticks(curax,obj.parameters(obj.selectedParams(dimInds(2))).actions);
    zticks(curax,obj.parameters(obj.selectedParams(dimInds(3))).actions);
    
    view(curax,[-441.9000   39.0000])
    grid(curax, 'on');
    
end


amberTools.graphics.fontsize(10);
amberTools.graphics.latexify

drawnow

end
