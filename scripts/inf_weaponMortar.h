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
	bAiming = 5;
	if (bMoving == 1) return 0;
	if (iState >= 6 || isSmoking)) return 0;
	if (firing == 1) return 0;
	if (iState < 6)
	{
	//put anim here of crew kneeling and preparing to fire...
	move pelvis to y-axis [-1.3] now;
	turn rthigh to x-axis <0> now;
	turn lthigh to x-axis <-100> now;
	turn rleg to x-axis <110> now;
	turn lleg to x-axis <100> now;
	
	move mortarbase to y-axis [0] now;
	move mortarbase to x-axis [0] now;
	move mortarbase to z-axis [0] now;
	turn mortarbase to x-axis <0> now;
	turn mortarbase to y-axis <0> now;
	turn mortarbase to z-axis <0> now;
	turn luparm to x-axis <-90> now;
	turn luparm to y-axis <-20> now;
	turn luparm to z-axis <0> now;
	
	turn ruparm to x-axis <-40> now;
	turn ruparm to y-axis <15> now;
	turn ruparm to z-axis <0> now;
	
	turn rloarm to x-axis <0> now; 
	turn rloarm to y-axis <0> now; 
	turn rloarm to z-axis <0> now; 
	
	turn lloarm to x-axis <0> now;
	turn lloarm to y-axis <0> now;
	turn lloarm to z-axis <0> now;
	
	turn torso to x-axis <0> speed <100>;
	turn torso to y-axis <0> now;
	turn head to x-axis <10> now;
	turn head to y-axis <0> now;
	turn head to z-axis <0> now;
	//mortar anim...
	turn mortartube to x-axis <0> - pitch speed <100>;
	turn mortarstand to x-axis <-50> speed <100>;
	//turn mortarbase to y-axis heading speed <75>;
	turn ground to y-axis heading speed <75>;
	wait-for-turn ground around y-axis;
	start-script RestoreAfterDelay();
	return (1);
	}
	
	/*if (kneeling==1)
	{
		turn luparm to x-axis <-75> now;
	turn lloarm to x-axis <-45> now;
	turn lloarm to y-axis <-45> now;
	turn ruparm to x-axis <-75> now;
	turn rloarm to x-axis <-45> now;
	turn rloarm to z-axis <-45> now;
	turn torso to y-axis <75> speed <150>;
	turn rloarm to x-axis <-70> now;
	turn mortartube to x-axis <0> - pitch speed <100>;
	turn mortarstand to x-axis <-45> speed <100>;
	turn ground to y-axis heading speed <75>;
	wait-for-turn ground around y-axis;
	bAiming=0;
	return (1);
	}*/
	return (0);
}

FireWeapon1()
{
	firing=1;
	turn torso to y-axis <-40> speed <300>;
	turn luparm to x-axis <-30> now;
	turn luparm to y-axis <0> now;
	turn luparm to z-axis <0> now;
	
	turn ruparm to x-axis <-30> now;
	turn ruparm to y-axis <0> now;
	turn ruparm to z-axis <0> now;
	
	turn lloarm to x-axis <-150> now;
	turn lloarm to y-axis <-40> now;
	turn lloarm to z-axis <0> now;
	
	turn rloarm to x-axis <-150> now;
	turn rloarm to y-axis <40> now;
	turn rloarm to z-axis <0> now;
	turn head to x-axis <30> now;
	sleep 1000;	
	emit-sfx MUZZLEFLASH from flare;
	sleep 1000;
	firing=0;
}

AimFromWeapon2(piecenum)
{
	piecenum = flare;
}

QueryWeapon2(piecenum)
{
	piecenum = flare;
}

AimWeapon2(heading, pitch)
{
	//signal SIG_AIM1;
	set-signal-mask SIG_AIM1;
	bAiming = 5;
	if (bMoving == 1) return 0;
	if (iState >= 6 || !isSmoking)) return 0;
	if (firing == 1) return 0;
	if (iState < 6)
	{
	//put anim here of crew kneeling and preparing to fire...
	move pelvis to y-axis [-1.3] now;
	turn rthigh to x-axis <0> now;
	turn lthigh to x-axis <-100> now;
	turn rleg to x-axis <110> now;
	turn lleg to x-axis <100> now;
	
	move mortarbase to y-axis [0] now;
	move mortarbase to x-axis [0] now;
	move mortarbase to z-axis [0] now;
	turn mortarbase to x-axis <0> now;
	turn mortarbase to y-axis <0> now;
	turn mortarbase to z-axis <0> now;
	turn luparm to x-axis <-90> now;
	turn luparm to y-axis <-20> now;
	turn luparm to z-axis <0> now;
	
	turn ruparm to x-axis <-40> now;
	turn ruparm to y-axis <15> now;
	turn ruparm to z-axis <0> now;
	
	turn rloarm to x-axis <0> now; 
	turn rloarm to y-axis <0> now; 
	turn rloarm to z-axis <0> now; 
	
	turn lloarm to x-axis <0> now;
	turn lloarm to y-axis <0> now;
	turn lloarm to z-axis <0> now;
	
	turn torso to x-axis <0> speed <100>;
	turn torso to y-axis <0> now;
	turn head to x-axis <10> now;
	turn head to y-axis <0> now;
	turn head to z-axis <0> now;
	//mortar anim...
	turn mortartube to x-axis <0> - pitch speed <100>;
	turn mortarstand to x-axis <-50> speed <100>;
	//turn mortarbase to y-axis heading speed <75>;
	turn ground to y-axis heading speed <75>;
	wait-for-turn ground around y-axis;
	start-script RestoreAfterDelay();
	return (1);
	}
	
	/*if (kneeling==1)
	{
		turn luparm to x-axis <-75> now;
	turn lloarm to x-axis <-45> now;
	turn lloarm to y-axis <-45> now;
	turn ruparm to x-axis <-75> now;
	turn rloarm to x-axis <-45> now;
	turn rloarm to z-axis <-45> now;
	turn torso to y-axis <75> speed <150>;
	turn rloarm to x-axis <-70> now;
	turn mortartube to x-axis <0> - pitch speed <100>;
	turn mortarstand to x-axis <-45> speed <100>;
	turn ground to y-axis heading speed <75>;
	wait-for-turn ground around y-axis;
	bAiming=0;
	return (1);
	}*/
	return (0);
}

FireWeapon2()
{
	firing=1;
	turn torso to y-axis <-40> speed <300>;
	turn luparm to x-axis <-30> now;
	turn luparm to y-axis <0> now;
	turn luparm to z-axis <0> now;
	
	turn ruparm to x-axis <-30> now;
	turn ruparm to y-axis <0> now;
	turn ruparm to z-axis <0> now;
	
	turn lloarm to x-axis <-150> now;
	turn lloarm to y-axis <-40> now;
	turn lloarm to z-axis <0> now;
	
	turn rloarm to x-axis <-150> now;
	turn rloarm to y-axis <40> now;
	turn rloarm to z-axis <0> now;
	turn head to x-axis <30> now;
	sleep 1000;	
	emit-sfx MUZZLEFLASH from flare;
	sleep 1000;
	firing=0;
}