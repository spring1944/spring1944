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
		if (bMoving == 0)
		{
	  	//iState=2; //standing at attention
		call-script Stand();
		//start-script TenseIdle();
		}	
	  
		if (bMoving == 1)
		{
		iState=5; //aiming & running
		set MAX_SPEED to (UNIT_SPEED/AIM_SLOWDOWN_FACTOR);
		call-script AimRun(); //this has a sleep at the end of it, so theoretically no lockups
		}
	}
}


PinnedControl() //hit the dirt and kiss your ass goodbye...
{
	signal SIG_PINNEDCTRL;
	set-signal-mask SIG_PINNEDCTRL;
	signal SIG_AIM1;
	signal SIG_CRAWL;
	set MAX_SPEED to (UNIT_SPEED/4000);
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
signal SIG_RUN;
signal SIG_AIMRUN;
signal SIG_CRAWL;
set-signal-mask SIG_CRAWL;
var pickSide;
pickSide = rand(1,2);
	while(1)
	{
		if (iFear > PinnedLevel && iState !=9 )	start-script PinnedControl();

		if (iState == 9) signal SIG_CRAWL;
		
		if (bMoving == 0)
		{
	  	call-script Prone(pickSide);
		}
		
		if (bMoving == 1)
		{
		iState=8; //crawling
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
	signal SIG_AIMRUN;
	signal SIG_RUN;
	set-signal-mask SIG_RUN;
	start-script WeaponReady();
	while(1)
	{
		if (bEngaged) start-script AimRunControl();
		
		if (bMoving == 0)
		{
	  	iState=1; //standing at attention
		call-script Stand();
		}
		
		if (bMoving == 1)
		{
		iState=4; //just running
		call-script Run();//this has a sleep at the end of it, so theoretically no lockups
		}
	}
}