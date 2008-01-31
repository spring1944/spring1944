TakeCover()
{
set-signal-mask 0;

		signal RUNSTOP;
		SET MAX_SPEED to [0.00001];
		SET ARMORED to TRUE;
		//bMoving=0;

	if (IsProne == 0)
	{
		IsProne=1;
		signal RUNSTOP;
		SET UPRIGHT to 0;
		turn pelvis to y-axis <0> speed <600>;
		turn pelvis to z-axis <0> speed <600>;
		
		Move pelvis to y-axis [-0.3] speed <600>;
		turn rthigh to x-axis <-40> speed <600>;
		turn rleg to x-axis <70> speed <400>;
		turn lthigh to x-axis <-40> speed <400>;
		turn lleg to x-axis <70> speed <400>;
		turn torso to y-axis <0> speed <600>;
		turn torso to x-axis <20> speed <600>;
		turn head to x-axis <-20> speed <600>;

		turn ruparm to y-axis <0> speed <600>;
		turn ruparm to z-axis <0> speed <600>;
		turn ruparm to x-axis <-70> speed <400>;

		turn rloarm to x-axis <0> speed <600>;
		turn rloarm to y-axis <0> speed <600>;
		turn rloarm to z-axis <-55> speed <600>;

		turn luparm to y-axis <0> speed <400>;
		turn luparm to z-axis <0> speed <400>;
		turn luparm to x-axis <-75> speed <400>;
		turn lloarm to x-axis <0> speed <600>; 

	wait-for-turn ruparm around x-axis;
	wait-for-turn luparm around x-axis;
	wait-for-turn rthigh around x-axis;
	wait-for-turn lthigh around x-axis;	
		turn torso to x-axis <0> speed <480>;
		turn torso to y-axis <0> speed <480>;
		turn torso to z-axis <0> speed <480>;

		Move pelvis to y-axis [0.525] speed <6080>;
		Turn pelvis to x-axis <90> speed <160>;
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
		Move pelvis to y-axis [-2.25] speed <9001>; //should be 9000,
										// but this way its OVER 9000!!!!
		Turn pelvis to x-axis <65> speed <240>;
	wait-for-turn pelvis around x-axis;
	wait-for-move pelvis along y-axis;
		
		Turn head to x-axis <-60> speed <480>;
		turn head to y-axis <0> speed <480>;
		turn head to z-axis <0> speed <480>;
	
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
	wait-for-turn rthigh around x-axis;
	wait-for-turn rthigh around y-axis;
	wait-for-turn rthigh around z-axis;
	
	wait-for-turn lthigh around x-axis;
	wait-for-turn lthigh around y-axis;
	wait-for-turn lthigh around z-axis;
	
	wait-for-turn rleg around x-axis;
	
	wait-for-turn lleg around x-axis;
	
	wait-for-turn head around x-axis;
	
	wait-for-turn ruparm around x-axis;
	wait-for-turn ruparm around y-axis;
	wait-for-turn ruparm around z-axis;
	
	wait-for-turn luparm around x-axis;
	wait-for-turn luparm around y-axis;
	wait-for-turn luparm around z-axis;
	
	wait-for-turn rloarm around x-axis;
	wait-for-turn rloarm around y-axis;
	wait-for-turn rloarm around z-axis;
	
	wait-for-turn lloarm around x-axis;
	wait-for-turn lloarm around y-axis;
	wait-for-turn lloarm around z-axis;
	
	wait-for-turn gun around x-axis;
	wait-for-turn gun around y-axis;
	wait-for-turn gun around z-axis;
	}

		return(0);
}

RestoreAfterCover() //get up out of the dirt. also controls going into pinned mode.
{
		if (bAiming==1) return 0;
	
		if (fear > PinnedLevel)
		{
			call-script Pinned();
		} 




		if (fear <=0 AND IsProne==1)
		{	
			Turn pelvis to x-axis <55> speed <480>;
			Turn rthigh to z-axis <0> speed <480>;
			Turn lthigh to z-axis <0> speed<480>;
	
			turn ruparm to z-axis <0> speed <480>;
	
			Turn rloarm to x-axis <-80> speed <480>;
			Turn rloarm to z-axis <0> speed <480>;
			Turn rloarm to y-axis <0> speed <480>;

			Turn luparm to x-axis <-85> speed <480>;
			turn luparm to y-axis <0> speed <480>;

			Turn rthigh to x-axis <-85> speed <480>;
			Turn lthigh to x-axis <-40> speed <480>;

			Move pelvis to y-axis [-0.75] speed [480];
			Turn rleg to x-axis <80> speed <480>;
			Turn lleg to x-axis <80> speed <480>;

		
		wait-for-turn lleg around x-axis;
			Move pelvis to y-axis [0] speed [480];
		call-script WeaponReady();

			turn torso to x-axis <0> speed <480>;
			turn torso to y-axis <0> speed <480>;
			turn torso to z-axis <0> speed <480>;
			Turn head to x-axis <0> speed <480>;
			Turn head to y-axis <0> speed <480>;
			Turn head to z-axis <0> speed <480>;
		
			Turn rleg to x-axis <0> speed <480>;
			Turn rleg to y-axis <0> speed <480>;
			Turn rleg to z-axis <0> speed <480>;
		
			Turn lleg to x-axis <0> speed <480>;
			Turn lleg to y-axis <0> speed <480>;
			Turn lleg to z-axis <0> speed <480>;
		
			Turn pelvis to x-axis <0> speed <480>;
			Turn pelvis to y-axis <0> speed <480>;
			Turn pelvis to z-axis <0> speed <480>;
		
			Turn rthigh to x-axis <0> speed <480>;
			Turn rthigh to y-axis <0> speed <480>;
			Turn rthigh to z-axis <0> speed <480>;
		
			Turn lthigh to x-axis <0> speed <480>;
			Turn lthigh to y-axis <0> speed <480>;
			Turn lthigh to z-axis <0> speed <480>;
	wait-for-turn rthigh around x-axis;
	wait-for-turn rthigh around y-axis;
	wait-for-turn rthigh around z-axis;
	
	wait-for-turn lthigh around x-axis;
	wait-for-turn lthigh around y-axis;
	wait-for-turn lthigh around z-axis;
	
	wait-for-turn rleg around x-axis;
	
	wait-for-turn lleg around x-axis;
	
	wait-for-turn head around x-axis;
	
	wait-for-turn ruparm around x-axis;
	wait-for-turn ruparm around y-axis;
	wait-for-turn ruparm around z-axis;
	
	wait-for-turn luparm around x-axis;
	wait-for-turn luparm around y-axis;
	wait-for-turn luparm around z-axis;
	
	wait-for-turn rloarm around x-axis;
	wait-for-turn rloarm around y-axis;
	wait-for-turn rloarm around z-axis;
	
	wait-for-turn lloarm around x-axis;
	wait-for-turn lloarm around y-axis;
	wait-for-turn lloarm around z-axis;
	
	wait-for-turn gun around x-axis;
	wait-for-turn gun around y-axis;
	wait-for-turn gun around z-axis;
	wait-for-move pelvis along y-axis;
	wait-for-turn pelvis around x-axis;
	wait-for-turn pelvis around y-axis;
	wait-for-turn pelvis around z-axis;
				fear=0;
				IsProne=0;
				SET UPRIGHT TO 1;
				SET ARMORED to FALSE;
				set MAX_SPEED to [0.5];

				call-script WeaponReady();
				call-script MoveCheck();
		
		}
		return (1);
	}