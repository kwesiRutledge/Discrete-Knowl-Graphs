function [results] = lcsts_experiment1( varargin )
	%lcsts_experiment1.m
	%
	%Description:
	%	Testing the first experiments for creating a Language-Constrained
	%	Switched Transition System.
	%

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

	sq_dim = 20; %Numbers of rows / columns in the square state space.
	num_cardinal_directions = 4; 	%Number of cardinal directions North, East, South, West

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Create Four Transition Systems %%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	TransSyst_arr = [];

	for ts_idx = 1:num_cardinal_directions
		%This loop constructs transition systems with identical state and action spaces.

		ts_i = TransSyst(0,0);
		for state_idx = 1:sq_dim.^2
			ts_i.add_state();
		end

		%Create two actions:
		%	1 = Resist Pull of Electromag
		%	2 = Allow Pull
		for action_idx = 1:2
			ts_i.add_action();
		end

		%The transition system for each direction will be slightly different.
		switch ts_idx
			case 1
				%NORTH
				%Corresponds to the north. There is a strong northerly wind.
				for row_idx = 1:sq_dim
					for col_idx = 1:sq_dim
						%Define this states index
						state_idx = (row_idx-1)*sq_dim + col_idx;

						%Add transitions for each of the actions resist
						ts_i.add_transition(state_idx,state_idx,1);

						%Add Transitions for each of the actions: Allow
						if row_idx ~= 1
							ts_i.add_transition(state_idx,state_idx-sq_dim,2);
						else
							ts_i.add_transition(state_idx,state_idx,2);
						end

					end
				end
			case 2
				%EAST
				%Corresponds to the east. There is a strong easterly wind.
				for row_idx = 1:sq_dim
					for col_idx = 1:sq_dim
						%Define this states index
						state_idx = (row_idx-1)*sq_dim + col_idx;

						%Add transitions for each of the actions resist
						ts_i.add_transition(state_idx,state_idx,1);

						%Add Transitions for each of the actions: Allow
						if col_idx ~= sq_dim
							ts_i.add_transition(state_idx,state_idx+1,2);
						else
							ts_i.add_transition(state_idx,state_idx,2);
						end

					end
				end
			case 3
				%SOUTH
				%Corresponds to the south. There is a strong southern wind.
				for row_idx = 1:sq_dim
					for col_idx = 1:sq_dim
						%Define this states index
						state_idx = (row_idx-1)*sq_dim + col_idx;

						%Add transitions for each of the actions resist
						ts_i.add_transition(state_idx,state_idx,1);

						%Add Transitions for each of the actions: Allow
						if row_idx ~= sq_dim
							ts_i.add_transition(state_idx,state_idx+sq_dim,2);
						else
							ts_i.add_transition(state_idx,state_idx,2);
						end

					end
				end
			case 4
				%WEST
				%Corresponds to the west. There is a strong western wind.
				for row_idx = 1:sq_dim
					for col_idx = 1:sq_dim
						%Define this states index
						state_idx = (row_idx-1)*sq_dim + col_idx;

						%Add transitions for each of the actions resist
						ts_i.add_transition(state_idx,state_idx,1);

						%Add Transitions for each of the actions: Allow
						if col_idx ~= 1
							ts_i.add_transition(state_idx,state_idx-1,2);
						else
							ts_i.add_transition(state_idx,state_idx,2);
						end

					end
				end
			otherwise
				body
		end
		%Compute Transition Matrices
		ts_i.trans_array_enable();

		TransSyst_arr = [TransSyst_arr,ts_i];

	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Summarize Transition Systems %%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	for ts_idx = 1:length(TransSyst_arr)
		if verbosity > 0
			disp(['There are ' num2str(TransSyst_arr(ts_idx).n_s) ' states and ' num2str(TransSyst_arr(ts_idx).n_a) ' actions in Transition System ' num2str(ts_idx) '.'])
		end
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Create a Simple Language %%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	word1 = [1,1,1,2,2,2];
	word2 = [2,2,3,3,1,1];
	word3 = [2,4,1,1,2,4];

	L1 = Language(word1,word2,word3)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Create a number of outputs %%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	n_y = (sq_dim/2)^2;

	M_i = [];
	temp_mat_i = kron(eye(sq_dim/2),ones(2,1));
	temp_mat_i = [ temp_mat_i ; temp_mat_i ];

	M_i = kron(eye(sq_dim/2),temp_mat_i);

	M = [];
	for ts_idx = 1:length(TransSyst_arr)
		M(:,:,ts_idx) = M_i;
	end

	%%%%%%%%%%%%%%%%%%%%%
	%% Create an LCSTS %%
	%%%%%%%%%%%%%%%%%%%%%

	sys = LCSTS(TransSyst_arr,L1,n_y,M);

	%%%%%%%%%%%%%
	%% Results %%
	%%%%%%%%%%%%%

	results.ts_i = ts_i;
	results.TransSyst_arr = TransSyst_arr;
	results.L = L1;
	results.M = M;
	results.LCSTS = sys;

end