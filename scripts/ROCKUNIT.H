/* Rockunit.h -- Rock the unit when it fire a heavy weapon with lots of recoil */

#ifndef __ROCKUNIT_H_
#define __ROCKUNIT_H_


RockUnit(anglex,anglez)
	{
//	var destx,destz;

	#define ROCK_SPEED 50
	#define RESTORE_SPEED 20

//	destx=<1>*anglex;
//	destz=<1>*anglez;

	turn base to x-axis anglex speed <ROCK_SPEED>;
	turn base to z-axis anglez speed <ROCK_SPEED>;

	wait-for-turn base around z-axis;
	wait-for-turn base around x-axis;

	turn base to z-axis <0> speed <RESTORE_SPEED>;
	turn base to x-axis <0> speed <RESTORE_SPEED>;
	}
#endif
