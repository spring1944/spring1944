/* Hitweap.h -- Rock the unit when it takes a hit */

#ifndef __HITWEAP_H_
#define __HITWEAP_H_

/*
** HitByWeapon() -- Called when the unit is hit.  Makes it rock a bit
**							to look like it is shaking from the impact.
*/

HitByWeapon(anglex,anglez)
	{
//	var	destx,destz;

	#define ROCK_SPEED 105
	#define RESTORE_SPEED 30

//	destx=<1>*anglex;
//	destz=<1>*anglez;

	turn base to z-axis anglez speed <ROCK_SPEED>;
	turn base to x-axis anglex speed <ROCK_SPEED>;

	wait-for-turn base around z-axis;
	wait-for-turn base around x-axis;

	turn base to z-axis <0> speed <RESTORE_SPEED>;
	turn base to x-axis <0> speed <RESTORE_SPEED>;
	}
#endif
