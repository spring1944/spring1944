#ifndef _TURNBUTTON_H_
#define _TURNBUTTON_H_
// Turn the unit to face the new direction
RotateHere(newDirection)
{
	var curHeading, turnSpeed, deltaHeading, numSteps;
	
	turnSpeed = <5>;
	curHeading = get HEADING;
	deltaHeading = newDirection - curHeading;
	// find the direction for shortest turn
	if (deltaHeading > <180>)
	{
		deltaHeading = deltaHeading - <360>;
	}
	if (deltaHeading < <-180>)
	{
		deltaHeading = deltaHeading + <360>;
	}
	// how many 1-frame steps the turn should have
	numSteps = deltaHeading / (turnSpeed/32);
	// that needs to be > 0, adjust if not
	if(numSteps < 0)
	{
		numSteps = 0 - numSteps;
		turnSpeed = 0 - turnSpeed;
	}
	// degree per second -> degree per frame
	turnSpeed = turnSpeed / 32;
	// do the turn
	while(numSteps > 0)
	{
		--numSteps;
		curHeading = curHeading + turnSpeed;
		if(curHeading < <-180>)
		{
			curHeading = curHeading + <360>;
		}
		if (curHeading > <180>)
		{
			curHeading = curHeading - <360>;
		}
		set HEADING to curHeading;
		sleep 30;
	}
	set HEADING to newDirection;
}
#endif