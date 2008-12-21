/*
--The default 'ready' pose of the unit--
TODO: actually write these many poses and implement random picking
Functions:
just WeaponReady()...
*/
WeaponReady() //structure is here to allow for multiple poses (either per unit class or even multiples per unit class)
{
var pickStance;
pickStance=rand(1, StanceNumber);
show gun;
//bEngaged = FALSE;
	#ifdef MG
	if (pickStance == 1)
	{
	MG_STANCE1
	}
	if (pickStance == 2)
	{
	MG_STANCE2
	}
	#endif
	#ifdef ATROCKET
	if (pickStance == 1)
	{
	ATROCKET_STANCE1
	}
	if (pickStance == 2)
	{
	ATROCKET_STANCE2
	}
	#endif
	#ifdef SNIPER
	if (pickStance == 1)
	{
	SNIPER_STANCE1
	}
	if (pickStance == 2)
	{
	SNIPER_STANCE2
	}
	if (pickStance == 3)
	{
	SNIPER_STANCE3
	}
	#endif
	#ifdef SCOUT
	if (pickStance == 1)
	{
	SCOUT_STANCE1
	}
	if (pickStance == 2)
	{
	SCOUT_STANCE2
	}	
	if (pickStance == 3)
	{
	SCOUT_STANCE3
	}
	#endif
	#ifdef ENGINEER
	if (pickStance == 1)
	{
	ENGINEER_STANCE1
	}
	#endif
#ifdef WEAPON_GRENADE
	if (!bNading)
	{
		#ifdef RIFLE
		show gun;
		if (pickStance == 1)
		{
		RIFLE_STANCE1
		}
		if (pickStance == 2)
		{
		RIFLE_STANCE3
		}
		if (pickStance == 3)
		{
		RIFLE_STANCE2
		}
		#endif
		#ifdef SMG
		show gun;
		if (pickStance == 1)
		{
		SMG_STANCE1
		}
		if (pickStance == 2)
		{
		SMG_STANCE2
		}
		#endif
	}
#endif
}