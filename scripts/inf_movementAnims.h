AimRun() //running animation while aiming at a target.
//TODO: slow them down? and make a different anim
{
var pelviswait;
pelviswait = 150;
		start-script HipAim();
		//turn pelvis to x-axis <0> now;
		turn pelvis to y-axis <0> now;
		turn pelvis to z-axis <0> now;
	
		turn rthigh to y-axis <0> now;
		turn rthigh to z-axis <0> now;
		
		turn lthigh to y-axis <0> now;
		turn lthigh to z-axis <0> now;
		
		turn lleg to y-axis <0> now;
		turn lleg to y-axis <0> now;
		
		turn rleg to y-axis <0> now;
		turn rleg to z-axis <0> now;
	
		if (bMoving==1)
			{
			turn lleg to x-axis <85> speed <405>;
			turn lthigh to x-axis <-45> speed <200>;
			turn rthigh to x-axis <23> speed <200>;
		sleep pelviswait;
		//wait-for-move pelvis along y-axis;
			move pelvis to y-axis [0.3] speed <2100>;
		sleep pelviswait;	
	//	wait-for-move pelvis along y-axis;
			turn lleg to x-axis <10> speed <470>;
			move pelvis to y-axis [0] speed <2100>;
			}
		if (bMoving==1)
			{
			turn rleg to x-axis <85> speed <405>;	
			turn rthigh to x-axis <-45> speed <200>;
			turn lthigh to x-axis <23> speed <200>;
		sleep pelviswait;
		//wait-for-move pelvis along y-axis;		
			move pelvis to y-axis [0.3] speed <2100>;
		sleep pelviswait;
		//wait-for-move pelvis along y-axis;
			turn rleg to x-axis <10> speed <470>;
			move pelvis to y-axis [0] speed <2100>;
			}
			
}

Run() //basic jog when there is no fear or aiming
{
//set-signal-mask SIG_RUN;
var pelviswait;
pelviswait = rand(120, 140);
		turn pelvis to y-axis <0> now;
		turn pelvis to z-axis <0> now;
		
		turn torso to y-axis <0> now;
		turn torso to z-axis <0> now;
	
		turn rthigh to y-axis <0> now;
		turn rthigh to z-axis <0> now;
		
		turn lthigh to y-axis <0> now;
		turn lthigh to z-axis <0> now;
		
		turn lleg to y-axis <0> now;
		turn lleg to y-axis <0> now;
		
		turn rleg to y-axis <0> now;
		turn rleg to z-axis <0> now;
		//turn torso to x-axis <7> now;
		if (bMoving==0) sleep 50;	
		if (bMoving==1)
			{
			turn rleg to x-axis <85> speed <540>;	
			turn rthigh to x-axis <-60> speed <270>;
			turn lthigh to x-axis <30> speed <270>;
			turn torso to y-axis <10> speed <90>;
		sleep pelviswait;
	//	wait-for-move pelvis along y-axis;		
			move pelvis to y-axis [0.4] speed <2800>;
		sleep pelviswait;
		//wait-for-move pelvis along y-axis;
			turn rleg to x-axis <10> speed <630>;
			move pelvis to y-axis [0] speed <2800>;
			}
		//	sleep Desync;
		if (bMoving==0) sleep 50;
		if (bMoving==1)
			{
			turn lleg to x-axis <85> speed <540>;
			turn lthigh to x-axis <-60> speed <270>;
			turn rthigh to x-axis <30> speed <270>;
			turn torso to y-axis <-10> speed <90>;
		sleep pelviswait;
		//wait-for-move pelvis along y-axis;
			move pelvis to y-axis [0.4] speed <2800>;	
		sleep pelviswait;
	//	wait-for-move pelvis along y-axis;
			turn lleg to x-axis <10> speed <630>;
			move pelvis to y-axis [0] speed <2800>;
			}
		//	sleep Desync;
}

