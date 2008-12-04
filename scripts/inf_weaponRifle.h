AimFromWeapon1(piecenum)
{
	piecenum = flare;
}

QueryWeapon1(piecenum)
{
	piecenum = flare;
}

AimWeapon1(heading, pitch)
{
	signal SIG_AIM1;
	set-signal-mask SIG_AIM1;
	bEngaged=1; 
	if (iState == 9) return 0; //if the unit is pinned, we don't even bother aiming or calling the control loop
	//start-script AimRunControl();
	if (iState>=6)
	{
		if (bMoving == 1) return 0;
		
		iState=7; //prone aiming
		//animation la de da
		start-script RestoreAfterDelay();
		return (1);
	}
	
	if (iState<6)
	{	
		if (bMoving==1)
		{	
			//iState=5; //moving aiming			
			turn torso to y-axis heading speed <300>;
			turn torso to x-axis <0> - pitch speed <300>;
			turn ruparm to x-axis <50.500000> speed <300.000000>;
			turn ruparm to y-axis <43.000000> speed <300.000000>;
			turn ruparm to z-axis <0> speed <300>;
		
			turn rloarm to x-axis <-120.000000> speed <300.000000>;
			turn rloarm to y-axis <0> speed <300>;
			turn rloarm to z-axis <0> speed <300>;
			
			turn head to x-axis <0> speed <300>;
			turn head to y-axis <0> speed <300>;
			turn head to z-axis <0> speed <300>;
			
			
			turn gun to x-axis <-20.000000> speed <300.000000>;
			turn gun to y-axis <0> speed <300>;
			turn gun to z-axis <40> speed <300>;
			
			turn luparm to x-axis <-60.000000> speed <300.000000>;
			turn luparm to y-axis <-25.000000> speed <300.000000>;
			turn luparm to z-axis <0> speed <300>;
			
			turn lloarm to x-axis <-15> speed <300>;
			turn lloarm to y-axis <0> speed <300>;
			turn lloarm to z-axis <25.000000> speed <300.000000>;
			wait-for-turn lloarm around x-axis;
			wait-for-turn lloarm around y-axis;
			wait-for-turn lloarm around z-axis;
			
			wait-for-turn luparm around x-axis;
			wait-for-turn luparm around y-axis;
			wait-for-turn luparm around z-axis;
			
			wait-for-turn ruparm around x-axis;
			wait-for-turn ruparm around y-axis;
			wait-for-turn ruparm around z-axis;
			
			wait-for-turn rloarm around x-axis;
			wait-for-turn rloarm around y-axis;
			wait-for-turn rloarm around z-axis;
			
			wait-for-turn gun around x-axis;
			wait-for-turn gun around y-axis;
			wait-for-turn gun around z-axis;
			start-script RestoreAfterDelay();	
			return (1);
		} 
	
		if (bMoving==0)
		{
			//iState=2; //standing aiming rifle
			move pelvis to y-axis [0.0] speed <100>;
			turn pelvis to x-axis <0> speed <200>;
			turn pelvis to y-axis heading - <90.000000> speed <300>;
			turn pelvis to z-axis <10> speed <300>;
			turn torso to y-axis <20> speed <200>;
			turn torso to x-axis <-5> - pitch speed <200>;	
			turn torso to z-axis <-10> speed <200>;	
				
			turn head to x-axis <15> speed <200>;
			turn head to y-axis <70> speed <200>;
			turn head to z-axis <-20> speed <200>;	
			
			turn rthigh to x-axis <5> speed <300>;
			turn rthigh to y-axis <0> speed <300>;
			turn rthigh to z-axis <0> speed <300>;	
			
			turn rleg to x-axis <5> speed <300>;
			turn rleg to y-axis <0> speed <300>;
			turn rleg to z-axis <0> speed <300>;
		
			turn lthigh to x-axis <-15> speed <300>;
			turn lthigh to y-axis <0> speed <300>;
			turn lthigh to z-axis <-25> speed <300>;
			
			turn lleg to x-axis <20> speed <300>;
			turn lleg to y-axis <0> speed <300>;
			turn lleg to z-axis <0> speed <300>;	
				
			turn ruparm to x-axis <-35> speed <300>;
			turn ruparm to y-axis <90> speed <300>;
			turn ruparm to z-axis <50> speed <300>;	
					
			turn rloarm to x-axis <-80> speed <300>;
			turn rloarm to y-axis <-10> speed <300>;
			turn rloarm to z-axis <-25> speed <300>;	
					
			turn gun to x-axis <15> speed <300>;
			turn gun to y-axis <-60> speed <300>;
			turn gun to z-axis <30> speed <300>;	
					
			turn luparm to x-axis <-65> speed <300>;
			turn luparm to y-axis <60> speed <300>;
			turn luparm to z-axis <0> speed <300>;	
					
			turn lloarm to x-axis <-50> speed <300>;
			turn lloarm to y-axis <0> speed <300>;
			turn lloarm to z-axis <30> speed <300>;
			wait-for-turn lloarm around x-axis;
			wait-for-turn lloarm around y-axis;
			wait-for-turn lloarm around z-axis;			
			wait-for-turn luparm around x-axis;
			wait-for-turn luparm around y-axis;
			wait-for-turn luparm around z-axis;			
			wait-for-turn ruparm around x-axis;
			wait-for-turn ruparm around y-axis;
			wait-for-turn ruparm around z-axis;			
			wait-for-turn rloarm around x-axis;
			wait-for-turn rloarm around y-axis;
			wait-for-turn rloarm around z-axis;		
			wait-for-turn pelvis around x-axis;	
			wait-for-turn pelvis around y-axis;	
			wait-for-turn pelvis around z-axis;		
			wait-for-turn gun around x-axis;
			wait-for-turn gun around y-axis;
			wait-for-turn gun around z-axis;
			start-script RestoreAfterDelay();			
			return (1);
		} 
	}	
	return (0);
}
#define SHOT_ANIM_STANDING\
		emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;\
		turn ruparm to x-axis <-40> now;\
		turn luparm to x-axis <-70> now;\
		sleep (BurstRate/2);\
		turn ruparm to x-axis <-35> now;\
		turn luparm to x-axis <-65> now;\
		sleep (BurstRate/2);
		
#define SHOT_ANIM_PRONE\
		emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;\
		turn ruparm to x-axis <-40> now;\
		turn luparm to x-axis <-70> now;\
		sleep (BurstRate/2);\
		turn ruparm to x-axis <-35> now;\
		turn luparm to x-axis <-65> now;\
		sleep (BurstRate/2);
		
FireWeapon1()
{
	
	if (iState>=6)
	{
		SHOT_ANIM_PRONE
		return (1);
	}
	if (iState<6)
	{
		SHOT_ANIM_STANDING
		return (1);
	}	
	return (0);
}