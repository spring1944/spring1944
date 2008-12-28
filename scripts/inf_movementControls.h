/*
--All of the movement control loops--
--details on signals found with the function comments

---Functions
AimRunControl
PinnedControl
CrawlControl
RunControl
*/

/* 
--Aiming run state & idle anims (aiming, no fear, not crawling)--

Killed by:
RunControl
CrawlControl
FearRecovery
setSFXOccupy
Death
*/

AimRunControl()
{
signal SIG_AIMRUN;
set-signal-mask SIG_AIMRUN;
signal SIG_RUN;
while(1)
	{
		if (bAiming > 0) bAiming = (bAiming - 1);
		if (bMoving == 0)
		{
		start-script Stand();
		sleep 200;
		//call-script StandingIdle();
		}	  
		
		if (bMoving == 1)
		{
		#ifndef COMMANDO
		set MAX_SPEED to (iSpeed/AIM_SLOWDOWN_FACTOR);
		#endif
		call-script AimRun();
		}		
	}
}


PinnedControl() //hit the dirt and kiss your ass goodbye...
{
	signal SIG_PINNEDCTRL;
	set-signal-mask SIG_PINNEDCTRL;
	signal SIG_AIM1;
	signal SIG_CRAWL;
	set MAX_SPEED to (iSpeed/4000);
	iState=9;
	var pickPinned;
	pickPinned = rand(1,3);
	if (pickPinned == 1) call-script Pinned1();
	if (pickPinned == 2) call-script Pinned2();
	if (pickPinned == 3) call-script Pinned3();
}

/* 
--Crawling state & idle anims (not aiming/aiming, fear, not pinned)--

Killed by:
RestoreFromCrawl
PinnedControl
setSFXOccupy
Death
*/
CrawlControl()
{
signal SIG_CRAWL;
set-signal-mask SIG_CRAWL;
signal SIG_RUN;
signal SIG_AIMRUN;
//get PRINT(333, iState, bMoving, bAiming);
var pickSide;
pickSide = rand(1,2);
	while(1)
	{
		if (iFear > PinnedLevel && iState !=9)	start-script PinnedControl();
		if (iState == 9) signal SIG_CRAWL;
		if (bAiming > 0) bAiming = (bAiming - 1);
		if (bMoving == 0)
		{
	  	call-script Prone(pickSide);
		//get PRINT(111, iState, bMoving, bAiming);
		}
		
		if (bMoving == 1)
		{
		//iState=8; //crawling
		//get PRINT(222, iState, bMoving, bAiming);
		call-script Crawl(); //this has a sleep at the end of it, so theoretically no lockups
		}
	}
}

/* 
--Standard run state & idle anims (not aiming, no fear, not crawling)--
Killed by:
AimRunControl
CrawlControl
FearRecovery
setSFXOccupy
Death
*/
RunControl() 
{
	signal SIG_RUN;
	set-signal-mask SIG_RUN;
	signal SIG_CRAWL;

	signal SIG_AIMRUN;
	start-script WeaponReady();
	var pickStance;
	pickStance = rand(1,StanceNumber);
	set MAX_SPEED to iSpeed;
	while(1)
	{
		#ifndef OnlyProneFire
			#ifndef NoAimRun
		if (bAiming > 0) 
		{
		start-script AimRunControl();
		return 0;
		}
			#endif
		#endif
		#ifdef OnlyProneFire
		if (bAiming > 0) 
		{
		start-script CrawlControl();
		return 0;
		}
		#endif
		if (bMoving == 0)
		{
	  	iState=1;
		start-script Stand(pickStance);
		sleep 200;
		//call-script StandingIdle();
		}
		
		if (bMoving == 1)
		{
		iState=4; 
		call-script Run();
		}
	}
}