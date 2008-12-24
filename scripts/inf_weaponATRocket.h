/*
--Infantry Weapon  AT Rocket--
Here is: aiming logic and animation and firing FX/animation

This script assumes that any infantry with an AT rocket has that weapon in weapon slot #1

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
	signal SIG_IDLE;
	bAiming=3;
	if (iState == 9) return 0; //if the unit is pinned, we don't even bother aiming or calling the control loop
	if (bMoving == 1) return 0;
	if (iState >= 6)
	{
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
		iState=3; //kneeling aiming		
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
		start-script RestoreAfterDelay();	
		return (1);	
	}	
	return (0);
}

		
#define SHOT_ANIM\
		emit-sfx MUZZLEFLASH from backblast;\
		emit-sfx MUZZLEDUST from backblast;
	
	
FireWeapon1()
{	
	#ifndef PIAT
	SHOT_ANIM
	#endif
	return (0);
}