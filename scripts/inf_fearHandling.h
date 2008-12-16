/*
--Fear handling & behavior --

---Functions
RestoreFromPinned
PinnedControl
TakeCover
RestoreAfterCover
FearRecovery
HitByWeaponID
luaFunction
*/

RestoreFromPinned()
{
	iState=6;
	start-script CrawlControl();
}

TakeCover() //get down!
{
	SET MAX_SPEED to (UNIT_SPEED/CRAWL_SLOWDOWN_FACTOR);
	SET ARMORED to TRUE;
	iState=6;
	SET UPRIGHT to 0;
	turn pelvis to y-axis <0> speed <600>;
	turn pelvis to z-axis <0> speed <600>;
	move pelvis to y-axis [-0.5] speed <600>;
	
	turn rthigh to x-axis <-40> speed <600>;
	
	turn rleg to x-axis <70> speed <400>;
	
	turn lthigh to x-axis <-40> speed <400>;
	
	turn lleg to x-axis <70> speed <400>;
	
	turn torso to y-axis <0> speed <600>;
	turn torso to x-axis <20> speed <600>;
	
	turn head to x-axis <-20> speed <600>;
	
	turn ruparm to y-axis <0> speed <600>;
	turn ruparm to z-axis <0> speed <600>;
	turn ruparm to x-axis <-70> speed <400>;
	
	turn rloarm to x-axis <0> speed <600>;
	turn rloarm to y-axis <0> speed <600>;
	turn rloarm to z-axis <-55> speed <600>;
	
	turn luparm to y-axis <0> speed <400>;
	turn luparm to z-axis <0> speed <400>;	
	turn luparm to x-axis <-75> speed <400>;
	
	turn lloarm to x-axis <0> speed <600>; 
	sleep 80;
	
	turn torso to x-axis <0> speed <480>;
	turn torso to y-axis <0> speed <480>;
	turn torso to z-axis <0> speed <480>;
	
	move pelvis to y-axis [0.525] speed <6080>;
	turn pelvis to x-axis <90> speed <160>;
	
	turn rthigh to x-axis <0> speed <480>;
	turn rthigh to y-axis <0> speed <480>;
	turn rthigh to z-axis <10> speed <480>;
	
	turn rleg to x-axis <35> speed <480>;
	
	turn lthigh to y-axis <0> speed <480>;
	turn lthigh to x-axis <0> speed <480>;
	turn lthigh to z-axis <-10> speed <480>;
	
	turn lleg to x-axis <35> speed <480>;
	
	turn ruparm to x-axis <180> speed <480>;
	
	turn luparm to x-axis <180> speed <480>;
	
	turn lloarm to z-axis <40> speed <480>;
	sleep 70;
	var pickSide;
	pickSide = rand(1,2);
	call-script Prone(pickSide);
	return(1);
}



