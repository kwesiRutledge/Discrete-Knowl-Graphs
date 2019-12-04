function [results] = run_experiment( varargin )
	% 	run_experiment.m
	%	Description:
	%		Used to call each of the experiments in the experiments folder programmatically.
	%
	%	Inputs:
	%
	%	Usage:
	%		run_experiment(1)

	% Add experiments and functions to the path
	include_libs('arcs')

	if isempty(strfind(path,'./functions/'))
		addpath('./lib/')
		addpath('./lib/systems/')
	end

	try
		empty_function_experiments_lcsts()
	catch
		addpath('./experiments/')
	end

	%% Constants
	base_name = 'lcsts_experiment';

	test_nums = varargin{1};
	if nargin < 2
		test_inputs = cell(size(varargin{1}));
	else
		test_inputs = varargin{2};
	end

	%%Run tests from 
	for k = 1 : length(test_nums)
		results{k} = eval([base_name num2str(test_nums(k)) '(' test_inputs{k} ')' ]);
	end

end