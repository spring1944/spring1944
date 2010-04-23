#ifndef _SMOKESHELLSTOGGLE_
#define _SMOKESHELLSTOGGLE_

SetSmokeShellsState(newState)
{
	// 1 - switch to smoke. Otherwise switch to normal weapons
	isSmoking = (newState == 1);
	return;
}

SwitchToSmoke()
{
	call-script SetSmokeShellsState(1);
}

SwitchToHE()
{
	call-script SetSmokeShellsState(0);
}

#endif