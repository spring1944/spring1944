#ifndef _RANGEFINDER_H
#define _RANGEFINDER_H

// rangefinder script
RangeFinder(weaponNum)
{
	var targetID, eY, eXZ, dY, myXZ, dXZ, myY, range;
	
	targetID=get TARGET_ID(weaponNum);
	if(targetID>0)
	{
		eXZ = get UNIT_XZ(targetID);
		eY = get UNIT_Y(targetID);
		
		myXZ = get UNIT_XZ(get MY_ID);
		myY = get UNIT_Y(get MY_ID);
		
		dY = myY - eY;
		dXZ = myXZ - eXZ;
		
		range = get XZ_HYPOT(dXZ);
		range = get HYPOT(range, dY);
		
		// add a random spread to range
		range = (range - 50)*((100 - RANGE_INACCURACY_PERCENT/2)/100) + rand(0, range)*RANGE_INACCURACY_PERCENT/100;

		//get PRINT(range);
		
		if(range>originalRange)
		{
			range = originalRange;
		}
		
		eY = get WEAPON_RANGE((0-weaponNum), range);
	}
}

RangefinderReset(weaponNum)
{
	get WEAPON_RANGE((0-weaponNum), originalRange);
}
#endif