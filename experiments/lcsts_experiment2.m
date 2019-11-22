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
	s0_width = 2;
	S0 = [];
	for row_idx = (sq_dim/2)+[-(s0_width/2)+1:(s0_width/2)]
		for col_idx = (sq_dim/2)+[-(s0_width/2)+1:(s0_width/2)]
			S0 = [S0, sub2ind([sq_dim,sq_dim],row_idx,col_idx) ];
		end
	end

	%%%%%%%%%%%%%
	%% Results %%
	%%%%%%%%%%%%%

	results.lcsts = lcsts0;
	results.S0 = S0;

end