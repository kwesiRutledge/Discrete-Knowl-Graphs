function [results] = lcsts_experiment4( varargin )
	%lcsts_experiment4.m
	%
	%Description:
	%	Finding "post" of 

	%% Input Processing
	switch nargin
		case 1
			verbosity = varargin{1};
		otherwise
			disp('No inputs given.');
	end
	

	if ~exist('verbosity')
		verbosity = 1;
	end

	%%%%%%%%%%%%%%%
	%% Constants %%
	%%%%%%%%%%%%%%%

	L = Language([1,2,3,4],[1,2,2,2],[1,2,3,3]);
	[lcsts0,sq_dim] = get_simple_square_sys();

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%

	disp(' ')
	disp('Experiment 4')
	disp('Testing the creation of LCSTS Behaviors.')
	disp(' ')
	%L 	%Display information about L

	try
		b0 = LCSTS_Behavior( lcsts0 , 1 , [] )
	catch
		disp('- The first behavior was correctly detected as being incorrect. (The initial state should be in the LCSTS initial state set.)')
	end

	b1 = LCSTS_Behavior( lcsts0 , lcsts0.Init(1) , [] );
	disp('- The second behavior was correct.')

	disp(' ')
	disp('Computing post() for the behavior.')
	b_set0 = [];

	mode_set = lcsts0.get_modes_at_t( b1.t );
	next_state_arr = [];
	for mode_idx = 1:length(mode_set)
		for action_idx = 1:lcsts0.TransSystems(mode_idx).n_a
			temp_state_arr = lcsts0.TransSystems(mode_idx).post(b1.s_seq(end),action_idx);
		end
	end


	%%%%%%%%%%%%%
	%% Results %%
	%%%%%%%%%%%%%

	results.L = L;
	results.b0_exists = exist('b0');
	results.b1 = b1; 

end