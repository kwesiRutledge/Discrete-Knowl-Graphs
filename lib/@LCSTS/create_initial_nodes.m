function [ N0 ] = create_initial_nodes( lcsts , info_type_in )
	%Description:
	%	This function takes the initial conditions of the system

	%% Input Processing %%

	if ~isa(lcsts,'LCSTS')
		error('First input should be an LCSTS object.')
	end

	supported_info_types = {'ConsistencySet','ConsistencySetHistory'};
	if ~any(strcmp(supported_info_types,info_type_in))
		error(['The info_type ''' info_type_in ''' is not currently supported'])
	end

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%

	N0 = [];
	eb_exists = false;
	for word_idx = 1:lcsts.Language.cardinality()
		%For each word, identify what external behaviors
		for state_idx = lcsts.Init
			%For each state in lcsts.Init create a Behavior
			temp_beh = LCSTS_Behavior( lcsts , [ state_idx ] , [lcsts.Language.words{word_idx}(1)] , [] );

			temp_ext_beh = LCSTS_ExternalBehavior( lcsts , [ lcsts.obs(state_idx,1,word_idx) ] , [] );

			%Search to see if there exists a node with the same information in the list.
			node_with_consist_info = [];

			for n_idx = 1:length(N0)
				if N0(n_idx).ConsistentInformation == temp_ext_beh
					eb_exists = true;
					node_with_consist_info = [node_with_consist_info,n_idx]; 
				end
			end

			if eb_exists
				%If the behavior temp_beh does not already exist in the node, then add it.
				if ~N0(node_with_consist_info).contains_behavior( temp_beh )
					N0(node_with_consist_info).BehaviorSet = [ N0(node_with_consist_info).BehaviorSet, temp_beh ];
				end
				
			else
				%Create Node
				N0 = [N0,Consist_Node( [ temp_beh ] , temp_ext_beh)];
			end

			%Reset for next iteration of the loop
			eb_exists = false;
		end
	end

end