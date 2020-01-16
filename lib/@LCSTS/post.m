function [succ_states] = post( varargin )
	%Description:
	%	Finds the successor states of a given state under different circumstances.
	%
	%Usage:
	%	succ_states = post( lcsts_in , s_in )
	%	succ_states = post( lcsts_in , s_in , a_in )
	%	succ_states = post( lcsts_in , s_in , a_in , mode_in )

	%% Input Processing %%
	lcsts_in = varargin{1};
	s_in = varargin{2};
	switch nargin 
	case 2
		a_list = [1:lcsts_in.TransSystems(1).n_a];
		mode_list = [1:length(lcsts_in.TransSystems)];
	case 3
		a_list = varargin{3};
		mode_list = [1:length(lcsts_in.TransSystems)];
	case 4
		a_list = varargin{3};
		mode_list = varargin{4};
	otherwise
		error('Unexpected number of inputs.')
	end

	%% Algorithm %%
	succ_states = uint32([]);
	for s_val = s_in
		for mode_val = mode_list
			for a_val = a_list
				succ_states = [succ_states, lcsts_in.TransSystems(mode_val).post( s_val , a_val ) ];
			end
		end
	end

	succ_states = unique(succ_states);

end