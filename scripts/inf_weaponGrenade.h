AimFromWeapon2(piecenum)
{
	piecenum = torso;
}

QueryWeapon2(piecenum)
{
	piecenum = gun;
}

AimWeapon2(heading, pitch)
{

	signal SIG_AIM2;
	signal SIG_AIM1;
	set-signal-mask SIG_AIM2;
	if (iState==9) return 0;
	//turn pelvis to y-axis heading - <30> now;
//	if (NadeReloading==1) return (0); //slow nades while prone

	return (1);
}

NadeAnim()
{
	hide gun;
	Turn torso to x-axis <-10> speed <60>;
	Turn torso to y-axis <-20> speed <120>;
	turn luparm to x-axis <0> speed <120>;
	Turn luparm to y-axis <-20> speed <120>;
	Turn luparm to z-axis <-80> speed <450>;

	Turn lloarm to x-axis <-20> speed <120>;
	Turn lloarm to y-axis <0> speed <120>;
	Turn lloarm to z-axis <0> speed <120>;

	Turn ruparm to x-axis <20> speed <120>;
	Turn ruparm to y-axis <0> speed <120>;
	Turn ruparm to z-axis <55> speed <300>;

	Turn rloarm to x-axis <-35> speed <450>;
	turn rloarm to y-axis <0> speed <450>;
	Turn rloarm to z-axis <85> speed <450>;

	/*Turn rthigh to x-axis <20> speed <120>;
	Turn rthigh to y-axis <0> speed <120>;
	Turn rthigh to z-axis <0> speed <120>;

	Turn rleg to x-axis <45> speed <240>;
	Turn rleg to y-axis <0> speed <240>;
	Turn rleg to z-axis <0> speed <240>;

	Turn lthigh to x-axis <-65> speed <360>;
	Turn lthigh to y-axis <0> speed <360>;
	Turn lthigh to z-axis <0> speed <360>;

	Turn lleg to x-axis <50> speed <270>;
	Turn lleg to y-axis <0> speed <270>;
	Turn lleg to z-axis <0> speed <270>; //end of frame one*/

	sleep 300;
	Turn torso to x-axis <0> speed <150>;//start of frame two
	Turn luparm to y-axis <50> speed <360>;
	Turn luparm to z-axis <-55> speed <360>;
	Turn lloarm to x-axis <-40> speed <120>;
	Turn ruparm to x-axis <60> speed <360>;
	Turn ruparm to y-axis <35> speed <360>;
	Turn ruparm to z-axis <70> speed <360>;
	turn rloarm to y-axis <15> speed <360>;
//	Turn rthigh to x-axis <10> speed <360>;
	//Turn rleg to x-axis <25> speed <360>;
	//Turn lthigh to x-axis <0> speed <360>;
	//Turn lleg to x-axis <0> speed <360>; //end of frame two

	sleep 300;
	Turn torso to y-axis <0> speed <60>;//start of frame three (resetting model)
	Turn luparm to z-axis <0> speed <300>;
	Turn lloarm to x-axis <0> speed <300>;
	Turn ruparm to y-axis <0> speed <300>;
	Turn ruparm to z-axis <0> speed <300>;
	Turn rloarm to z-axis <0> speed <300>;
	sleep 300;
//	Turn rthigh to x-axis <0> speed <360>;
//	Turn rleg to x-axis <0> speed <360>;
}

FireWeapon2(heading) //grenaaaaade!
{
	if (iState<6)
	{
	bNading=1;
	call-script NadeAnim();
	bNading = 0;
	}
	if (iState>=6)
	{
	bNading=1;
	turn luparm to x-axis <0> speed <300>;
	turn luparm to y-axis <80> speed <300>;
	turn luparm to z-axis <0> speed <300>;
	wait-for-turn luparm around x-axis;
	turn luparm to x-axis <-160> speed<600>;
	wait-for-turn luparm around x-axis;	
	turn luparm to x-axis <-140> speed <360>;
	turn luparm to y-axis <0> speed <360>;
	turn luparm to z-axis <35> speed <360>;
	wait-for-turn luparm around x-axis;
	wait-for-turn luparm around y-axis;
	wait-for-turn luparm around z-axis;
	/*	nadeReloading=1;
		sleep NadePenalty;
		nadeReloading=0;*/
	bNading=0;
	return (1);
	}
	return (0);
}