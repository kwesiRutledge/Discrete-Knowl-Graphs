function [results] = lcsts_experiment7( varargin )
	%lcsts_experiment7.m
	%
	%Description:
	%	Testing the computation of winning sets for Transition Systems.

	exp_num = 7;

	disp(' ')
	disp(['LCSTS Experiment ' num2str(exp_num)])
	disp('Testing the idea of winning sets in Transition Systems.')
	disp(' ')

	%% Input Processing

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%


	%%Create a Strange Transition System
	n_s = 4;
	n_a = 2;
	n_AP = 2;
	temp7 = TransSyst_v2(n_s,n_a,1,n_AP,zeros(n_s,n_AP));

	%Add transitions to make a triangle
	temp7.add_transition(1,2,1);
	temp7.add_transition(2,3,1);
	temp7.add_transition(3,1,1);

	%Adding some extra transitions
	temp7.add_transition(3,4,1);
	temp7.add_transition(4,1,1);

	temp7.add_transition(1,1,2);
	temp7.add_transition(2,2,2);
	temp7.add_transition(3,3,2);
	temp7.add_transition(4,4,2);

	post3 = [temp7.post(3,1),temp7.post(3,2)];

	disp(['The following states follow TransSyst_v2''s state 3: ' num2str(unique(post3) ) ])

	%% Practicing How to Compute Winning Sets
	temp7.add_state();
	temp7.add_transition(4,5,1);
	state_set = [1];

	%Use loops to find which states can be controlled to reach the state set.
	% S_i = state_set;
	% alg_converged = false;
	% while ~alg_converged
	% 	cand_states = setdiff([1:temp7.n_s],S_i);
	% 	for s = cand_states
	% 		for a = 1:temp7.n_a
	% 			for s_p = S_i
	% 				if (temp7.state1 == s) && (temp7.action == a) && (temp7.state2 == s_p)
	% 					%It is possible that there is a transition with this initial state and action?
	% 					s_idcs = find(temp7.state1 == s);
	% 					a_idcs = find(temp7.action == a);
	% 					sp_idcs = find(temp7.state2 == s_p)
	% 					if ~isempty(intersect(intersect(s_idcs,a_idcs),sp_idcs))

	% 					end
	% 				end
	% 			end
	% 		end
	% 	end

	% end

	[V, C] = temp7.win_eventually_or_persistence(state_set);

	%%%%%%%%%%%%%
	%% Results %%
	%%%%%%%%%%%%%

	results.ts = temp7;

	disp('Saving Results.')
	disp(['Ending Experiment' num2str(7) '.'])
	disp(' ')
end