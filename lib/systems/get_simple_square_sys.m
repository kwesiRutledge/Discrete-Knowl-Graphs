function [out_sys,sq_dim] = get_simple_square_sys(varargin)
	%get_simple_square_sys.m
	%Description:
	%	This generates a simple square system
	%
	%Usage:
	%	[ lcsts0 , sq_dim ] = get_simple_square_sys('verbosity',0)
	%	[ lcsts0 , sq_dim ] = get_simple_square_sys('init_flag',false)


	%%%%%%%%%%%%%%%%%%%%%%
	%% Input Processing %%
	%%%%%%%%%%%%%%%%%%%%%%

	arg_idx = 1;
	while( arg_idx <= nargin )
		switch varargin{arg_idx}
			case 'verbosity'
				verbosity = varargin{arg_idx+1};
				arg_idx = arg_idx + 2;
			case 'sq_dim'
				sq_dim = varargin{arg_idx+1};
				arg_idx = arg_idx + 2;
			otherwise
				error(['Unrecognized input to get_simple_square_sys(): ' varargin{arg_idx} ])
		end
	end

	if ~exist('verbosity')
		verbosity = 0;
	end

	if ~exist('init_flag')
		init_flag = true;
	end

	%%%%%%%%%%%%%%%
	%% Constants %%
	%%%%%%%%%%%%%%%

	if ~exist('sq_dim')
		sq_dim = 20; %Numbers of rows / columns in the square state space.
	end

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
				error('This switch statement should never reach this condition!')
		end
		%Compute Transition Matrices
		ts_i.trans_array_enable();

		TransSyst_arr = [TransSyst_arr,ts_i];

	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Create Initial State Set %%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if init_flag
		s0_width = 8;
		S0 = [];
		for row_idx = (sq_dim/2)+[-(s0_width/2)+1:(s0_width/2)]
			for col_idx = (sq_dim/2)+[-(s0_width/2)+1:(s0_width/2)]
				S0 = [S0; sub2ind([sq_dim,sq_dim],row_idx,col_idx) ];
			end
		end
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

	L1 = Language(word1,word2,word3);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Create a number of outputs %%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	bands = [1,1,1,2,2,3];
	n_y = length(bands);

	if sum(bands) ~= (sq_dim/2)
		error('Bands do not match the dimension of the square!')
	end

	M_i = zeros(ts_i.n_s,n_y);
	for state_idx = 1:ts_i.n_s
		for band_idx = 1:length(bands)
			band_lim_low = sum(bands([1:band_idx]));
			band_lim_high = (sq_dim) - sum(bands([1:band_idx]));

			[agent_coords(1),agent_coords(2)] = ind2sub([sq_dim,sq_dim],state_idx);

			if agent_coords(1) <= band_lim_low
				if agent_coords(2) <= band_lim_low
					M_i(sub2ind( [sq_dim,sq_dim] , agent_coords(1) , agent_coords(2) ) , band_idx ) = 1;
					break;
				elseif agent_coords(2) >= band_lim_high
					M_i(sub2ind( [sq_dim,sq_dim] , agent_coords(1) , agent_coords(2) ) , band_idx ) = 1;
					break;
				end
			elseif agent_coords(1) >= band_lim_high
				if agent_coords(2) <= band_lim_low
					M_i(sub2ind( [sq_dim,sq_dim] , agent_coords(1) , agent_coords(2) ) , band_idx ) = 1;
					break;
				elseif agent_coords(2) >= band_lim_high
					M_i(sub2ind( [sq_dim,sq_dim] , agent_coords(1) , agent_coords(2) ) , band_idx ) = 1;
					break;
				end
			end		
		end
	end

	M = [];
	for ts_idx = 1:length(TransSyst_arr)
		M(:,:,ts_idx) = M_i;
	end

	%%%%%%%%%%%%%%%%%%%%%
	%% Create an LCSTS %%
	%%%%%%%%%%%%%%%%%%%%%

	out_sys = LCSTS(TransSyst_arr,L1,n_y,M);

	if init_flag
		out_sys = LCSTS(TransSyst_arr,L1,n_y,M,S0);
	end

end