classdef LCSTS
	%Description:
	%	This is an object for Language Constrained Switched Transition Systems
	%	The Language Constrained Switched Transition System is a tuple
	%	of four different things:
	%		- T, a set of transition systems
	%		- L, a language that describes switching rules
	%		- n_y, the number of unique allowable measurements
	%		- M, a set of measurement functions.
	%	It is built on top of the arcs toolbox's TransSys
	%
	%Usage:
	%	S = LCSTS(TransSystem,Langage,n_y,ObsvFcn)
	%
	%Member Variables:
	%	TransSystems 	= a set of transition systems
	%	Language 		= a Language that describes switching rules
	%	n_y 			= the number of unique allowable measurements
	%	ObsvFcn 		= a simple matrix representing how the states get mapped to a single (?) observation
	%	Init 			= The initial states of the system.

	
	properties
		TransSystems;
		Language;
		n_y;
		ObsvFcns;
		Init;
		n_modes;
	end

	methods

		function L_sys = LCSTS(varargin)
			%Description:
			%	The Language Constrained Switched Transition System is a tuple
			%	of four different things:
			%		- T, a set of transition systems
			%		- L, a language that describes switching rules
			%		- n_y, the number of unique allowable measurements
			%		- M, a set of measurement functions.
			%
			%Usage:
			%	S = LCSTS(T,L,n_y,M)
			%	S = LCSTS(T,L,n_y,M,Init)
			%
			%Inputs:
			%	T - A set of TransSyst objects.

			%%%%%%%%%%%%%%%%%%%%%%
			%% Input Processing %%
			%%%%%%%%%%%%%%%%%%%%%%

			T = varargin{1};
			L = varargin{2};
			n_y = varargin{3};
			M = varargin{4};

			if nargin == 5
				Init = varargin{5};
			end

			%%%%%%%%%%%%%%%%%%%%%
			%% Checking Inputs %%
			%%%%%%%%%%%%%%%%%%%%%

			if ~isa(T,'TransSyst')
				error('Input T is not a ''TransSyst'' object.')
			end

			if ~isa(L,'Language')
				error('Input L is not a ''Language'' object.')
			end

			n_ts = length(T); %The number of Transition Systems

			%There must be as many dimensions in the observation function tensor as there are modes.
			%(The measurement equation is mode-dependent!)

			if size(M,3) ~= n_ts
				error(['The observation function contains ' num2str(size(M,3)) ' modes while there are ' num2str(n_ts) ' Transition Systems! The number of each should be the same!' ])
			end

			%Make sure that there are the same number of states in each transition system.
			ns_arr = [];
			for ts_idx = 1:length(T)
				ns_arr = [ns_arr,T(ts_idx).n_s];
			end

			if ~all(ns_arr(1) == ns_arr)
				error('There are not the same number of states in every transition system.')
			end

			%%%%%%%%%%%%%%%
			%% Algorithm %%
			%%%%%%%%%%%%%%%

			L_sys.TransSystems = T;
			L_sys.n_modes = length(T);
			L_sys.Language = L;
			L_sys.n_y = n_y;
			L_sys.ObsvFcns = M;

			if ~exist('Init')
				L_sys.Init = [1:T(1).n_s];
			else
				L_sys.Init = Init;
			end

		end

		function mode_list = get_modes_at_t(obj,t_in)
			%Description:
			%	Find all of the modes that can occur at time 't_in' and return them.
			%	Note: The time starts at 0 in this code.
			%
			%Usage:
			%	mode_list = lcsts.get_modes_at_t( 2 )

			mode_list = obj.Language.get_all_symbols_at_idx(t_in+1);

		end

		function obsv_list = obs(varargin)
			%Description:
			%	Finds the observations associated with the provided state
			%	(at a given mode and/or time, if provided)
			%
			%Usage
			%	obsvs = lcsts.obs( s_in )
			%	obsvs = lcsts.obs( s_in , t )
			%	obsvs = lcsts.obs( s_in , t , word_idx )

			%% Input Processing %%

			obj = varargin{1};
			s_list = varargin{2};

			switch nargin
				case 2
					t_list = [1:obj.Language.find_longest_length()];
					word_list = [1:obj.n_modes];
				case 3
					t_list = varargin{3};
					word_list = [1:obj.n_modes];
				case 4
					t_list = varargin{3};
					word_list = varargin{4};
				otherwise
					error('Unexpected number of arguments!')
			end

			%% Algorithm %%

			obsv_list = [];
			for state = s_list
				for t = t_list
					for word_idx = word_list
						obsv_list = [obsv_list, find( obj.ObsvFcns(state,:, obj.Language.words{word_idx}(t)) )];
					end
				end
			end

		end

	end

end