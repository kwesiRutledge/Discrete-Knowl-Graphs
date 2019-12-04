function [results] = lcsts_experiment2( varargin )
	%lcsts_experiment2.m
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

	[lcsts0,sq_dim] = get_simple_square_sys();

	%Select the set of states that is in the center of the state space with width
	s0_width = 8;
	S0 = [];
	for row_idx = (sq_dim/2)+[-(s0_width/2)+1:(s0_width/2)]
		for col_idx = (sq_dim/2)+[-(s0_width/2)+1:(s0_width/2)]
			S0 = [S0; sub2ind([sq_dim,sq_dim],row_idx,col_idx) ];
		end
	end

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%

	disp(' ')
	disp('Experiment 2')
	disp('Testing the synthesis of a consistency graph for the problem.')
	disp(' ')

	%Partition S0 by the states that are uniquely identifiable.
	first_mode_arr = []; 	%Set of modes that lead a word in lcsts0.Language
	for word_idx = 1:cardinality(lcsts0.Language)
		first_mode_arr = [first_mode_arr,lcsts0.Language.words{word_idx}(1)];
	end
	first_mode_arr = unique(first_mode_arr);

	first_meas_arr = [];
	for s_idx = 1:length(S0)
		for mode_idx = 1:length(first_mode_arr)
			first_meas_arr = [first_meas_arr,find(lcsts0.ObsvFcn(S0(s_idx),:,mode_idx))];
		end
	end
	first_meas_arr = unique(first_meas_arr);

	disp([ num2str(length(first_meas_arr)) ' unique measurements can be detected at time 0.'])
	disp(' ')

	%Create consistency nodes
	N0 = [];
	for meas_idx = 1:length(first_meas_arr)
		temp_meas = first_meas_arr(meas_idx);
		[ ~ , temp_lang ] = lcsts0.Language.find_all_words_with_pref(temp_meas);

		N0 = [N0,Consist_Node( 0 , temp_lang , temp_meas )];
	end

	%% Create Looping Architecture
	N_t = N0;

	for nt_idx = 1:length(N_t)
		n_i = N_t(nt_idx);
		temp_y_seq = n_i.Y_History;

		%Generate every behavior that could have led to this output sequence


	end


	%%%%%%%%%%%%%
	%% Results %%
	%%%%%%%%%%%%%

	results.lcsts = lcsts0;
	results.S0 = S0;
	results.N0 = N0;
	results.first_mode_arr = first_mode_arr;
	results.first_meas_arr = first_meas_arr;

end