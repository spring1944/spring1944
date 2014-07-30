/*
--Infantry Weapon Rifle--
Here is: aiming logic and animation and firing FX/animation

This script assumes that any infantry with a SMG has that weapon in weapon slot #1

Functions:
AimFromWeapon1(piecenum)
QueryWeapon1(piecenum)
AimWeapon1(heading, pitch)
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
	var pickPose;
#ifdef AMBUSH
	if (bAmbush)
	{
		return FALSE;
	}
#endif
	if (bAiming == 0)
	{
	pickPose = rand(1,1);
	}
	bAiming=5;
	signal SIG_AIM1;
	set-signal-mask SIG_AIM1;
	signal SIG_IDLE;
	if (iState == 9 || bNading == 1) return 0; //if the unit is pinned, we don't even bother aiming or calling the control loop
	show gun;
	if (iState >= 6)
	{
		if (bMoving == 1) return 0;
		iState=7; //prone aiming
		turn ruparm to x-axis <-80> - pitch speed <480>;
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
			iState = 5;
			turn torso to y-axis heading speed <300>;
			turn torso to x-axis <0> - pitch speed <300>;
			turn ruparm to x-axis <80.500000> speed <300.000000>;
			turn ruparm to y-axis <30.000000> speed <300.000000>;
			turn ruparm to z-axis <0> speed <300>;
		
			turn rloarm to x-axis <-120.000000> speed <300.000000>;
			turn rloarm to y-axis <0> speed <300>;
			turn rloarm to z-axis <0> speed <300>;
			
			turn head to x-axis <0> speed <300>;
			turn head to y-axis <0> speed <300>;
			turn head to z-axis <0> speed <300>;
			
			
			turn gun to x-axis <-50.000000> speed <300.000000>;
			turn gun to y-axis <0> speed <300>;
			turn gun to z-axis <30> speed <300>;
			
			turn luparm to x-axis <-60.000000> speed <300.000000>;
			turn luparm to y-axis <-40.000000> speed <300.000000>;
			turn luparm to z-axis <0> speed <300>;
			
			turn lloarm to x-axis <0> speed <300>;
			turn lloarm to y-axis <70> speed <300>;
			turn lloarm to z-axis <10.000000> speed <300.000000>;
			
			wait-for-turn torso around x-axis;
			wait-for-turn torso around y-axis;
			
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
			if (pickPose == 1)
			{
				iState=2; //standing aiming
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
				wait-for-turn head around x-axis;
				wait-for-turn head around y-axis;
				wait-for-turn head around z-axis;
				
				wait-for-turn pelvis around x-axis;	
				wait-for-turn pelvis around y-axis;	
				wait-for-turn pelvis around z-axis;	
				
				wait-for-turn lthigh around x-axis;
				wait-for-turn lthigh around y-axis;
				wait-for-turn lthigh around z-axis;
				
				wait-for-turn lleg around x-axis;
				wait-for-turn lleg around y-axis;
				wait-for-turn lleg around z-axis;
				
				wait-for-turn rthigh around x-axis;
				wait-for-turn rthigh around y-axis;
				wait-for-turn rthigh around z-axis;	
				
				wait-for-turn rleg around x-axis;
				wait-for-turn rleg around y-axis;
				wait-for-turn rleg around z-axis;
				
				wait-for-turn torso around x-axis;
				wait-for-turn torso around y-axis;
				wait-for-turn torso around z-axis;
				
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
			}
			if (pickPose == 2)
			{
				iState=3; //kneeling aiming		move pelvis to y-axis [0.0] now;
				move pelvis to y-axis [0.0] now;
				turn rthigh to x-axis <0> now; //reset the model so that the wait-for-turns aren't confused by the ongoing run anim
				turn rthigh to y-axis <0> now;
				turn rthigh to z-axis <0> now;
				turn lthigh to x-axis <0> now;
				turn lthigh to y-axis <0> now;
				turn lthigh to z-axis <0> now;
				turn lleg to x-axis <0> now;
				turn rleg to x-axis <0> now;
				turn torso to y-axis <0> now;
				turn torso to x-axis <0> now;
				turn torso to z-axis <0> now;
				turn pelvis to y-axis <0> now;
				turn pelvis to x-axis <0> now;
				turn pelvis to z-axis <0> now;	
	
				wait-for-turn torso around x-axis;
				wait-for-turn torso around y-axis;
				wait-for-turn torso around z-axis;
				
				wait-for-turn pelvis around x-axis;	
				wait-for-turn pelvis around y-axis;	
				wait-for-turn pelvis around z-axis;	
				wait-for-move pelvis along y-axis;
				
				wait-for-turn lthigh around x-axis;
				wait-for-turn lthigh around y-axis;
				wait-for-turn lthigh around z-axis;
				
				wait-for-turn lleg around x-axis;
				wait-for-turn lleg around y-axis;
				wait-for-turn lleg around z-axis;
				
				wait-for-turn rthigh around x-axis;
				wait-for-turn rthigh around y-axis;
				wait-for-turn rthigh around z-axis;	
				
				wait-for-turn rleg around x-axis;
				wait-for-turn rleg around y-axis;
				wait-for-turn rleg around z-axis;
		
				move pelvis to y-axis [-1] speed <2000>;
				
				turn pelvis to x-axis <0> speed <200>;
				turn pelvis to y-axis heading speed <300>;
				turn pelvis to z-axis <0> speed <300>;
				
				turn torso to x-axis <10> speed <200>;
				turn torso to y-axis <-40> speed <200>;	
				turn torso to z-axis <10> speed <200>;	
					
				turn head to x-axis <0> speed <200>;
				turn head to y-axis <40> speed <200>;
				turn head to z-axis <-20> speed <200>;	
				
				turn rthigh to x-axis <0> speed <199>;
				turn rthigh to y-axis <0> speed <199>;
				turn rthigh to z-axis <0> speed <199>;	
				
				turn rleg to x-axis <90> speed <199>;
				turn rleg to y-axis <0> speed <199>;
				turn rleg to z-axis <0> speed <199>;
			
				turn lthigh to x-axis <-80> speed <199>;
				turn lthigh to y-axis <0> speed <199>;
				turn lthigh to z-axis <0> speed <199>;
				
				turn lleg to x-axis <80> speed <199>;
				turn lleg to y-axis <0> speed <199>;
				turn lleg to z-axis <0> speed <199>;	
					
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
		
				wait-for-turn head around x-axis;
				wait-for-turn head around y-axis;
				wait-for-turn head around z-axis;
				
				wait-for-turn pelvis around x-axis;	
				wait-for-turn pelvis around y-axis;	
				wait-for-turn pelvis around z-axis;	
				wait-for-move pelvis along y-axis;
				
				wait-for-turn lthigh around x-axis;
				wait-for-turn lthigh around y-axis;
				wait-for-turn lthigh around z-axis;
				
				wait-for-turn lleg around x-axis;
				wait-for-turn lleg around y-axis;
				wait-for-turn lleg around z-axis;
				
				wait-for-turn rthigh around x-axis;
				wait-for-turn rthigh around y-axis;
				wait-for-turn rthigh around z-axis;	
				
				wait-for-turn rleg around x-axis;
				wait-for-turn rleg around y-axis;
				wait-for-turn rleg around z-axis;
				
				wait-for-turn torso around x-axis;
				wait-for-turn torso around y-axis;
				wait-for-turn torso around z-axis;
				
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
			}
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
		
#define SHOT_ANIM_KNEELING\
		emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;\
		turn ruparm to x-axis <-4> now;\
		turn luparm to x-axis <-85> now;\
		sleep (BurstRate/2);\
		turn ruparm to x-axis <0> now;\
		turn luparm to x-axis <-80> now;\
		sleep (BurstRate/2);
		
#define SHOT_ANIM_RUNNING\
		emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;\
		turn ruparm to x-axis <75> now;\
		turn luparm to x-axis <-65> now;\
		sleep (BurstRate/2);\
		turn ruparm to x-axis <80> now;\
		turn luparm to x-axis <-60> now;\
		sleep (BurstRate/2);
		
#define SHOT_ANIM_PRONE\
		emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;\
		turn ruparm to x-axis <-85> now;\
		turn luparm to x-axis <-145> now;\
		sleep (BurstRate/2);\
		turn ruparm to x-axis <-80> now;\
		turn luparm to x-axis <-140> now;\
		sleep (BurstRate/2);
		
FireWeapon1()
{
	if (iState==2)
		{
		SHOT_ANIM_STANDING
		}
		
	if (iState==3)
		{
		SHOT_ANIM_KNEELING
		}
		
	if (iState==5)
		{
		SHOT_ANIM_RUNNING
		}
		
	if (iState==7)
		{
		SHOT_ANIM_PRONE
		}
	return (0);
}