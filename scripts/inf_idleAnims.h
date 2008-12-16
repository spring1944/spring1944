/* Todo: add animations <_<, keep signal mask list up to date, remove to an #include for neatness.
 
Also perhaps specify them by unit/unit class using a define, since 'schreck troops do different
things with their weapons while idle than a SMGer or something */

IdleIdle()
{
set-signal-mask SIG_IDLE | SIG_RUN | SIG_AIMRUN | SIG_CRAWL | SIG_AIM1;
var sleepTime;
sleepTime = rand(1500, 2500);
	while (bMoving==0)
	{
		hide gun;
		turn torso to x-axis <-30> speed <30>;
		turn head to x-axis <-30> speed <30>;
		turn rthigh to x-axis <20> speed <30>;
		turn luparm to x-axis <-90> speed <30>;
		turn lloarm to x-axis <-90> speed <30>;
		turn ruparm to x-axis <-110> speed <30>;
		turn ruparm to y-axis <30> speed <30>;
		turn rloarm to z-axis <-75> speed <30>;
		sleep sleepTime;
		turn luparm to x-axis <-100> speed <30>;
		turn lloarm to x-axis <-70> speed <30>;
		sleep (sleepTime/2);
		turn luparm to x-axis <-90> speed <30>;
		turn lloarm to x-axis <-90> speed <30>;
		sleep (sleepTime/2);
		turn luparm to x-axis <-100> speed <30>;
		turn lloarm to x-axis <-70> speed <30>;
		sleep (sleepTime/2);
		turn luparm to x-axis <-90> speed <30>;
		turn lloarm to x-axis <-90> speed <30>;
		sleep (sleepTime/2);
		turn luparm to x-axis <-100> speed <30>;
		turn lloarm to x-axis <-70> speed <30>;
		sleep sleepTime;
		turn torso to x-axis <0> speed <30>;
		turn head to x-axis <0> speed <30>;
		turn rthigh to x-axis <0> speed <30>;
		turn luparm to x-axis <0> speed <30>;
		turn lloarm to x-axis <0> speed <30>;
		turn ruparm to x-axis <0> speed <30>;
		turn ruparm to y-axis <0> speed <30>;
		turn rloarm to z-axis <0> speed <30>;
		sleep sleepTime;
	}
}

StandingIdle()
{
signal SIG_IDLE;
//set-signal-mask SIG_IDLE | SIG_RUN && SIG_CRAWL && SIG_AIM1;
set-signal-mask SIG_IDLE;
var pick;
if (iState > 0)
	{
	pick=rand(1,2);
	}
iState=0;
var count;
var sleepTime;
var headX;
var headY;
if (pick == 1)
	{
	sleepTime = rand (2400, 3000);
	while (bMoving==0)
		{
		count = (count + 1);
		if (count > 10)
		{
			iState = 1;
			call-script IdleIdle();
		}
		turn torso to y-axis <20> speed <20>;
		turn head to y-axis <30> speed <10>;
		sleep sleepTime;
		turn torso to y-axis <-20> speed <20>;
		turn head to y-axis <-30> speed <10>;
		sleep sleepTime;
		}
		if (bMoving==1) return 0;
	}
	
if (pick == 2)
	{
	sleepTime = rand (2400, 4000);
	while (bMoving==0)
		{
		count = (count + 1);
		headX = rand((0-20), 20);
		headY = rand((0-20), 20);
		turn pelvis to z-axis <5> speed <5>;
		turn head to x-axis (headX*182) speed <10>;
		turn head to y-axis (headY*182) speed <10>;
		turn lthigh to z-axis <-5> speed <5>;
		sleep sleepTime;
		turn pelvis to z-axis <0> speed <5>;
		turn head to x-axis <0> speed <20>;
		turn head to y-axis <0> speed <20>;
		turn rthigh to z-axis <0> speed <5>;
		turn lthigh to z-axis <0> speed <5>;
		sleep sleepTime;
		turn pelvis to z-axis <-5> speed <5>;
		turn head to x-axis (headX*182) speed <10>;
		turn head to y-axis (headY*182) speed <10>;
		turn rthigh to z-axis <5> speed <5>;
		sleep sleepTime;
		turn pelvis to z-axis <0> speed <5>;
		turn head to x-axis <0> speed <20>;
		turn head to y-axis <0> speed <20>;
		turn rthigh to z-axis <0> speed <5>;
		turn lthigh to z-axis <0> speed <5>;
		sleep sleepTime;
		if (count > 10)
			{
				iState = 1;
				call-script IdleIdle();
			}
		}
		if (bMoving==1) return 0;
	}
}

ProneIdle() //la de da
{
set-signal-mask SIG_IDLE | SIG_RUN | SIG_AIMRUN | SIG_CRAWL | SIG_AIM1;
}