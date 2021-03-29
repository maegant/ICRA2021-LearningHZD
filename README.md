# ICRA2021-LearningHZD

This repository includes the learning algorithm, experimental results and documentation for the ICRA 2021 submission "Preference-Based Learning for User-Guided HZD Gait Generation on Bipedal Walking Robots".

The main contents include the following:
- LineCoSparNLP algorithm for learning 5 optimization constraints (average forward velocity, minimum foot clearance, impact velocity, step length, tau at which to enforce minimum foot clearance)
- Experimental Results
- Plotting code to visualize results

## LineCoSparNLP Framework
The learning framework is implemented as the class @linecospar_amber. The procedure of the framework is as follows. First, the learning is initialized by the command:
```
alg = linecospar_amber();
```
and the essential constraints chosen to learn over are selected by the command:
```
alg.addParameters(numberConstraintsToInclude);
```
for example, to include all of the constraints use the command
```
alg.addParameters(1:5);
```
<br>

The first actions are sampled randomly using the command:
```
alg.getFirstActions(num_sims);
```
where num_sims = 2 for the published experimental results. This command updates the parameters in alg.currentAction. Gaits are then generated for these actions using the command:
```
for i = 1:num_sims
    currentParams = alg.currentAction(i,:);
    gaitName{i} = sprintf('Iteration%i_Action%i',iter,i);
    [params, logger, sol, status] = runOpt(currentParams, 
        nlp,behavior, save_folder, gaitName{i});
end
```

The generated gaits are then executed on hardware and a pairwise preference between the executed actions is obtained from the human operator. The preference is subjective to the operator. The criteria used in the published experiments was as follows (in order of prioritization):
 - Capable of walking
 - Robust to perturbations in treadmill speeds
 - Robust to external forces
 - Does not exhibit harsh noise
 - Is visually appealing (intuitive judgement)

Preferences are recorded as 0 (if the first gait is preferred) and 1 (if the second gait is preferred). The actions associated with the preference are recorded in terms of their associated indices in the matrix of executed actions. For example, if the second unique gait generated is compared to the seventh unique gait generated, the comparison would be [2,7]. 

<br>

Once the preference is obtained, new actions to execute are sampled using the command:
```
alg.getNextActions(comparisons, preference, C, num_sims);
```
where C is coactive feedback. However, in the published experiments, coactive feedback is not used so C is empty.

____ 
## ICRA 2021 Experimental Results

The results of the experiment on AMBER-P is included in the folder Results/AMBER-P. The results of the experiment on AMBER-S is included in the folder Results/AMBER-S. 

A few scripts were written to plot the experimental results including:
- animateICRA2021Posterior.m: A script to animate the posteriors for both experiments
- evaluateResults.m: A script to evaluate the order of preference associated with the executed gaits
- finalICRA2021Plots.m: A script to generate the static plots of the final obtained posteriors on the executed actions for both experiments
