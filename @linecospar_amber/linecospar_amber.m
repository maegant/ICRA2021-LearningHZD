classdef linecospar_amber < matlab.mixin.Copyable
%% Class Name: cospar_params
% Description: This class setups up and executes the CoSpar algorithm
% specifically for use with the 6 exoskeleton gait parameters (step length,
% step duration, step width, step height, pelvis roll, and pelvis pitch).
% This class is written for a buffer and with a buffer size of 1. 
%
% Author: Maegan Tucker, mtucker@caltech.edu
%
% Date: October 3, 2020
%
    properties(SetAccess = public, GetAccess = public)
        % plotting
        ax
        legendInfo
    end
    
    properties(SetAccess = private, GetAccess = public)
        settings
        parameters
        selectedParams
        initialized
        discretization
        lower_bounds
        upper_bounds
        isCoordinateAligned
        
        samples
        sampleMax
        sampleMaxInds
        currentAction
        currentActionInd
        lastAction
        lastActionInd
        iteration
        
        lengthscales
        num_actions
        points_to_sample
        num_points_to_sample
        state_dim
        
        posterior_model_F
        posterior_model_G
        
        data_matrix_inds
        labels
        
        best_action_p
        best_action_ind
        visited_actions_a
        linear_subspace_l
        subset_V
        history_actions
        
        prior_cov
        prior_cov_inv
        
    end
    
    methods
        function obj = linecospar_amber(saveFolder)
            
            
            
            % load parameter settings
            
            % initialize empty action space items
            obj.selectedParams = []; obj.discretization = [];
            obj.lower_bounds = []; obj.upper_bounds = [];
            obj.history_actions = [];
            
            % add parameter settings
            obj.addParameterSettings;
            
            % learning settings
            obj.isCoordinateAligned = 0;
            obj.initialized = 0;
            obj.iteration = 0;
            obj.settings.signal_variance = 0.005;   % Gaussian process amplitude parameter
            obj.settings.preference_noise = 0.02;    % How noisy are the user's preferences?
            obj.settings.GP_noise_var = 1e-5;        % GP model noise--need at least a very small
            
            % For plotting purposes
            obj.ax = [];
        end
    end
    
    methods(Access=public)
        
        addParameters(obj, params);
        drawSamplesFromPrior(obj,num_samples);
        
        getFirstActions(obj,num_samples);
        getNextActions(obj, X, y, C, num_samples);
        lastIteration(obj, newDataInds, y, C, num_samples);
        
        [samples, sampleInds, R_models] = drawSamples(obj,num_samples);
        
        [prior_cov, prior_cov_inv] = calculatePrior(obj,points_to_include)
        
        getSubspace(obj);
        
        plotResults(obj,numFigs);
        
        exportResults(obj,folderName);
        
        newaction = addNewAction(obj);
        
        redoIteration(obj,num_sims);
        
        updatePosterior(obj,newDataInds,newLabel)
        calculatePosterior(obj);
        
    end
    
    methods(Access=private)
        function obj = addParameterSettings(obj)
                        
            obj.parameters(1).name = 'average_vel';
            obj.parameters(1).discretization = 0.05;
            obj.parameters(1).lengthscale = 0.03;
            obj.parameters(1).lower = 0.30; % in m/s
            obj.parameters(1).upper = 0.60; 
            
            obj.parameters(2).name = 'min_foot_clearance';
            obj.parameters(2).discretization = 0.02;
            obj.parameters(2).lengthscale = 0.04;
            obj.parameters(2).lower = 0.05; % in m
            obj.parameters(2).upper = 0.19; 
            
            obj.parameters(3).name = 'impact_vel';
            obj.parameters(3).discretization = 0.1;
            obj.parameters(3).lengthscale = 0.2;
            obj.parameters(3).lower = -0.8; %m/s
            obj.parameters(3).upper = -0.2; 

            obj.parameters(4).name = 'step_length';
            obj.parameters(4).discretization = 0.05;
            obj.parameters(4).lengthscale = 0.05;
            obj.parameters(4).lower = 0.2; % in m
            obj.parameters(4).upper = 0.4; 
            
            obj.parameters(5).name = 'max_height_tau';
            obj.parameters(5).discretization = 0.1;
            obj.parameters(5).lengthscale = 0.05;
            obj.parameters(5).lower = 0.4; % in m
            obj.parameters(5).upper = 0.7; 
                        
            for i = 1:length(obj.parameters)
                obj.parameters(i).actions = obj.parameters(i).lower:obj.parameters(i).discretization:obj.parameters(i).upper;
                obj.parameters(i).num_actions = length(obj.parameters(i).actions);
            end

        end
        
    end
    
end