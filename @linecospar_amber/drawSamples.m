function [samples, sampleInds, R_models] = drawSamples(obj,num_samples)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     Draw a specified number of samples from the preference GP Bayesian model
%     posterior.
%
%     Inputs:
%         1) posterior_model: this is the model posterior, represented as a
%            dictionary of the form {'mean': post_mean, 'cov_evecs': evecs,
%            'cov_evals': evals}; post_mean is the posterior mean, a length-n
%            NumPy array in which n is the number of points over which the
%            posterior is to be sampled. cov_evecs is an n-by-n NumPy array in
%            which each column is an eigenvector of the posterior covariance,
%            and evals is a length-n array of the eigenvalues of the posterior
%            covariance.
%
%         2) num_samples: the number of samples to draw from the posterior; a
%            positive integer.
%
%     Outputs:
%         1) A num_samples-length NumPy array, in which each element is the index
%            of a sample.
%         2) An n-by-num_samples-size NumPy array, in which each column is a
%            sampled reward function. Each reward function sample is a length-n
%            vector (see above for definition of n).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
obj.samples = [];
obj.sampleMax = [];
obj.sampleMaxInds = [];

samples = ones(num_samples,obj.state_dim); % to store sampled actions
sampleInds = zeros(num_samples,1); 

% unpack the model posterior
mean = obj.posterior_model_G.mean;
cov_evecs = obj.posterior_model_G.cov_evecs;
cov_evals = obj.posterior_model_G.cov_evals;

num_features = length(mean);

% to store the sampled reward functions:
R_models = zeros(length(mean),num_samples);

% counter of number of samples tried
num_tried = 0;
max_number = 50;

% draw the samples
for i = 1:num_samples
    
    %continue sampling until the next sample is not the same as any existing samples   
    isSampling = 1;
    while isSampling
        
        % sample reward function from GP model posterior
        X = randn(num_features,1);
        R = mean + cov_evecs * diag(sqrt(cov_evals)) * X;
        R = real(R);
        obj.samples(i,:) = R;
       
        
        % find where the reward function is maximized
        [~, maxInd] = max(R);
        obj.sampleMax(i,1) = R(maxInd);
        obj.sampleMaxInds(i,1) = maxInd;
        currentSample = obj.subset_V(maxInd,:);
        num_tried = num_tried + 1;
        
        % store the sampled reward function
        R_models(:,i) = R;
        
        repeatingSample = 0;
        % if any of the sample are repeated - don't use that sample
        if ismember(currentSample, samples,'rows')
            isSampling = 1;
            repeatingSample = 1;
        end
        
        % if any of the samples are the same as samples in the buffer -
        % don't use that sample
%         if ismember(currentSample,obj.lastAction,'rows') 
%             repeatingSample = 1;
%         end
        
        if (~repeatingSample || num_tried > max_number)
            isSampling = 0;
        end
        
    end
    samples(i,:) = currentSample;
    
    %update the sample ind to be it's index in terms of the
     %visited_actions index numbers
    if ~isempty(obj.visited_actions_a)
        if ismember(currentSample,obj.visited_actions_a,'row')
        [~,ind] = ismember(currentSample, obj.visited_actions_a,'row');
        sampleInds(i,:) = ind(1);
        else
            sampleInds(i,:) = size(obj.visited_actions_a,1)+1;
            obj.visited_actions_a = cat(1,obj.visited_actions_a,currentSample);
        end
    else
        sampleInds(i,:) = 1;
        obj.visited_actions_a = currentSample;
    end

   
end

     
    
end