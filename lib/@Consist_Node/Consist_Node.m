classdef Consist_Node
	%Description:
	%	A Consistency Node for a given Language Constrained Switched Transition System.
	%
	%Usage:
	%	cn = Consist_Node(t,L,Y)
	%
	%Member Variables:
	%	BehaviorSet: 			The possible sequences of states that correspond with this node.
	%	t: 						The time associated with this node.
	%	ConsistentInformation: 	The information which unites the set of behaviors.
	
	properties
		BehaviorSet;
		t;
		ConsistentInformation;
	end

	methods

		function C_Node = Consist_Node(varargin)
			%Description:
			%	A Consistency Node can be defined as a tuple of the time (t) at which the consistency decision is made and
			%	the information (information_Set) that is being held at time t.
			%	Because this node is designed for discrete state spaces, we can also define the set of states that are associated with this node!
			%
			%Usage:
			%	node = Consist_Node(beh_list_in,info_set)
			%	node = Consist_Node(beh_list_in,info_set,parent_node_idx)
			%
			%Inputs:
			%	T - A set of TransSyst objects.

			%% Input Processing %%

			beh_list_in = varargin{1};
			info_set = varargin{2};

			switch nargin
				case 2
					parent_node_idx = [];
					child_nodes_idcs = []; 
				case 3
					parent_node_idx = varargin{3};
					child_nodes_idcs = []; 
				case 4
					parent_node_idx = varargin{3};
					child_nodes_idcs = varargin{4};
				otherwise
					error('Unexpected number of arguments.')
			end

			%% Input Checking %%

			if ~isa(beh_list_in,'LCSTS_Behavior')
				error('The behavior in ''beh_list_in'' should be of type LCSTS_Behavior.')
			end

			%% Algorithm
			C_Node.BehaviorSet = beh_list_in; 
			C_Node.t = beh_list_in(1).t;
			C_Node.ConsistentInformation = info_set;

		end

		function [ tf ] = contains_behavior( obj , beh_query )
			%Description:
			%	Identifies if the provided behavior (beh_query) exists in the Consistency Node.
			%
			%Usage:
			%	tf = cn.contains_behavior( lcsts_beh0 )

			%% Input Processing %%

			%% Algorithm %%
			tf = false;

			for beh_idx = 1:length(obj.BehaviorSet)
				if obj.BehaviorSet(beh_idx) == beh_query
					tf = true;
				end
			end

		end

	end

end