classdef LCSTS_ExternalBehavior
	%Description:
	%	This is the external behavior (sequences of actions and observations) of the LCSTS.
	%	This will be visible to the controller and is important for generating consistency
	%	sets.
	%
	%Member variables:
	%	- y_seq: The sequence of observations that have occurred so far.
	%	- a_seq: The sequence of actions that the Transition System has taken.
	%	- t: The elapsed time.
	%
	%Usage:
	%	behavior0 = LCSTS_Behavior( lcsts , s_vec , a_vec )

	
	properties(SetAccess = protected)
		y_seq;
		a_seq;
		t;
	end

	methods

		function beh = LCSTS_ExternalBehavior( lcsts , y_vec , a_vec )
			%Description:
			%	This is the EXTERNAL behavior (sequences of actions and observations) of the LCSTS.
			%	This will be visible to the controller but is important for algorithmic purposes.
			%
			%Usage:
			%	behavior0 = LCSTS_Behavior( lcsts , s_vec , m_vec , a_vec )
			%
			%Inputs:
			%	lcsts - An LCSTS object.
			%	y_vec - A vector representing a sequence of observations in the LCSTS.
			%			The first observation y_vec(1) is the observation of the state at time t=1 (initial state).
			%			The second observation y_vec(2) is the observation of the state at time t=2, etc.
			%	a_vec - A vector representing a sequence of actions that can be applied in the LCSTS.

			%% Input Processing
			if ~isa(lcsts,'LCSTS')
				error('Input lcsts is not a ''LCSTS'' object.')
			end

			if length(y_vec) ~= (length(a_vec)+1)
				error('There should be one more state in the state vector than there is in the action vector.')
			end

			if (~all(y_vec <= lcsts.n_y)) || (~all(y_vec >= 1))
				error('There is an improper measurement in the input measurement vector.')
			end

			if (~all(a_vec <= lcsts.TransSystems(1).n_a)) || (~all(a_vec >= 1))
				error('There is an improper measurement in the input action vector.')
			end


			%% Algorithm

			beh.y_seq = y_vec;
			beh.a_seq = a_vec;

			beh.t = length(y_vec);

		end

		function tf = eq( obj , eb1 )
			%Description:
			%	This method defines the == operator.
			%	Two external behaviors are equal if their 'y_seq' and 'a_seq' fields are identical.
			%
			%Usage:
			%	tf = eq( eb0 , eb1 )
			%	tf = (eb0 == eb1)

			%% Algorithm %%

			tf = all(obj.y_seq == eb1.y_seq) && all(obj.a_seq == eb1.a_seq);

		end

	end

end