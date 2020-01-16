function [results] = lcsts_experiment8( varargin )
	%lcsts_experiment8.m
	%
	%Description:
	%	Testing the behavior object.
	%

	disp(' ')
	disp('Started lcsts_experiment8.m')
	disp('This experiment contains tests of the ''LCSTS_Behavior'' object. ')

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
	L_arb = Language([1,2,3,1,2,3],ones(1,6),[1,2,2,1,1,2]);

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

	disp('- Testing if LCSTS_Behavior will detect improper initial state.')
	try
		b0 = LCSTS_Behavior( L0 , [3] , [] , [] );
	catch e
		assert(strcmp(e.message,'The initial state of the behavior s_vec is not in the initial state set of the input LCSTS.'))
		disp('  + The catch block properly identified the issue with the LCSTS_Behavior initialization.')
	end

	disp('- Testing if LCSTS_Behavior will detect improper sequence lengths.')
	try
		b1 = LCSTS_Behavior( L0 , [1,2] , [1,2] , [1,2] )
	catch e 
		assert( strcmp( e.message , 'There should be one more state in the state vector than there is in the action vector.' ) )
		disp('  + The catch block properly identified the issue with the different lengths.')
	end

	disp('- Testing post() for LCSTS.')
	post0 = L0.post( 1 , 1 , 1 );
	assert( post0 == 2 )
	disp(['  + L0.post(1,1,1) should be 2. Function output is: ' num2str(post0) ])

	post1 = L0.post( 1 , 1 );
	assert( all(post1 == [2,3,5]) )
	disp(['  + L0.post(1,1) shoulud be [2,5,3]. Function output is ' num2str(post1) ])

	post2 = L0.post( 1 );
	assert( all(post2 == [1,2,3,5]) )
	disp(['  + L0.post(1) shoulud be [1,2,3,5]. Function output is ' num2str(post2) ])

	disp('- Testing if LCSTS_Behavior will detect that a mode signal is not of the proper size.')
	try
		b2 = LCSTS_Behavior( L0 , [1,2,3] , [1] , [1,2] );
	catch e 
		assert( strcmp( e.message , 'There should be one more state in the state vector than there are modes in the mode vector.' ) );
		disp('  + The catch block properly identified the mode signal was not of appropriate length.');
	end

	disp('- Testing if LCSTS_Behavior will detect that the behavior needs to start in the init set.')
	try
		b3 = LCSTS_Behavior( L0 , [3,2,3] , [1,1] , [1,2] )
	catch e
		assert( strcmp( e.message , 'The initial state of the behavior s_vec is not in the initial state set of the input LCSTS.' ) );
		disp('  + The catch block properly identified that the initial state was not in the initial state set.')
	end

	disp('- Testing if LCSTS_Behavior will detect that the behavior is not a correct sequence according to the transition sequence.')
	try
		b4 = LCSTS_Behavior( L0 , [1,2,3] , [1,1] , [1,2] )
	catch e 
		assert( strcmp( e.message , 'This sequence of states is invalid.' ) );
		disp('  + The catch block properly identified that the sequence of states is not proper.')
	end

	disp('- Testing if LCSTS_Behavior accepts proper behaviors.')
	try
		b5 = LCSTS_Behavior( L0 , [1,2,3] , [1,1] , [1,1] );
		assert(true)
		disp('  + A proper behavior was correctly defined.')
	catch e 
		error('The LCSTS Behavior is not operating as desired.')
	end


	%%%%%%%%%%%%%%%%%%
	%% Save Results %%
	%%%%%%%%%%%%%%%%%%

	results.lcsts = L0;
	results.post0 = post0;
	results.post1 = post1;
	results.post2 = post2;

	disp('- Results saved.')
	disp('Completed lcsts_experiment8.m')
	disp(' ')

end