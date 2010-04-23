/* RockUnit_Set.h - Rock the unit when firing a weapon only if a var is set */

#ifndef __ROCKUNIT_SET_H_
#define __ROCKUNIT_SET_H_

// ROCK_SPEED (50), RESTORE_SPEED (20) and ROCKVAR must all be defined
//
RockUnit(anglex,anglez)
{
  if (ROCKVAR) {
    turn base to x-axis anglex speed ROCK_SPEED;
    turn base to z-axis anglez speed ROCK_SPEED;

    wait-for-turn base around z-axis;
    wait-for-turn base around x-axis;

    turn base to z-axis <0> speed RESTORE_SPEED;
    turn base to x-axis <0> speed RESTORE_SPEED;
  }
}
#endif
