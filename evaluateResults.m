
%% Rigid model results

rigid_path = 'Results/AMBER-P/Exp-Data/';
load([rigid_path,'Alg.mat']);
load([rigid_path,'Info.mat']);

% sort actions
[~,ind] = sort(alg.posterior_model_F.mean);

rigidTimes = [20.45, 13.455, 5.133, 8.666, 20.199, 6.908, 50.926, 13.724, 10.045, 7.258, 5.729, 11.712, 7.213, 11.669, 4.788, ...
6.629, 9.998, 42.559, 46.42, 11.858, 14.292, 9.501, 5.250, 13.474, 41.289, 9.641, 5.238, 11.652, 9.947, 15.815];

gaitNums = [1 2 3 4 1 3 5 2 6 7 7 8 4 8 9 3 10 11 12 13 14 2 7 8 11 10, 14, 8, 8, 12];

avgRun = mean(rigidTimes./Info.iterations(gaitNums));

fprintf('---------- AMBER-P Experiments -------------: \n');
fprintf('Ordered list of iterations from worst to best: \n');
orderedList = Info.algiteration(ind);
for i = 1:length(orderedList)
    fprintf('%s \n',orderedList{i})
end
fprintf('---------------------------------------------\n \n \n');

%% Spring model

spring_path = 'Results/AMBER-S/Exp-Data/';
load([spring_path,'Alg.mat']);
load([spring_path,'Info.mat']);


% sort actions
[~,ind2] = sort(alg.posterior_model_F.mean);

fprintf('---------- AMBER-S Experiments -------------: \n');
fprintf('Ordered list of iterations from worst to best: \n');
orderedList = Info.algiteration(ind2);
for i = 1:length(orderedList)
    fprintf('%s \n',orderedList{i})
end
fprintf('---------------------------------------------\n \n \n');

