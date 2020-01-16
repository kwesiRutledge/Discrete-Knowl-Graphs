function [results] = lcsts_experiment5( varargin )
	%lcsts_experiment5.m
	%
	%Description:
	%	Testing the behavior of class inheritance.

	disp(' ')
	disp('LCSTS Experiment 5')
	disp('Testing the idea of class inheritance for a TransSyst modification.')
	disp(' ')

	%% Create Dummy Class

	%% Input Processing

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%

	temp = dummy_graph(1,2);
	temp2 = child_graph(1,2);
	disp('Created both objects.')
	disp(' ')

	disp('Now calling dummy_graph.say_something()...')
	temp.say_something();
	disp(' ')

	disp('Now calling child_graph.say_something()...')
	temp2.say_something();
	disp(' ')

	%%%%%%%%%%%%%
	%% Results %%
	%%%%%%%%%%%%%

	results.dg = temp;
	results.cg = temp2;

	disp('Saving Results.')
	disp('Ending Experiment 5.')
	disp(' ')
end