
Killed(severity, corpsetype) //need more finished death anims before this is enabled
{
/*	if( severity <= 70 ) 
		{
		hide gun;
		Turn pelvis to x-axis <-10> speed <33>*DEATH_SPEED;
		Turn torso to y-axis <-60> speed <33>*DEATH_SPEED;
		Turn head to x-axis <30> speed <7.5>*DEATH_SPEED;
		Turn head to y-axis <20> speed <7.5>*DEATH_SPEED;
		turn rthigh to x-axis <30> speed <25>*DEATH_SPEED;
		move pelvis to z-axis [-1] speed <240>*DEATH_SPEED;
		wait-for-turn pelvis around x-axis;

		Turn luparm to x-axis <-50> speed <32>*DEATH_SPEED;
		Turn luparm to y-axis <-20> speed <32>*DEATH_SPEED;
		turn lloarm to y-axis <20> speed <32>*DEATH_SPEED;
		Turn lloarm to z-axis <90> speed <32>*DEATH_SPEED;
		turn head to y-axis <-30> speed <7.5>*DEATH_SPEED;

		turn rthigh to x-axis <0> speed <39>*DEATH_SPEED;
		turn lthigh to x-axis <10> speed <39>*DEATH_SPEED;
		move pelvis to z-axis [-2] speed <650>*DEATH_SPEED;
		turn lleg to x-axis <50> speed <12>*DEATH_SPEED;


		move pelvis to y-axis [-0.15] speed <262>*DEATH_SPEED;
			wait-for-move pelvis along y-axis;
		Turn pelvis to x-axis <-40> speed <20>*DEATH_SPEED;


		wait-for-turn lthigh around x-axis;
		wait-for-turn rthigh around x-axis;


		move pelvis to y-axis [-2.75] speed <480>*DEATH_SPEED;
		move pelvis to z-axis [-5] speed <460>*DEATH_SPEED;
		turn pelvis to x-axis <-90> speed <16>*DEATH_SPEED;
		turn ruparm to y-axis <65> speed <25>*DEATH_SPEED;
		turn ruparm to z-axis <90> speed <25>*DEATH_SPEED;
		Turn lthigh to x-axis <-50> speed <15>*DEATH_SPEED;
		turn lthigh to z-axis <-10> speed <5>*DEATH_SPEED;
		Turn lleg to x-axis <85> speed <26>*DEATH_SPEED;

	wait-for-turn lleg around x-axis;
	sleep 1000;

		turn head to x-axis <-30> speed <10>*DEATH_SPEED;
		turn head to y-axis <0> speed <10>*DEATH_SPEED;
		turn torso to x-axis <0> speed <10>*DEATH_SPEED;
		turn torso to y-axis <0> speed <10>*DEATH_SPEED;
		
		turn luparm to x-axis <-10> speed <10>*DEATH_SPEED;
		turn luparm to y-axis <20> speed <10>*DEATH_SPEED;
		turn ruparm to y-axis <0> speed <10>*DEATH_SPEED;
		turn lthigh to x-axis <0> speed <16>*DEATH_SPEED;
		turn lleg to x-axis <0> speed <16>*DEATH_SPEED;

	wait-for-turn head around x-axis;
	wait-for-turn head around y-axis;
	wait-for-turn torso around x-axis;
	wait-for-turn torso around y-axis;
	wait-for-turn luparm around x-axis;
	wait-for-turn luparm around y-axis;
	
	wait-for-turn lthigh around x-axis;
	wait-for-turn lleg around x-axis;
	corpsetype = 1;
	}


		PickDeath=rand(1,3);
		
		if (PickDeath==1)
		{
		hide gun;
		Turn torso to x-axis <-25> speed <120>*DEATH_SPEED;
		Turn torso to y-axis <-30> speed <120>*DEATH_SPEED;
		Turn head to x-axis <-40> speed <120>*DEATH_SPEED;
	wait-for-turn torso around y-axis;
		Turn torso to x-axis <25> speed <120>*DEATH_SPEED;
		Turn torso to y-axis <30> speed <120>*DEATH_SPEED;
		Turn luparm to x-axis <-90> speed <120>*DEATH_SPEED;
		Turn luparm to y-axis <-30> speed <120>*DEATH_SPEED;
		Turn lloarm to z-axis <70> speed <120>*DEATH_SPEED;
	wait-for-turn lloarm around z-axis;
		Move pelvis to y-axis [-0.15] speed <680>*DEATH_SPEED;
		Move pelvis to z-axis [0.5] speed <580>*DEATH_SPEED;
		Turn lthigh to x-axis <-40> speed <220>*DEATH_SPEED;
		Turn lleg to x-axis <85> speed <220>*DEATH_SPEED;
		Turn rthigh to x-axis <-40> speed <220>*DEATH_SPEED;
		Turn rleg to x-axis <85> speed <220>*DEATH_SPEED;
		Turn head to x-axis <20> speed <220>*DEATH_SPEED;
		Turn head to y-axis <-40> speed <220>*DEATH_SPEED;
	wait-for-turn head around y-axis;
		Move pelvis to y-axis [-.45] speed <680>*DEATH_SPEED;
		Move pelvis to z-axis [1] speed <560>*DEATH_SPEED;
		Turn lthigh to x-axis <0> speed <120>*DEATH_SPEED;
		Turn rthigh to x-axis <0> speed <120>*DEATH_SPEED;
	wait-for-move pelvis along y-axis;
		Move pelvis to y-axis [-0.6] speed <680>*DEATH_SPEED;
		Turn pelvis to x-axis <80> speed <40>*DEATH_SPEED;
		Move pelvis to z-axis [4] speed <580>*DEATH_SPEED;
		Turn lthigh to z-axis <15> speed <120>*DEATH_SPEED;
		Turn lleg to x-axis <0> speed <120>*DEATH_SPEED;
		Turn rleg to x-axis <0> speed <120>*DEATH_SPEED;
		Turn rleg to z-axis <10> speed <120>*DEATH_SPEED;
		corpsetype = 1;
		return (0);
	//	}
	
//very much not done	
Move pelvis to z-axis -1 speed [500];
Turn rthigh to x-axis -10922 speed <120>;
Turn rleg to x-axis 7281 speed <120>;
Turn lthigh to x-axis -7281 speed <120>;
Turn lleg to x-axis 7281 speed <120>;
Turn torso to x-axis 7281 speed <120>;
Turn head to x-axis 5461 speed <120>;
Turn ruparm to x-axis -7281 speed<120>;
Turn rloarm to z-axis -3640 speed<120>;
Turn luparm to x-axis -7281 speed<120>;
Turn luparm to y-axis -7281 speed<120>;
Sleep 1000;
Turn torso to x-axis 3640 speed<120>;
Turn head to x-axis -10922 speed<120>;
Sleep 500;
Turn rthigh to y-axis -3640 speed<120>;
Turn torso to x-axis 7281 speed<120>;
Turn torso to y-axis -3640 speed<120>;
Turn head to x-axis 5461 speed<120>;
Sleep 500;
Turn torso to x-axis 3640 speed<120>;
Turn head to x-axis -5461 speed<120>;
Sleep 500;
Move pelvis to x-axis 3 speed[520];
Move pelvis to y-axis 2 speed[520];
Turn pelvis to z-axis -15473 speed<120>;
Turn rthigh to x-axis -12743 speed<120>;
Turn rthigh to y-axis 0 speed<120>;
Turn lthigh to x-axis -9102 speed<120>;
Turn torso to x-axis 10922 speed<120>;
Turn torso to y-axis 0 speed<120>;
Turn head to x-axis 5461 speed<120>;
Sleep 1000;
	
	}
	
	if(severity > 70)
	{
	

		corpsetype = 3;
		return (0);
	}*/
	corpsetype = 1;
}
