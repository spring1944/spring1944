RestoreFromPinned()
{
		Turn pelvis to x-axis <90> speed <40>*PRONE_SPEED; //20
		Turn rthigh to x-axis <0> speed <120>*PRONE_SPEED;
		Turn rthigh to y-axis <0> speed <120>*PRONE_SPEED;
		Turn rthigh to z-axis <10> speed <120>*PRONE_SPEED;
		Turn rleg to x-axis <35> speed <120>*PRONE_SPEED;
		
		turn lthigh to y-axis <0> speed <120>*PRONE_SPEED;
		Turn lthigh to x-axis <0> speed <120>*PRONE_SPEED;
		Turn lthigh to z-axis <-10> speed <120>*PRONE_SPEED;
		Turn lleg to x-axis <35> speed <120>*PRONE_SPEED;
		
		turn ruparm to x-axis <180> speed <120>*PRONE_SPEED;
			
		turn luparm to x-axis <180> speed <120>*PRONE_SPEED;
		turn lloarm to z-axis <40> speed <120>*PRONE_SPEED;

	wait-for-turn lloarm around z-axis;
		Turn pelvis to x-axis <65> speed <60>*PRONE_SPEED;
		
		Turn head to x-axis <-60> speed <120>*PRONE_SPEED;
	
		Turn ruparm to x-axis <-85> speed <120>*PRONE_SPEED;
		Turn ruparm to y-axis <0> speed <120>*PRONE_SPEED;
		turn ruparm to z-axis <-50> speed <120>*PRONE_SPEED;
		
		Turn rloarm to x-axis <-100> speed <120>*PRONE_SPEED;
		Turn rloarm to y-axis <0> speed <120>*PRONE_SPEED;
		Turn rloarm to z-axis <0> speed <120>*PRONE_SPEED;
		
		turn luparm to x-axis <-140> speed <120>*PRONE_SPEED;
		turn luparm to y-axis <0> speed <120>*PRONE_SPEED;
		turn luparm to z-axis <35> speed <120>*PRONE_SPEED;
		
		turn lloarm to x-axis <0> speed <120>*PRONE_SPEED;
		turn lloarm to y-axis <0> speed <120>*PRONE_SPEED;
		turn lloarm to z-axis <0> speed <120>*PRONE_SPEED;
		
		turn gun to x-axis <30> speed <120>*PRONE_SPEED;
		turn gun to y-axis <30> speed <120>*PRONE_SPEED;
		turn gun to z-axis <0> speed <120>*PRONE_SPEED;
		if (fear < PinnedLevel) 
		{
		SET LOS_RADIUS to 13;
		IsPinned=0;
		}
}

Pinned() //hit the dirt and kiss your ass goodbye...
{
	IsPinned=1;
	SET LOS_RADIUS to 4;
	turn torso to x-axis <0> speed <120>*PRONE_SPEED; 
	turn torso to y-axis <0> speed <120>*PRONE_SPEED; 
	turn torso to z-axis <0> speed <120>*PRONE_SPEED; 
			
	Move pelvis to y-axis [-2.25] speed <1520>*PRONE_SPEED;
	Turn pelvis to x-axis <90> speed <40>*PRONE_SPEED; //20
	Turn pelvis to z-axis <0> speed <40>*PRONE_SPEED; 
	
	turn head to x-axis <20> speed <70>*PRONE_SPEED;
	turn head to y-axis <0> speed <70>*PRONE_SPEED;
	turn head to z-axis <0> speed <70>*PRONE_SPEED;
		
	Turn rthigh to x-axis <0> speed <120>*PRONE_SPEED;
	Turn rthigh to y-axis <0> speed <120>*PRONE_SPEED;
	Turn rthigh to z-axis <10> speed <120>*PRONE_SPEED;
	
	Turn rleg to x-axis <0> speed <120>*PRONE_SPEED;
	
	turn lthigh to y-axis <0> speed <120>*PRONE_SPEED;
	Turn lthigh to x-axis <0> speed <120>*PRONE_SPEED;
	Turn lthigh to z-axis <-10> speed <120>*PRONE_SPEED;
	
	Turn lleg to x-axis <0> speed <120>*PRONE_SPEED;
	
	turn ruparm to x-axis <180> speed <120>*PRONE_SPEED;
	turn ruparm to y-axis <0> speed <120>*PRONE_SPEED;
	turn ruparm to z-axis <0> speed <120>*PRONE_SPEED;
	
	turn rloarm to x-axis <0> speed <120>*PRONE_SPEED;
	turn rloarm to y-axis <0> speed <120>*PRONE_SPEED;
	turn rloarm to z-axis <-60> speed <120>*PRONE_SPEED;
	
	turn luparm to x-axis <180> speed <120>*PRONE_SPEED;
	turn luparm to y-axis <0> speed <120>*PRONE_SPEED;
	turn luparm to z-axis <0> speed <120>*PRONE_SPEED;
	
	
	turn lloarm to x-axis <0> speed <120>*PRONE_SPEED;
	turn lloarm to y-axis <0> speed <120>*PRONE_SPEED;
	turn lloarm to z-axis <40> speed <120>*PRONE_SPEED;
	wait-for-turn head around x-axis;
}