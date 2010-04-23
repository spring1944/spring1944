#ifndef _DAMAGESMOKE_H
#define _DAMAGESMOKE_H
#ifndef SMOKEPIECE
#define SMOKEPIECE	hull
#endif
DamageSmoke()
{
	var CurHealth, SmokeType, DelayTime;
	while (get BUILD_PERCENT_LEFT)
	{
		sleep 200;
	}
	DelayTime = rand(10, 150);
	sleep DelayTime;
	while (TRUE)
	{
		CurHealth=get HEALTH;
		if (CurHealth<66)
		{
			SmokeType=SFXTYPE_BLACKSMOKE;
			if (rand(1, 66)<CurHealth)
			{
				SmokeType=SFXTYPE_WHITESMOKE;
			}
			emit-sfx SmokeType from SMOKEPIECE;
			DelayTime = CurHealth * BASE_SMOKE_PERIOD;
			if (DelayTime<MIN_SMOKE_PERIOD)
			{
				DelayTime = MIN_SMOKE_PERIOD;
			}
		} else DelayTime = MIN_SMOKE_PERIOD;
		sleep DelayTime;		
	}
}
#endif