RestoreAfterCover() //get up out of the dirt. also controls going into pinned mode.
{
	
	/*if (iFear > PinnedLevel)
	{
	call-script PinnedControl();
	sleep 100;
	} */
//	if (iFear <=0) //&& iState==6 || iFear <= 0 && iState==7 || iFear <=0 && iState==8)
//	{	
	signal SIG_CRAWL;
	signal SIG_PINNEDCTRL;
	signal SIG_IDLE;
	signal SIG_RESTOREFROMCRAWL;
	set-signal-mask SIG_RESTOREFROMCRAWL;
	set MAX_SPEED to [0.0000001];
	turn pelvis to x-axis <55> speed <480>;
	turn rthigh to z-axis <0> speed <480>;
	turn lthigh to z-axis <0> speed<480>;
	
	turn ruparm to z-axis <0> speed <480>;
	
	turn rloarm to x-axis <-80> speed <480>;
	turn rloarm to z-axis <0> speed <480>;
	turn rloarm to y-axis <0> speed <480>;

	turn luparm to x-axis <-85> speed <480>;
	turn luparm to y-axis <0> speed <480>;

	turn rthigh to x-axis <-85> speed <480>;
	turn lthigh to x-axis <-40> speed <480>;

	move pelvis to y-axis [-0.75] speed [480];
	turn rleg to x-axis <80> speed <480>;
	turn lleg to x-axis <80> speed <480>;
	sleep 100;
	//wait-for-turn lleg around x-axis;
	move pelvis to y-axis [0] speed [480];
	call-script WeaponReady();

	turn ground to x-axis <0> now;
	turn ground to y-axis <0> now;
	turn ground to z-axis <0> now;
	turn torso to x-axis <0> speed <480>;
	turn torso to y-axis <0> speed <480>;
	turn torso to z-axis <0> speed <480>;
	turn head to x-axis <0> speed <480>;
	turn head to y-axis <0> speed <480>;
	turn head to z-axis <0> speed <480>;
	
	turn rleg to x-axis <0> speed <480>;
	turn rleg to y-axis <0> speed <480>;
	turn rleg to z-axis <0> speed <480>;
		
	turn lleg to x-axis <0> speed <480>;
	turn lleg to y-axis <0> speed <480>;
	turn lleg to z-axis <0> speed <480>;
		
	turn pelvis to x-axis <0> speed <480>;
	turn pelvis to y-axis <0> speed <480>;
	turn pelvis to z-axis <0> speed <480>;
		
	turn rthigh to x-axis <0> speed <480>;
	turn rthigh to y-axis <0> speed <480>;
	turn rthigh to z-axis <0> speed <480>;
		
	turn lthigh to x-axis <0> speed <480>;
	turn lthigh to y-axis <0> speed <480>;
	turn lthigh to z-axis <0> speed <480>;
	sleep 100;
	//insert anim, with wait-for-turns to make sure it finishes
	iFear=0; //in the off chance that it was negative.
	iState=1;
	SET UPRIGHT TO 1;
	SET ARMORED to FALSE;
	set MAX_SPEED to UNIT_SPEED;
	call-script RunControl();
//	}
	return (1);
}

FearRecovery() 
{ 
	signal SIG_AIMRUN;
	signal SIG_RUN;	
	signal SIG_IDLE;
	signal SIG_FEARRECOVERY;
	set-signal-mask SIG_FEARRECOVERY;
     while(iFear > 0) 
        { 
			if (iFear < PinnedLevel && iState == 9)
			{
				signal SIG_PINNEDCTRL;
				start-script RestoreFromPinned();
				sleep 100;
			}
	        sleep RecoverRate; 
			iFear = iFear - RecoverConstant; 
        } 
	start-script RestoreAfterCover();   
	return (1); 
}

/*
Just what its name indicates - gives the ID and z/x coords of a weapon impact on the unit. Damage is the returned value as a percet (return 100 = 100% damage of the hit, return 50 = 50%)

For the specific fear values that each fear class (LittleFear, MedFear, BigFear, MortalFear)  represents, see inf_suppressionVars.h.  

301 = MGs and small cannons (20mm or smaller)
401 = snipers, medium guns (50-75mm), mortars
501 = larger guns (85mm-105mm), flamethrowers
601 = bombs, massive guns (precious few of which are actually implemented right now)

*/
HitByWeaponId(z,x,id,damage)
{	
	if (Id<=300 || Id>700)
	{
	iFear= iFear + 1;
		if (iState < 6) 
		{
		signal SIG_AIMRUN;
		signal SIG_RUN;
		signal SIG_RESTOREFROMCRAWL;
		signal SIG_CRAWL;
		signal SIG_IDLE;
		call-script TakeCover();
		//sleep initialDelay;
		start-script CrawlControl();
		start-script FearRecovery();
		}
	return 100;
	}
	
	if (Id==301) iFear = iFear + LittleFear;
	if (Id==401) iFear = iFear + MedFear;
	if (Id==501) iFear = iFear + BigFear;
	if (Id==601) iFear = iFear + MortalFear;
	if (iFear > FearLimit) iFear = FearLimit; // put this line AFTER increasing fear var		
	if (iState < 6)
	{
	signal SIG_AIMRUN;
	signal SIG_RUN;
	signal SIG_RESTOREFROMCRAWL;
	signal SIG_CRAWL;
	signal SIG_IDLE;
	call-script TakeCover();
	//sleep initialDelay;
	start-script CrawlControl();
	}
	start-script FearRecovery();
	return (0); 
}
//lets Lua suppression notification see what fear is at
luaFunction(arg1)
{
 arg1 = iFear;
}