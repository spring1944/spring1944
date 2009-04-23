/*
--Infantry Weapon MG--
Here is: aiming logic and animation and firing FX/animation

This script assumes that any infantry with a MG has that weapon in weapon slot #1

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
	signal SIG_AIM1;
	set-signal-mask SIG_AIM1;
	signal SIG_IDLE;
	bAiming=4;
	if (iState == 9) return 0; //if the unit is pinned, we don't even bother aiming or calling the control loop
	if (bMoving == 1) return 0;
	if (bMoving == 0)
	{		
		if (iState < 6) call-script TakeCover();
		iState=7; //prone aiming
		turn ruparm to x-axis <-80> - pitch speed <480>;
		turn luparm to x-axis <-140> - pitch speed <400>;
		turn pelvis to y-axis heading speed <120>;
		turn gun to z-axis <0> now;
		wait-for-turn luparm around x-axis;
		wait-for-turn gun around x-axis;
		wait-for-turn gun around y-axis;
		wait-for-turn ruparm around x-axis;
		wait-for-turn torso around y-axis;
		wait-for-turn pelvis around y-axis;
		start-script RestoreAfterDelay();
		return (1);
	}
	return (0);
}

		
#define SHOT_ANIM_PRONE\
		emit-sfx MUZZLEFLASH from GUN_QUERY_PIECENUM;\
		turn ruparm to x-axis <-88> now;\
		turn luparm to x-axis <-148> now;\
		sleep (BurstRate/2);\
		turn ruparm to x-axis <-80> now;\
		turn luparm to x-axis <-140> now;\
		sleep (BurstRate/2);
		
FireWeapon1()
{
	SHOT_ANIM_PRONE
	return (0);
}