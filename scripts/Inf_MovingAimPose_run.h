ArmControl()
{
sleep 5000;
HipAim=0;
}


Run()
{
	while (1)
		{
		
			if (IsProne==1||fear>0||transported==1)
			{
			sleep 1000;
			}
			
			if (bAiming==0)
			{
				start-script ArmControl();
			}
			
			if (bMoving==1 && IsProne==0 && fear<=0)
			{
			InAimStance=0;
			Turn lthigh to z-axis <0> speed <120>*PRONE_SPEED; 	
			turn lleg to z-axis <0> speed <120>*PRONE_SPEED;
			turn lleg to y-axis <0> speed <120>*PRONE_SPEED;
			turn rleg to z-axis <0> speed <120>*PRONE_SPEED;
			turn rleg to y-axis <0> speed <120>*PRONE_SPEED;
			turn rthigh to y-axis <0> speed <120>*PRONE_SPEED;						
			Turn rthigh to z-axis <0> speed <120>*PRONE_SPEED;
			Turn lthigh to z-axis <0> speed <120>*PRONE_SPEED;
			turn lthigh to y-axis <0> speed <120>*PRONE_SPEED;
			call-script WeaponReady();	
			turn pelvis to y-axis <0> speed <40>*RUN_SPEED;
			turn pelvis to x-axis <4> speed <40>*RUN_SPEED;
			turn torso to x-axis <4> speed <40>*RUN_SPEED;
			if (HipAim==0)
			{
			turn torso to y-axis <-20> speed <5>*RUN_SPEED;
			}
					if (InAimStance==0)
					{
				move pelvis to y-axis [0.0] speed <100>*RUN_SPEED;
					}
			}
			
				if (bMoving==1 && IsProne==0 && fear<=0)
			{
			Turn rleg to x-axis <85> speed<30>*WALK_SPEED;	
			Turn lleg to x-axis <55> speed<40>*WALK_SPEED;
			Turn rthigh to x-axis <-60> speed<20>*WALK_SPEED;
			Turn lthigh to x-axis <20> speed<20>*WALK_SPEED;			
		wait-for-move pelvis along y-axis;
				if (InAimStance==0)
					{
			move pelvis to y-axis [1.25] speed <100>*RUN_SPEED;
					}
			}
			
				if (bMoving==1 && IsProne==0 && fear<=0)
			{
			Turn rleg to x-axis <45> speed<60>*WALK_SPEED;
		wait-for-turn lthigh around x-axis;
		if (HipAim==0)
		{
			turn torso to y-axis <20> speed <5>*RUN_SPEED;
		}
				if (InAimStance==0)
					{
				move pelvis to y-axis [0.0] speed <100>*RUN_SPEED;
					}
			Turn lleg to x-axis <85> speed<30>*WALK_SPEED;
			Turn rleg to x-axis <55> speed<40>*WALK_SPEED;
			Turn lthigh to x-axis <-60> speed<20>*WALK_SPEED;
			}
			
				if (bMoving==1 && IsProne==0 && fear<=0)
			{
			Turn rthigh to x-axis <20> speed<20>*WALK_SPEED;
		wait-for-move pelvis along y-axis;
		if (InAimStance==0)
			{
			move pelvis to y-axis [1.25] speed <100>*RUN_SPEED;
			}
			Turn lleg to x-axis <45> speed<60>*WALK_SPEED;	
		wait-for-turn rthigh around x-axis;
			}
			
			if (bMoving==0 && IsProne==0 && fear<=0 && InAimStance==0)
			{
			HipAim=0;
			move pelvis to y-axis [0.0] speed <100>*RUN_SPEED;
			turn pelvis to x-axis <0> speed <10>*RUN_SPEED;
			turn torso to x-axis <0> speed <10>*RUN_SPEED;
			wait-for-turn rthigh around x-axis;
			turn rthigh to x-axis <0> speed <100>*RUN_SPEED;
			wait-for-turn lthigh around x-axis;
			turn lthigh to x-axis <0> speed <100>*RUN_SPEED;
			turn lleg to x-axis <0> speed <100>*RUN_SPEED;
			turn rleg to x-axis <0> speed <100>*RUN_SPEED;
			}
			
					if (bMoving==0 && IsProne==0 && fear<=0 && InAimStance==1)
			{
			HipAim=0;
			sleep 100;
			}
			
											
		}
	}
