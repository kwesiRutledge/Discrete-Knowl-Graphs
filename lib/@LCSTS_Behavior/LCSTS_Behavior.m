classdef LCSTS_Behavior
	%Description:
	%	This is the behavior (sequences of actions and states) of the LCSTS.
	%	This will not be visible to the controller but is important for algorithmic purposes.
	%
	%Member Functions:
	%	LCSTS_Behavior()
	%	eq() [ == ]
	%	extend_behavior()
	%
	%Usage:
	%	behavior0 = LCSTS_Behavior( lcsts , s_vec , a_vec )

	
	properties(SetAccess = protected)
		s_seq;
		m_seq;
		a_seq;
		t;
	end

	methods

		function beh = LCSTS_Behavior( lcsts , s_vec , m_vec , a_vec )
			%Description:
			%	This is the behavior (sequences of actions and states) of the LCSTS.
			%	This will not be visible to the controller but is important for algorithmic purposes.
			%
			%Usage:
			%	behavior0 = LCSTS_Behavior( lcsts , s_vec , m_vec , a_vec )
			%
			%Inputs:
			%	lcsts - An LCSTS object.
			%	s_vec - A vector representing a sequence of states in the LCSTS.
			%			The first state s_vec(1) is the state at time t=1 (initial state).
			%			The second state s_vec(2) is the state at time t=2, etc.
			%			Each state (s_vec(i)) is an INDEX for one of the states in lcsts.
			%	m_vec - A vector representing a sequence of modes in the LCSTS that explains the transitions
			%			of the sequence in s_vec (along with the information in a_vec).
			%	a_vec - A vector representing a sequence of actions that can be applied in the LCSTS.

			%% Input Processing
			if ~isa(lcsts,'LCSTS')
				error('Input lcsts is not a ''LCSTS'' object.')
			end

			if length(s_vec) ~= (length(a_vec)+1)
				error('There should be one more state in the state vector than there is in the action vector.')
			end

			if length(s_vec) ~= (length(m_vec)+1) && length(s_vec) ~= (length(m_vec))
				error('There should be one more state in the state vector than there are modes in the mode vector.')
			end

			if ~any(s_vec(1) == lcsts.Init)
				error('The initial state of the behavior s_vec is not in the initial state set of the input LCSTS.')
			end

			for s_idx = 1:(length(s_vec)-1)
				%Check to make sure that each state in the sequence is within the 'post' of the previous state
				if ~any( lcsts.post(s_vec(s_idx) , a_vec(s_idx) , m_vec( s_idx )) == s_vec(s_idx+1) )
					error('This sequence of states is invalid.')
				end
			end

			%% Algorithm

			beh.s_seq = s_vec;
			beh.m_seq = m_vec;
			beh.a_seq = a_vec;

			beh.t = length(s_vec);

		end

		function tf = eq( obj , beh1 )
			%Description:
			%	This method defines the == operator.
			%	Two behaviors are equal if their 's_seq', 'm_seq' and 'a_seq' fields are identical.
			%
			%Usage:
			%	tf = eq( beh0 , beh1 )
			%	tf = (beh0 == beh1)

			%% Algorithm %%

			tf = all(obj.s_seq == beh1.s_seq) && all(obj.m_seq == beh1.m_seq) && all(obj.a_seq == beh1.a_seq);

		end

		function [beh_set] = extend_behavior( varargin )
			%Description:
			%	This method "extends" the input behavior (i.e. finds all behaviors that can occur
			%	one step after this behavior) if possible.
			%
			%Usage:
			%	beh_set = beh_in.extend_behavior()

			%% Input Processing %%
			beh_in = varargin{1};

			%% Algorithm %%

		end

	end

end