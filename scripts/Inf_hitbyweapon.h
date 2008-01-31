FearRecovery() 
{ 

	if (fear>PinnedLevel && IsPinned==0) call-script Pinned();




     if (DecreasingFear==1) return (1);  // better to use signals here


     DecreasingFear = 1;
     while(fear > 0) 
          { 
			if (0<fear && fear < PinnedLevel && IsPinned==1)

		{
			call-script RestoreFromPinned();
			sleep 100;
		}

          fear = fear - RecoverConstant; 
          sleep RecoverRate; 
          } 

DecreasingFear=0; 
 
return (1); 
}



HitByWeaponId(z,x,id,damage)
{	
	if (Id<=300 || Id>700)
		return (100); // DON'T NEED BRACKETS FOR return STATEMENTS!
	
	if (300<Id && Id<=400) //301-400=small arms or very small calibre cannon: MGs, snipers, LMGs, 20mm
		fear = fear + LittleFear;
	if (400<Id && Id<=500) //401-500=small/med explosions: mortars, 75mm guns and under
		fear = fear + MedFear;
	if (500<Id && Id<=600) //501-600=large explosions: small bombs, 155mm - 88mm guns,
		fear = fear + BigFear;
	if (600<Id && Id<=700) //601-700=omgwtfbbq explosions: medium/large bombs, 170+mm guns, rocket arty 
		fear = fear + MortalFear;

	if (fear > FearLimit) fear = FearLimit; // put this line AFTER increasing fear var
	signal RUNSTOP;	
	start-script TakeCover();
	sleep 100; // what is this for??
	start-script FearRecovery();
	
	return (1); //if it gets to here, its a nondamaging suppression weapon anyways, so 1% doesn't matter. // You can return 0 now
}

//lets Lua suppression notification see what fear is at
luaFunction(arg1)
{
 arg1 = fear;
}


#define SIG_TRANSLOOP 1024

TransportRotationLoop()
{
	signal SIG_TRANSLOOP;
	set-signal-mask SIG_TRANSLOOP;
		transported=1;	
		bMoving=0;
		sleep 50;
		signal RUNSTOP;
		set CLOAKED to FALSE;

		start-script WeaponReady();
		call-script RestoreAfterCover();
		set CLOAKED to FALSE;
		move pelvis to y-axis [0.0] now;
		turn pelvis to x-axis <0> now;
		turn pelvis to y-axis <0> now;
		turn pelvis to z-axis <0> now;
		turn ground to x-axis <0> now;
		turn ground to x-axis <-20> now;

		turn rleg to x-axis <100> now;
		turn rleg to y-axis <0> now;
		turn rleg to z-axis <0> now;

		turn lthigh to x-axis <0> now;
		turn lthigh to y-axis <0> now;
		turn lthigh to z-axis <0> now;

		turn rthigh to x-axis <-85> now;
		turn rthigh to y-axis <0> now;
		turn rthigh to z-axis <0> now;

		turn lleg to x-axis <110> now;
		turn lleg to y-axis <0> now;
		turn lleg to z-axis <0> now;
		turn torso to x-axis <30> now;


	while (TRUE) {
		set HEADING to (get HEADING (get TRANSPORT_ID));
		sleep 50;
		}


}
setSFXoccupy (terrain)
{
	if (terrain == 0) start-script TransportRotationLoop(); // we are being transported
	else
	{
	 signal SIG_TRANSLOOP;
	transported=0;
	}
}
