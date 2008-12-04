/*
--Infantry Weapon SMG--
Here is: aiming logic and animation and firing FX/animation

This script assumes that any infantry with a SMG has that weapon in weapon slot #1

Functions:
AimFromWeapon1(piecenum)
QueryWeapon1(piecenum)
AimWeapon1(heading, pitch)
Shot1()---NEEDS FIXING SO THEIR ARMS MOVE
FireWeapon1()

*/

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
	var pickPose;
	if (bEngaged == 0)
	{
	pickPose = rand(1,2);
	}
	if (iState == 9) return 0; //if the unit is pinned, we don't even bother aiming or calling the control loop
	bEngaged=1;
	if (iState>=6)
	{
		if (bMoving == 1) return 0;
		iState=7; //prone aiming
		turn torso to y-axis <0> speed <600>;
		turn ruparm to x-axis <-85> - pitch speed <480>;
		turn luparm to x-axis <-140> - pitch speed <400>;
		turn pelvis to y-axis heading speed <120>;
		wait-for-turn luparm around x-axis;
		wait-for-turn ruparm around x-axis;
		wait-for-turn torso around y-axis;
		wait-for-turn pelvis around y-axis;
		start-script RestoreAfterDelay();
		return (1);
	}
	
	if (iState<6)
	{	
		if (bMoving==1)
		{	
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
			iState=2; //standing/kneeling aiming
			if (pickPose == 1)
			{
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
			}
			if (pickPose == 2)
			{
			move pelvis to y-axis [-1] now;
			
			turn pelvis to x-axis <0> speed <200>;
			turn pelvis to y-axis heading speed <300>;
			turn pelvis to z-axis <0> speed <300>;
			turn torso to y-axis <10> speed <200>;
			turn torso to x-axis <-40> - pitch speed <200>;	
			turn torso to z-axis <-10> speed <200>;	
				
			turn head to x-axis <0> speed <200>;
			turn head to y-axis <40> speed <200>;
			turn head to z-axis <-20> speed <200>;	
			
			turn rthigh to x-axis <0> speed <300>;
			turn rthigh to y-axis <0> speed <300>;
			turn rthigh to z-axis <0> speed <300>;	
			
			turn rleg to x-axis <90> speed <300>;
			turn rleg to y-axis <0> speed <300>;
			turn rleg to z-axis <0> speed <300>;
		
			turn lthigh to x-axis <-80> speed <300>;
			turn lthigh to y-axis <0> speed <300>;
			turn lthigh to z-axis <0> speed <300>;
			
			turn lleg to x-axis <80> speed <300>;
			turn lleg to y-axis <0> speed <300>;
			turn lleg to z-axis <0> speed <300>;	
				
			turn ruparm to x-axis <0> speed <300>;
			turn ruparm to y-axis <60> speed <300>;
			turn ruparm to z-axis <0> speed <300>;	
					
			turn rloarm to x-axis <-150> speed <300>;
			turn rloarm to y-axis <0> speed <300>;
			turn rloarm to z-axis <0> speed <300>;	
					
			turn gun to x-axis <45> speed <300>;
			turn gun to y-axis <0> speed <300>;
			turn gun to z-axis <20> speed <300>;	
					
			turn luparm to x-axis <-80> speed <300>;
			turn luparm to y-axis <0> speed <300>;
			turn luparm to z-axis <0> speed <300>;	
					
			turn lloarm to x-axis <-60> speed <300>;
			turn lloarm to y-axis <0> speed <300>;
			turn lloarm to z-axis <0> speed <300>;
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
			}
			start-script RestoreAfterDelay();			
			return (1);
			
		} 
	}	
	return (0);
}

/*Shot1()
{
if (iState>=6)
	{
	return (1);
	}
if (iState<6)
	{
	emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;
	turn ruparm to x-axis <-40> now;
	turn luparm to x-axis <-70> now;
	sleep BurstRate;
	turn ruparm to x-axis <-35> now;
	turn luparm to x-axis <-65> now;
	}
}*/
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
		turn ruparm to x-axis <-95> now;\
		turn luparm to x-axis <-150> now;\
		sleep (BurstRate/2);\
		turn ruparm to x-axis <-85> now;\
		turn luparm to x-axis <-140> now;\
		sleep (BurstRate/2);
		
FireWeapon1()
{
	if (iState<6)
		{
		/*/SHOT_ANIM_STANDING
		SHOT_ANIM_STANDING
		SHOT_ANIM_STANDING
		SHOT_ANIM_STANDING
		SHOT_ANIM_STANDING
		SHOT_ANIM_STANDING*/
		return (1);
		}
	if (iState>6)
		{
		SHOT_ANIM_PRONE
		SHOT_ANIM_PRONE
		SHOT_ANIM_PRONE
		SHOT_ANIM_PRONE
		SHOT_ANIM_PRONE
		SHOT_ANIM_PRONE
		return (1);
		}
}