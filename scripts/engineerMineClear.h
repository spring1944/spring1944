#ifndef _MINECLEAR_H
#define _MINECLEAR_H

// some defines for the mine-clearing. Can be defined in unit script to be unit-specific
#ifndef MINE_SEARCH_RADIUS
#define MINE_SEARCH_RADIUS	[20]
#endif
#ifndef MINE_SERACH_TIMR
#define MINE_SEARCH_TIME	5000
#endif

// called by cob to actually look for and clear the mines
lua_ClearMines(radius)
{
}

// called by lua button
LookForMines()
{
	// place some animation there
	// wait a specified amount of time
	sleep MINE_SEARCH_TIME;
	// now clear the mines
	call-script lua_ClearMines(MINE_SEARCH_RADIUS);
	// done
}
#endif
