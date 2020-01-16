function [results] = lcsts_experiment9( varargin )
	%lcsts_experiment9.m
	%
	%Description:
	%	Testing the ways we produce behavior objects.
	%

	experiment_name = 'lcsts_experiment9.m';

	disp(' ')
	disp(['Started ' experiment_name '.' ])
	disp('This experiment contains extensions for the ''LCSTS_Behavior'' object. ')

	%% Input Processing %%

	%%%%%%%%%%%%%%%%%%%%%%
	%% Create Constants %%
	%%%%%%%%%%%%%%%%%%%%%%

	%% Create a very simple LCSTS
	n_s = 5;
	n_a = 2; %2 actions: Go and Stay
	Trans_Syst_Array = [];

	%Create Transition System 1
	ts1 = TransSyst(n_s,2);
	ts1.add_transition(1,2,1);
	ts1.add_transition(2,3,1);
	ts1.add_transition(3,4,1);
	ts1.add_transition(4,5,1);
	ts1.add_transition(5,1,1);

	for state_num = 1:n_s
		ts1.add_transition(state_num,state_num,2);
	end

	% Create Transition System 2

	ts2 = TransSyst(n_s,n_a);
	ts2.add_transition(1,5,1);
	ts2.add_transition(5,4,1);
	ts2.add_transition(4,3,1);
	ts2.add_transition(3,2,1);
	ts2.add_transition(2,1,1);

	for state_num = 1:n_s
		ts2.add_transition(state_num,state_num,2);
	end

	% Create Transition System 3
	ts3 = TransSyst(n_s,n_a);
	ts3.add_transition(1,3,1);
	ts3.add_transition(2,4,1);
	ts3.add_transition(3,5,1);
	ts3.add_transition(4,1,1);
	ts3.add_transition(5,2,1);

	for state_num = 1:n_s
		ts3.add_transition(state_num,state_num,2);
	end

	Trans_Syst_Array = [ ts1 , ts2 , ts3 ];

	% Create an arbitrary language.
	L_arb = Language([1,2,3,1,2,3],ones(1,6),[1,2,2,1,1,2],[3,2,1,3,2,1]);

	n_y = 4;

	M = zeros(n_s,n_y,length(Trans_Syst_Array));
	M(:,:,1) = [ 1 , 0 , 0 , 0 ;
				 1 , 0 , 0 , 0 ;
				 0 , 1 , 0 , 0 ;
				 0 , 0 , 1 , 0 ;
				 0 , 0 , 0 , 1  ];

	M(:,:,2) = [ 1 , 0 , 0 , 0 ;
				 0 , 1 , 0 , 0 ;
				 0 , 0 , 1 , 0 ;
				 0 , 0 , 0 , 1 ;
				 1 , 0 , 0 , 0 ];

	M(:,:,3) = [ 0 , 1 , 0 , 0 ;
				 0 , 0 , 1 , 0 ;
				 0 , 0 , 0 , 1 ;
				 1 , 0 , 0 , 0 ;
				 1 , 0 , 0 , 0 ];

	Init = [ 1 , 2 ];

	L0 = LCSTS(Trans_Syst_Array, L_arb, n_y , M , Init);

	disp('- Created LCSTS.')

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%

	disp('- Testing the observation function.')
	obs1 = L0.obs( 1 , 1 , 1 ) == 1;
	assert( obs1 == 1 )
	disp(['  + The observation of state 1 at time 1 in mode signal 1 should be 1. Is it? ' num2str(obs1) ])

	c_mode_signal = 1;
	y0_list = [];
	for s0 = L0.Init
		y0_list = [ y0_list , L0.obs( s0 , 1 , L0.Language.words{c_mode_signal}(1) ) ];
	end
	y0_list = unique(y0_list);

	disp(['- Practicing the extraction of observations from Init given the current mode is mode #' num2str(c_mode_signal) ])
	disp(['  + The set of unique measurements is: ' num2str(y0_list) ])

	%% Creating the Initial Nodes using Init
	N0 = [];
	eb_exists = false;
	for word_idx = 1:L0.Language.cardinality()
		%For each word, identify what external behaviors
		for state_idx = L0.Init
			%For each state in L0.Init create a Behavior
			temp_beh = LCSTS_Behavior( L0 , [ state_idx ] , [] , [] );

			temp_ext_beh = LCSTS_ExternalBehavior( L0 , [ L0.obs(state_idx,1,word_idx) ] , [] );

			%Search to see if there exists a node with the same information in the list.
			node_with_const_info = [];
			for n_idx = 1:length(N0)
				if N0(n_idx).ConsistentInformation == temp_ext_beh
					eb_exists = true;
					node_with_const_info = [node_with_const_info,n_idx]; 
				end
			end

			if eb_exists
				%If the behavior temp_beh does not already exist in the node, then add it.
				if ~N0(node_with_const_info).contains_behavior( temp_beh )
					N0(node_with_const_info).BehaviorSet = [ N0(node_with_const_info).BehaviorSet, temp_beh ];
				end
				
			else
				%Create Node
				N0 = [N0,Consist_Node( [ temp_beh ] , temp_ext_beh)];
			end

			%Reset for next iteration of the loop
			eb_exists = false;
		end
	end
	disp(['  + The set of nodes created should contain 3 elements. Does it? length(N0) = ' num2str( length(N0) ) ])

	disp(['  + Testing a function which generates the initial nodes N0.'])
	N0_fcn = create_initial_nodes(L0,'ConsistencySet');

	disp(['    * Does it have the same length as N0 above?'])
	disp(['    * length( create_initial_nodes(L0,''ConsistencySet'') ) = ' num2str(length( N0_fcn ) ) ])

	disp('- Now creating a successor operator from each Consist_Node.')

	t = 1;
	for n_idx = 1:length(N0_fcn)
		n0 = N0_fcn(n_idx);
		beh_list{n_idx} = [];
		temp_beh_list = [];
		for beh_idx = 1:length(n0.BehaviorSet)
			beh_i = n0.BehaviorSet(beh_idx);

			% Extend Behavior
			curr_mode = beh_i.m_seq(end);
			for action_idx = 1:L0.TransSystems(curr_mode).n_a
				%Identify what the successor state is for the given action
				post_states = L0.post( beh_i.s_seq(end), action_idx , curr_mode );
				for post_idx = 1:length(post_states)
					temp_beh_list = [ temp_beh_list , ...
										LCSTS_Behavior( L0 , [ beh_i.s_seq,post_states(post_idx) ] , beh_i.m_seq , [beh_i.a_seq,action_idx] ) ];
				end
			end

		end

		%For each of these behaviors, select the next mode (if the current time is not the final time )
		if t ~= L0.Language.find_longest_length()
			for beh_idx = 1:length(temp_beh_list)
				beh_i = temp_beh_list(beh_idx);

				%Look at the last mode currently in beh_i
				curr_mode = beh_i.m_seq(end);

				%Use the language to find out what modes can follow it:
				following_modes = [];
				for word_idx = 1:L0.Language.cardinality()
					if L0.Language.words{word_idx}( beh_i.t-1 ) == curr_mode
						following_modes = [ following_modes , L0.Language.words{word_idx}( beh_i.t ) ];
					end
				end

				for foll_idx = 1:length(following_modes)
					beh_list{n_idx} = [	beh_list{n_idx}, ...
										LCSTS_Behavior( L0, beh_i.s_seq , [beh_i.m_seq,following_modes(foll_idx)] , beh_i.a_seq )];
				end
			end 
		end
	end

	% %Convert Initial State Set into a Set of Possible External Behaviors
	% for word_idx = 1:L0.Language.cardinality()
	% 	for state_idx = L0.Init

	% 	end
	% end

	% %Initial State to External Behavior Sets
	% int_beh_set = cell( length(LCSTS.TransSystems) , LCSTS.Language.find_longest_length() );
	% for mode_idx = 1:length(LCSTS.TransSystems)
	% 	for t = 1:LCSTS.Language.find_longest_length()+1
	% 		if t == 1
	% 			int_beh_set{mode_idx,t} = LCSTS.Init;
	% 		else
	% 			int_beh_set{mode_idx,t} = post( int_beh_set{mode_idx,t-1} );
	% 		end
	% 	end
	% end

	%%%%%%%%%%%%%%%%%%
	%% Save Results %%
	%%%%%%%%%%%%%%%%%%

	results.lcsts = L0;
	results.N0 = N0;
	results.N0_fcn = N0_fcn;
	results.beh_list = beh_list;
	

	disp('- Results saved.')
	disp(['Completed ' experiment_name '.' ])
	disp(' ')

end