Crawl() //crawl under fire (moving, iFear>0, but not pinned)
//todo - fix the anim to not be sucky
{
turn pelvis to x-axis <90> now;
turn ground to x-axis <0> now;
move pelvis to y-axis [-2.7] now;
var sleeptime;
sleeptime = rand(395, 465);
set MAX_SPEED to (UNIT_SPEED/CRAWL_SLOWDOWN_FACTOR);
		if (bMoving==1)
			{
			turn torso to x-axis <-15> speed <75>;
			turn torso to y-axis <-15> speed <75>;	
			turn torso to z-axis <20> speed <75>;
			turn pelvis to y-axis <15> speed <75>;
			turn pelvis to z-axis <-15> speed <75>;
			sleep sleeptime;			
			turn lthigh to x-axis <-90> speed <210>;
			turn lthigh to y-axis <85> speed <210>;
			turn lthigh to z-axis <15> speed <210>;
			turn lleg to x-axis <120> speed <210>;
			turn lleg to y-axis <0> speed <210>;
			turn lleg to z-axis <0> speed <210>;
			turn rthigh to x-axis <0> speed <210>;
			turn rthigh to y-axis <-100> speed <210>;
			turn rthigh to z-axis <0> speed <210>;
			turn rleg to x-axis <10> speed <210>;
			turn rleg to y-axis <0> speed <210>;
			turn rleg to z-axis <0> speed <210>;
			turn head to x-axis <-60> speed <150>;
			turn head to y-axis <-30> speed <150>;
			turn head to z-axis <-40> speed <150>;
			
			turn luparm to x-axis <-80> speed <150>;
			turn luparm to y-axis <60> speed <150>;
			turn luparm to z-axis <0> speed <150>;
			turn lloarm to x-axis <-120> speed <150>;
			turn lloarm to y-axis <-30> speed <150>;
			turn lloarm to z-axis <0> speed <150>;
			turn ruparm to x-axis <-100> speed <150>;
			turn ruparm to y-axis <-50> speed <150>;
			turn ruparm to z-axis <0> speed <150>;
			turn rloarm to x-axis <-60> speed <150>;
			turn rloarm to y-axis <10> speed <150>;
			turn rloarm to z-axis <0> speed <150>;
			turn gun to x-axis <-105> speed <150>;
			turn gun to y-axis <35> speed <150>;
			turn gun to z-axis <0> speed <150>;
			}
					
		if (bMoving==1)
			{
			turn torso to x-axis <-15> speed <75>;
			turn torso to y-axis <15> speed <75>;	
			turn torso to z-axis <-20> speed <75>;
			turn pelvis to y-axis <-15> speed <75>;
			turn pelvis to z-axis <15> speed <75>;
			sleep sleeptime;
			turn lthigh to x-axis <0> speed <210>;
			turn lthigh to y-axis <85> speed <210>;
			turn lthigh to z-axis <0> speed <210>;
			turn lleg to x-axis <10> speed <210>;
			turn lleg to y-axis <0> speed <210>;
			turn lleg to z-axis <0> speed <210>;
			turn rthigh to x-axis <-90> speed <210>;
			turn rthigh to y-axis <-85> speed <210>;
			turn rthigh to z-axis <-15> speed <210>;
			turn rleg to x-axis <120> speed <210>;
			turn rleg to y-axis <0> speed <210>;
			turn rleg to z-axis <0> speed <210>;
			turn head to x-axis <-60> speed <150>;
			turn head to y-axis <30> speed <150>;
			turn head to z-axis <40> speed <150>;
			turn luparm to x-axis <-100> speed <150>;
			turn luparm to y-axis <50> speed <150>;
			turn luparm to z-axis <0> speed <150>;
			turn lloarm to x-axis <-60> speed <150>;
			turn lloarm to y-axis <-10> speed <150>;
			turn lloarm to z-axis <0> speed <150>;
			turn ruparm to x-axis <-80> speed <150>;
			turn ruparm to y-axis <-60> speed <150>;
			turn ruparm to z-axis <0> speed <150>;
			turn rloarm to x-axis <-120> speed <150>;
			turn rloarm to y-axis <30> speed <150>;
			turn rloarm to z-axis <0> speed <150>;						
			turn gun to x-axis <-40> speed <150>;
			turn gun to y-axis <45> speed <150>;
			turn gun to z-axis <0> speed <150>;
			}
}