/* HitWeap_Set.h -- Rock the unit when it takes a hit */

#ifndef __HITWEAP_SET_H_
#define __HITWEAP_SET_H_

/*
* HitByWeapon() -- Called when the unit is hit.  Makes it rock a bit to look like it is shaking from the impact.
* Must define HIT_ROCK_SPEED (<105>) and HIT_RESTORE_SPEED (<30>) 
*/

HitByWeapon(anglex,anglez)
	{
	turn base to z-axis anglez speed HIT_ROCK_SPEED;
	turn base to x-axis anglex speed HIT_ROCK_SPEED;

	wait-for-turn base around z-axis;
	wait-for-turn base around x-axis;

	turn base to z-axis <0> speed HIT_RESTORE_SPEED;
	turn base to x-axis <0> speed HIT_RESTORE_SPEED;
	}
#endif
