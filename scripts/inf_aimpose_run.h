Stand()
{
			move pelvis to y-axis [0.0] now;
			turn pelvis to x-axis <0> now;
			turn pelvis to y-axis <0> now;
			turn pelvis to z-axis <0> now;
			turn ground to x-axis <0> now;
			turn ground to y-axis <0> now;

			turn torso to x-axis <0> now;
			turn torso to y-axis <0> now;
			turn torso to z-axis <0> now;

			turn rthigh to x-axis <0> now;
			turn rthigh to y-axis <0> now;
			turn rthigh to z-axis <0> now;

			turn lthigh to x-axis <0>now;
			turn lthigh to y-axis <0>now;
			turn lthigh to z-axis <0>now;

			turn lleg to x-axis <0> now;
			turn lleg to y-axis <0> now;
			turn lleg to z-axis <0> now;

			turn rleg to x-axis <0> now;
			turn rleg to y-axis <0> now;
			turn rleg to z-axis <0> now;
			if (bAiming==0) call-script WeaponReady();
}
Run()
{
signal RUNSTOP;
set-signal-mask RUNSTOP;

Desync=rand(0,100);
	if (fear>0 || transported==1) signal RUNSTOP;
	call-script Stand();
	turn torso to x-axis <7> now;
	sleep Desync;
	while (bMoving)
		{
				if (bMoving==1)
			{
			Turn rleg to x-axis <85> speed<540>;	
			Turn rthigh to x-axis <-60> speed<270>;
			Turn lthigh to x-axis <30> speed<270>;
			Turn torso to y-axis <10> speed <90>;	
		wait-for-move pelvis along y-axis;		
			move pelvis to y-axis [0.4] speed <2800>;
		wait-for-move pelvis along y-axis;
			turn rleg to x-axis <10> speed <630>;
			move pelvis to y-axis [0] speed <2800>;
			}		
				if (bMoving==1)
			{
			Turn lleg to x-axis <85> speed<540>;
			Turn lthigh to x-axis <-60> speed<270>;
			turn rthigh to x-axis <30> speed <270>;
			Turn torso to y-axis <-10> speed <90>;
		wait-for-move pelvis along y-axis;
			move pelvis to y-axis [0.4] speed <2800>;	
		wait-for-move pelvis along y-axis;
			turn lleg to x-axis <10> speed <630>;
			move pelvis to y-axis [0] speed <2800>;

			}
			
		}
			if (bMoving==0)
			{
			sleep Desync;
			call-script Stand();
			call-script WeaponReady();
			sleep STANDTIME; 
				if (bMoving==0 || transported==0)
					{
					set CLOAKED to TRUE;
					start-script TakeCover();
					}
			}
}