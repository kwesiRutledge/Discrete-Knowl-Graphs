function [results] = lcsts_experiment6( varargin )
	%lcsts_experiment6.m
	%
	%Description:
	%	Testing the behavior of class inheritance.

	disp(' ')
	disp('LCSTS Experiment 6')
	disp('Testing the idea of class inheritance for a TransSyst modification.')
	disp(' ')

	%% Create Dummy Class

	%% Input Processing

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%

	temp = TransSyst(3,3);

	message1 = 'All states in the initial state set must be in the allowable range. (s0 >= 1)';
	message2 = 'All states in the initial state set must be in the allowable range. (s0 <= n_s)';
	message3 = 'The number of atomic propisitions must be at least 1.';
	message4 = 'n_AP must be a whole number.';
	message5 = 'The dimensions of the matrix L should be as appropriate according to n_s and n_AP.';
	message6 = 'The labelling matrix should only contain zeros and ones.';

	try
		disp('1. Trying to create a Transition System ''TransSyst_v2(3,3,-1,3,3)''. ')
		temp2 = TransSyst_v2(3,3,-1,3,3)
	catch e 
		disp(['  + Error Message: ' e.message ])
		disp('  + This should be properly caught because the initial state set ''-1'' is not in the proper range.')
		assert(strcmp(message1,e.message))
	end

	try
		disp('2. Trying to create a Transition System ''TransSyst_v2(3,3,4,3,3)''. ')
		temp3 = TransSyst_v2(3,3,4,3,3);
	catch e 
		disp(['  + Error Message: ' e.message ])
		disp('  + This should be properly caught because the initial state set ''4'' is not in the proper range.')
		assert(strcmp(message2,e.message))
	end

	try
		disp('3. Trying to create a Transition System ''TransSyst_v2(3,3,1,-1,3)''. ')
		temp3 = TransSyst_v2(3,3,1,-1,3);
	catch e 	
		disp(['  + Error Message: ' e.message ])
		disp('  + This should be properly caught because the number of atomic propositions ''-1'' is not in the proper range.')
		assert(strcmp(message3,e.message))
	end

	try
		disp('4. Trying to create a Transition System ''TransSyst_v2(3,3,1,2.3,3)''. ')
		temp4 = TransSyst_v2(3,3,1,2.3,3);
	catch e 	
		disp(['  + Error Message: ' e.message ])
		disp('  + This should be properly caught because the number of atomic propositions ''2.3'' is not a whole number.')
		assert(strcmp(message4,e.message))
	end

	try
		disp('5. Trying to create a Transition System ''TransSyst_v2(3,3,1,2.3,3)''. ')
		temp5 = TransSyst_v2(3,3,1,3,3);
	catch e 	
		disp(['  + Error Message: ' e.message ])
		disp('  + This should be properly caught because the labelling relation L is not the proper size [3x3].')
		assert(strcmp(message5,e.message))
	end

	try
		disp('6. Trying to create a Transition System ''TransSyst_v2(3,3,1,2.3,[1,1,1;0,0,0;1,2,1])''. ')
		temp6 = TransSyst_v2(3,3,1,3,[1,1,1;0,0,0;1,2,1]);
	catch e 	
		disp(['  + Error Message: ' e.message ])
		disp('  + This should be properly caught because the labelling relation L contains more than just ones and zeros.')
		assert(strcmp(message6,e.message))
	end

	temp7 = TransSyst_v2(3,3,1,3,zeros(3,3));


	%%%%%%%%%%%%%
	%% Results %%
	%%%%%%%%%%%%%

	results.ts1 = temp;
	results.ts_v2 = temp7;

	disp('Saving Results.')
	disp('Ending Experiment 6.')
	disp(' ')
end