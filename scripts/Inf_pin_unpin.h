RestoreFromPinned()
{
		sleep desync;	
		Turn pelvis to x-axis <90> speed <160>; //20
		Turn rthigh to x-axis <0> speed <480>;
		Turn rthigh to y-axis <0> speed <480>;
		Turn rthigh to z-axis <10> speed <480>;
		Turn rleg to x-axis <35> speed <480>;
		
		turn lthigh to y-axis <0> speed <480>;
		Turn lthigh to x-axis <0> speed <480>;
		Turn lthigh to z-axis <-10> speed <480>;
		Turn lleg to x-axis <35> speed <480>;
		
		turn ruparm to x-axis <180> speed <480>;
			
		turn luparm to x-axis <180> speed <480>;
		turn lloarm to z-axis <40> speed <480>;

	wait-for-turn lloarm around z-axis;
		Turn pelvis to x-axis <65> speed <240>;
		
		Turn head to x-axis <-60> speed <480>;
	
		Turn ruparm to x-axis <-85> speed <480>;
		Turn ruparm to y-axis <0> speed <480>;
		turn ruparm to z-axis <-50> speed <480>;
		
		Turn rloarm to x-axis <-100> speed <480>;
		Turn rloarm to y-axis <0> speed <480>;
		Turn rloarm to z-axis <0> speed <480>;
		
		turn luparm to x-axis <-140> speed <480>;
		turn luparm to y-axis <0> speed <480>;
		turn luparm to z-axis <35> speed <480>;
		
		turn lloarm to x-axis <0> speed <480>;
		turn lloarm to y-axis <0> speed <480>;
		turn lloarm to z-axis <0> speed <480>;
		
		turn gun to x-axis <30> speed <480>;
		turn gun to y-axis <30> speed <480>;
		turn gun to z-axis <0> speed <480>;
		IsPinned=0;
		sleep 50;
}

Pinned() //hit the dirt and kiss your ass goodbye...
{
	sleep desync;
	IsPinned=1;
	turn torso to x-axis <0> speed <480>; 
	turn torso to y-axis <0> speed <480>; 
	turn torso to z-axis <0> speed <480>; 
			
	Move pelvis to y-axis [-2.25] speed <6080>;
	Turn pelvis to x-axis <90> speed <160>; //20
	Turn pelvis to z-axis <0> speed <160>; 
	
	turn head to x-axis <20> speed <280>;
	turn head to y-axis <0> speed <280>;
	turn head to z-axis <0> speed <280>;
		
	Turn rthigh to x-axis <0> speed <480>;
	Turn rthigh to y-axis <0> speed <480>;
	Turn rthigh to z-axis <10> speed <480>;
	
	Turn rleg to x-axis <0> speed <480>;
	
	turn lthigh to y-axis <0> speed <480>;
	Turn lthigh to x-axis <0> speed <480>;
	Turn lthigh to z-axis <-10> speed <480>;
	
	Turn lleg to x-axis <0> speed <480>;
	
	turn ruparm to x-axis <180> speed <480>;
	turn ruparm to y-axis <0> speed <480>;
	turn ruparm to z-axis <0> speed <480>;
	
	turn rloarm to x-axis <0> speed <480>;
	turn rloarm to y-axis <0> speed <480>;
	turn rloarm to z-axis <-60> speed <480>;
	
	turn luparm to x-axis <180> speed <480>;
	turn luparm to y-axis <0> speed <480>;
	turn luparm to z-axis <0> speed <480>;
	
	
	turn lloarm to x-axis <0> speed <480>;
	turn lloarm to y-axis <0> speed <480>;
	turn lloarm to z-axis <40> speed <480>;

	sleep 100;
}