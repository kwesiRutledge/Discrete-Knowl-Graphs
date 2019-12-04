function [results] = lcsts_experiment3( varargin )
	%lcsts_experiment3.m
	%
	%Description:
	%	Testing the find_all_words_with_pref() function.

	%% Input Processing
	switch nargin
		case 1
			verbosity = varargin{1};
		otherwise
			disp('No inputs given.')
	end
	

	if ~exist('verbosity')
		verbosity = 1;
	end

	%%%%%%%%%%%%%%%
	%% Constants %%
	%%%%%%%%%%%%%%%

	L = Language([1,2,3,4],[1,2,2,2],[1,2,3,3]);

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%

	disp('Experiment 3')
	disp('Testing the function find_all_words_with_pref() for the Language object.')
	disp(' ')
	L 	%Display information about L

	disp('Which words have the prefix 1? (It should be all)')
	[ ~ , L1 ] = L.find_all_words_with_pref( [1] );
	disp(L1)

	disp('Which words have the prefix 2? (It should be none)')
	[ ~ , L2 ] = L.find_all_words_with_pref( [2] );
	disp(L2)

	disp('Which words have the prefix [1,2,3]? (It should be two.)')
	[ ~ , L123 ] = L.find_all_words_with_pref( [1,2,3] );
	disp(L123)	

	disp('Which words have the prefix [1,2]? (It should be all.)')
	[ ~ , L12 ] = L.find_all_words_with_pref( [1,2] );
	disp(L12)	


	%%%%%%%%%%%%%
	%% Results %%
	%%%%%%%%%%%%%

	results.L = L;
	results.L1 = L1;
	results.L2 = L2;
	results.L123 = L123;
	results.L12 = L12;

	

end