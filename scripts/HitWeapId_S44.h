/* HitWeapId_S44.h -- Rock the unit when it takes a hit for S44 */

#ifndef __HITWEAPID_S44_H_
#define __HITWEAPID_S44_H_

#ifndef HIT_ROCK_SPEED
#define HIT_ROCK_SPEED	<105>
#endif

#ifndef HIT_RESTORE_SPEED
#define HIT_RESTORE_SPEED	<30>
#endif

//#ifndef ARMOUR
//#define ARMOUR	get MAX_HEALTH

#define COBSCALE	65536
#define ExCOBSCALE      178145
#ifndef QUALITY
  #define QUALITY	2280	// =0.0275
#endif
#define AT_WEAPON	100

HitAnim(anglez, anglex) 
{
	signal 16;
	set-signal-mask 16;
	
	turn base to z-axis anglez speed HIT_ROCK_SPEED;
	turn base to x-axis anglex speed HIT_ROCK_SPEED;

	wait-for-turn base around z-axis;
	wait-for-turn base around x-axis;

	turn base to z-axis <0> speed HIT_RESTORE_SPEED;
	turn base to x-axis <0> speed HIT_RESTORE_SPEED;
}
	
HitByWeaponId(anglez,anglex,id,damage)
{
	var armour, newDamage, tempDamage;
	if (Id>49 && Id<300) start-script HitAnim(anglez, anglex);
	if (id == AT_WEAPON) {
		armour = ARMOUR;
		newDamage = 100;
		tempDamage = damage / 100;
		if (tempDamage == 0) return 0;
		else if (tempDamage >= armour) return 100;
		newDamage = (tempDamage/100 * get POW (ExCOBSCALE, ((0-QUALITY) * (armour/100 - tempDamage/100))))/COBSCALE;
		#ifdef DEBUG
		get PRINT (tempDamage, newDamage, newDamage * 10000 / tempDamage);
		#endif
		return newDamage * 10000 / tempDamage;
	}
	else return 100;
}
#endif