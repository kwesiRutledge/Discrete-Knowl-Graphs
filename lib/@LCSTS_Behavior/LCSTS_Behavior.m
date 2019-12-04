classdef LCSTS_Behavior
	%Description:
	%	This is the behavior (sequences of actions and states) of the LCSTS.
	%	This will not be visible to the controller but is important for algorithmic purposes.
	%
	%Usage:
	%	behavior0 = LCSTS_Behavior( lcsts , s_vec , a_vec )

	
	properties
		s_seq;
		a_seq;
	end

	methods

		function beh = LCSTS_Behavior( lcsts , s_vec , a_vec )
			%Description:
			%	This is the behavior (sequences of actions and states) of the LCSTS.
			%	This will not be visible to the controller but is important for algorithmic purposes.
			%
			%Usage:
			%	behavior0 = LCSTS_Behavior( lcsts , s_vec , a_vec )
			%
			%Inputs:
			%	lcsts - An LCSTS object.
			%	s_vec - A vector representing a sequence of states in the LCSTS.
			%			The first state s_vec(1) is the state at time t=1 (initial state).
			%			The second state s_vec(2) is the state at time t=2, etc.
			%			Each state (s_vec(i)) is an INDEX for one of the states in lcsts.
			%	a_vec - A vector representing a sequence of actions that can be applied in the LCSTS.

			%% Input Processing
			if ~isa(lcsts,'LCSTS')
				error('Input lcsts is not a ''LCSTS'' object.')
			end

			if length(s_vec) ~= (length(a_vec)+1)
				error('There should be one more state in the state vector than there is in the action vector.')
			end

			if ~any(s_vec(1) == lcsts.Init)
				error('The initial state of the behavior s_vec is not in the initial state set of the input LCSTS.')
			end

			%% Algorithm

			beh.s_seq = s_vec;
			beh.a_vec = a_vec;

		end

	end

end