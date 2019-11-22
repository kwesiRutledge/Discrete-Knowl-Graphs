classdef LCSTS
	%Description:
	%	This is an object for Language Constrained Switched Transition Systems
	%	It is built on top of the arcs toolbox's TransSys
	
	properties
		TransSystems;
		Language;
		n_y;
		ObsvFcn;
	end

	methods

		function L_sys = LCSTS(T,L,n_y,M)
			%Description:
			%	The Language Constrained Switched Transition System is a tuple
			%	of four different things:
			%		- T, a set of transition systems
			%		- L, a language that describes switching rules
			%		- n_y, the number of unique allowable measurements
			%		- M, a set of measurement functions.
			%
			%Usage:
			%
			%
			%Inputs:
			%	T - A set of TransSyst objects.

			%% Input Processing
			if ~isa(T,'TransSyst')
				error('Input T is not a ''TransSyst'' object.')
			end

			if ~isa(L,'Language')
				error('Input L is not a ''Language'' object.')
			end

			%% Algorithm

			L_sys.TransSystems = T;
			L_sys.Language = L;
			L_sys.n_y = n_y;
			L_sys.ObsvFcn = M;

		end

	end

end