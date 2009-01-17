#ifndef _MINECLEAR_H
#define _MINECLEAR_H

// some defines for the mine-clearing. Can be defined in unit script to be unit-specific
#ifndef MINE_SEARCH_RADIUS
#define MINE_SEARCH_RADIUS	[20]
#endif
#ifndef MINE_SERACH_TIME
#define MINE_SEARCH_TIME	5000
#endif

// called by cob to actually look for and clear the mines
lua_ClearMines(radius)
{
}

// called by lua button
LookForMines()
{
	if (iState > 6) return 0;
	signal SIG_RUN;
	var sweepNum;
	sweepNum = (MINE_SEARCH_TIME/1000);
	show detector;
	set MAX_SPEED to 1;
	turn head to x-axis <20> speed <400>;
	turn head to y-axis <0> speed <400>;
	turn head to z-axis <0> speed <400>;
	turn luparm to x-axis <-35> speed <400>;
	turn luparm to y-axis <-35> speed <400>;
	turn luparm to z-axis <0> speed <400>;
	turn lloarm to x-axis <-35> speed <400>;
	turn lloarm to y-axis <0> speed <400>;
	turn lloarm to z-axis <0> speed <400>;
	turn ruparm to x-axis <-30> speed <400>;
	turn ruparm to y-axis <20> speed <400>;
	turn ruparm to z-axis <0> speed <400>;
	turn rloarm to x-axis <-30> speed <400>;
	turn rloarm to y-axis <-20> speed <400>;
	turn rloarm to z-axis <0> speed <400>;
	turn torso to x-axis <10> speed <400>;
	var count;
	while (count < sweepNum)
		{
		turn torso to y-axis <-40> speed <200>;
		sleep ((MINE_SEARCH_TIME/sweepNum)/2);
		turn torso to y-axis <40> speed <200>;
		sleep((MINE_SEARCH_TIME/sweepNum)/2);
		count = count +1;
		}		
	// wait a specified amount of time
	//sleep MINE_SEARCH_TIME;
	// now clear the mines
	set MAX_SPEED to iSpeed;
	turn torso to x-axis <0> now;
	turn torso to y-axis <0> now;
	turn head to x-axis <0> now;
	hide detector;
	start-script RunControl();
	call-script lua_ClearMines(MINE_SEARCH_RADIUS);
	// done
}
#endif
