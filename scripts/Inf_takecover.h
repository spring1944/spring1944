TakeCover()
{
set-signal-mask 0;

		SET MAX_SPEED to [0.00001];
		SET ARMORED to TRUE;
		//bMoving=0;

	if (IsProne == 0)
	{
	
				IsProne=1;
		SET UPRIGHT to 0;
		turn pelvis to y-axis <0> speed <150>*PRONE_SPEED;
		turn pelvis to z-axis <0> speed <150>*PRONE_SPEED;
		
		Move pelvis to y-axis [-0.3] speed <150>*PRONE_SPEED;
		turn rthigh to x-axis <-40> speed <150>*PRONE_SPEED;
		turn rleg to x-axis <70> speed <100>*PRONE_SPEED;
		turn lthigh to x-axis <-40> speed <100>*PRONE_SPEED;
		turn lleg to x-axis <70> speed <100>*PRONE_SPEED;
		turn torso to y-axis <0> speed <150>*PRONE_SPEED;
		turn torso to x-axis <20> speed <150>*PRONE_SPEED;
		turn head to x-axis <-20> speed <150>*PRONE_SPEED;

		turn ruparm to y-axis <0> speed <150>*PRONE_SPEED;
		turn ruparm to z-axis <0> speed <150>*PRONE_SPEED;
		turn ruparm to x-axis <-70> speed <100>*PRONE_SPEED;

		turn rloarm to x-axis <0> speed <150>*PRONE_SPEED;
		turn rloarm to y-axis <0> speed <150>*PRONE_SPEED;
		turn rloarm to z-axis <-55> speed <150>*PRONE_SPEED;

		turn luparm to y-axis <0> speed <100>*PRONE_SPEED;
		turn luparm to z-axis <0> speed <100>*PRONE_SPEED;
		turn luparm to x-axis <-75> speed <100>*PRONE_SPEED;
		turn lloarm to x-axis <0> speed <150>*PRONE_SPEED; 

	wait-for-turn ruparm around x-axis;
	wait-for-turn luparm around x-axis;
	wait-for-turn rthigh around x-axis;
	wait-for-turn lthigh around x-axis;	
		turn torso to x-axis <0> speed <120>*PRONE_SPEED;
		turn torso to y-axis <0> speed <120>*PRONE_SPEED;
		turn torso to z-axis <0> speed <120>*PRONE_SPEED;

		Move pelvis to y-axis [0.525] speed <1520>*PRONE_SPEED;
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
		Move pelvis to y-axis [-2.25] speed <2250>*PRONE_SPEED;
		Turn pelvis to x-axis <65> speed <60>*PRONE_SPEED;
	wait-for-turn pelvis around x-axis;
	wait-for-move pelvis along y-axis;
		
		Turn head to x-axis <-60> speed <120>*PRONE_SPEED;
		turn head to y-axis <0> speed <120>*PRONE_SPEED;
		turn head to z-axis <0> speed <120>*PRONE_SPEED;
	
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


		sleep 100;
		return(0);
}

RestoreAfterCover() //get up out of the dirt. also controls going into pinned mode.
{
	
		if (fear > PinnedLevel)
		{
			call-script Pinned();
			sleep 100;
		} 




		if (fear <=0 && IsProne==1)
		{	
			Turn pelvis to x-axis <55> speed <120>*PRONE_SPEED;
			Turn rthigh to z-axis <0> speed <120>*PRONE_SPEED;
			Turn lthigh to z-axis <0> speed<120>*PRONE_SPEED;
	
			turn ruparm to z-axis <0> speed <120>*PRONE_SPEED;
	
			Turn rloarm to x-axis <-80> speed <120>*PRONE_SPEED;
			Turn rloarm to z-axis <0> speed <120>*PRONE_SPEED;
			Turn rloarm to y-axis <0> speed <120>*PRONE_SPEED;

			Turn luparm to x-axis <-85> speed <120>*PRONE_SPEED;
			turn luparm to y-axis <0> speed <120>*PRONE_SPEED;

			Turn rthigh to x-axis <-85> speed <120>*PRONE_SPEED;
			Turn lthigh to x-axis <-40> speed <120>*PRONE_SPEED;

			Move pelvis to y-axis [-0.75] speed [120]*PRONE_SPEED;
			Turn rleg to x-axis <80> speed <120>*PRONE_SPEED;
			Turn lleg to x-axis <80> speed <120>*PRONE_SPEED;

		
		wait-for-turn lleg around x-axis;
			Move pelvis to y-axis [0] speed [120]*PRONE_SPEED;
		call-script WeaponReady();

			turn torso to x-axis <0> speed <120>*PRONE_SPEED;
			turn torso to y-axis <0> speed <120>*PRONE_SPEED;
			turn torso to z-axis <0> speed <120>*PRONE_SPEED;
			Turn head to x-axis <0> speed <120>*PRONE_SPEED;
			Turn head to y-axis <0> speed <120>*PRONE_SPEED;
			Turn head to z-axis <0> speed <120>*PRONE_SPEED;
		
			Turn rleg to x-axis <0> speed <120>*PRONE_SPEED;
			Turn rleg to y-axis <0> speed <120>*PRONE_SPEED;
			Turn rleg to z-axis <0> speed <120>*PRONE_SPEED;
		
			Turn lleg to x-axis <0> speed <120>*PRONE_SPEED;
			Turn lleg to y-axis <0> speed <120>*PRONE_SPEED;
			Turn lleg to z-axis <0> speed <120>*PRONE_SPEED;
		
			Turn pelvis to x-axis <0> speed <120>*PRONE_SPEED;
			Turn pelvis to y-axis <0> speed <120>*PRONE_SPEED;
			Turn pelvis to z-axis <0> speed <120>*PRONE_SPEED;
		
			Turn rthigh to x-axis <0> speed <120>*PRONE_SPEED;
			Turn rthigh to y-axis <0> speed <120>*PRONE_SPEED;
			Turn rthigh to z-axis <0> speed <120>*PRONE_SPEED;
		
			Turn lthigh to x-axis <0> speed <120>*PRONE_SPEED;
			Turn lthigh to y-axis <0> speed <120>*PRONE_SPEED;
			Turn lthigh to z-axis <0> speed <120>*PRONE_SPEED;
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
				set MAX_SPEED to [0.8];
				call-script MoveCheck();
		
		}
		return (1);
		sleep 100;
	}