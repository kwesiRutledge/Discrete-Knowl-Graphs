classdef TransSyst_v2 < TransSyst
	properties
		n_AP;
		L;
		S0;
	end
	methods
		function ts = TransSyst_v2( varargin )
			%Description:
			%
			%Usage:
			%	ts = TransSyst_v2( n_s , n_a , s0 , n_AP, L )
			%	ts = TransSyst_v2( n_s , n_a , s0 , n_AP, L , 'TransSyst_setting' , setting )
			%	ts = TransSyst_v2( n_s , n_a , s0 , n_AP, L , 'TransSyst_setting' , setting , 'TransSyst_encoding' , encoding_setting )

			%%%%%%%%%%%%%%%%%%%%%%
			%% Input Processing %%
			%%%%%%%%%%%%%%%%%%%%%%

			if nargin < 5
				error('Expecting at least 5 arguments.')
			end

			n_s = varargin{1};
			n_a = varargin{2};
			s0  = varargin{3};
			n_AP = varargin{4};
			L = varargin{5};

			arg_idx = 6;
			while arg_idx <= nargin
				switch varargin{arg_idx}
					case 'TransSyst_setting'
						setting = varargin{arg_idx+1};
						arg_idx = arg_idx + 2;
					case 'TransSyst_encoding'
						if ~exist('setting')
							error('TransSyst''s ''encoding'' flag may only be defined AFTER the setting flag is defined.')
						end
						encoding_setting = varargin{arg_idx+1};
						arg_idx = arg_idx + 2;
					otherwise
						error('Unrecognized additional flag.')
				end
			end

			%% Setting up the elements that are defined using TransSyst
			% if (~exist('setting'))
			% 	ts@TransSyst(n_s,n_a);
			% elseif exist('setting') && (~exist('encoding_setting'))
			% 	ts@TransSyst(n_s,n_a,setting);
			% else
			% 	ts@TransSyst(n_s,n_a,setting,encoding_setting);
			% end
			ts@TransSyst(n_s,n_a);

			%%%%%%%%%%%%%%%
			%% Algorithm %%
			%%%%%%%%%%%%%%%

			if any(s0 < 1)
				error('All states in the initial state set must be in the allowable range. (s0 >= 1)')
			elseif any(s0 > n_s)
				error('All states in the initial state set must be in the allowable range. (s0 <= n_s)')
			else
				ts.S0 = s0;
			end

			if (n_AP < 1)
				error('The number of atomic propisitions must be at least 1.')
			elseif (floor(n_AP) ~= n_AP)
				error('n_AP must be a whole number.')
			else
				ts.n_AP = n_AP;
			end

			if any( size(L) ~= [n_s,n_AP] )
				error('The dimensions of the matrix L should be as appropriate according to n_s and n_AP.')
			elseif prod(size(L)) ~= (sum(sum(L==0)) + sum(sum(L==1)))
				error('The labelling matrix should only contain zeros and ones.')
			else
				ts.L = L;
			end
				
		end
	end
end
