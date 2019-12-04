classdef Consist_Node
	%Description:
	%	A Consistency Node for a given Language Constrained Switched Transition System.
	%
	%Usage:
	%	cn = Consist_Node(t,L,Y)
	%
	%Member Variables:
	%	Y_History: 				The history of measurements that corresponds with this node.
	%	Feas_State_Histories: 	The possible sequences of states that correspond with this node.
	%	t: 						The time associated with this node.
	%	ModeSignalLang: 		The possible mode signals that could be leading to this measurement history.
	
	properties
		Y_History;
		Feas_State_Histories;
		t;
		ModeSignalLang;
	end

	methods

		function C_Node = Consist_Node(t_in,L,output_arr)
			%Description:
			%	A Consistency Node can be defined as a tuple of the time (t) at which the consistency decision is made and
			%	language of mode signals that can lead to that consistency decision being held at time t (L).
			%	Because this node is designed for discrete state spaces, we can also define the set of states that are associated with this node!
			%
			%Usage:
			%	cn0 = Consist_Node(t0,L0,S0)
			%
			%Inputs:
			%	T - A set of TransSyst objects.

			%% Input Processing
			if ~isa(L,'Language')
				error('Input L is not a ''Language'' object.')
			end

			%% Algorithm

			C_Node.ModeSignalLang = L;
			C_Node.t = t_in;
			C_Node.Y_History = output_arr;

		end

	end

end