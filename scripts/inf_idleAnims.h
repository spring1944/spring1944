/* Todo: add animations <_<, keep signal mask list up to date, remove to an #include for neatness.
 
Also perhaps specify them by unit/unit class using a define, since 'schreck troops do different
things with their weapons while idle than a SMGer or something */

IdleIdle()
{
set-signal-mask SIG_RUN;
set-signal-mask SIG_AIMRUN;
set-signal-mask SIG_CRAWL;
set-signal-mask SIG_AIM1;

}

TenseIdle() //aiming mode
{
set-signal-mask SIG_RUN;
set-signal-mask SIG_AIMRUN;
set-signal-mask SIG_CRAWL;
set-signal-mask SIG_AIM1;
signal SIG_IDLE;
set-signal-mask SIG_IDLE;
var pick;
pick=rand(1,1);
if (pick == 1)
	{
	while (bMoving == 0 && bEngaged == 1)
		{
		sleep 600;
		turn torso to y-axis <20> speed <60>;
		turn head to y-axis <30> speed <40>;
		sleep 600;
		turn torso to y-axis <-20> speed <60>;
		turn head to y-axis <-30> speed <40>;
		sleep 600;
		}
	}
}

ProneIdle() //la de da
{
set-signal-mask SIG_RUN;
set-signal-mask SIG_AIMRUN;
set-signal-mask SIG_CRAWL;
set-signal-mask SIG_AIM1;
}