TowStart()
{
	signal SIG_TOW;
	if (!isTowed)
	{
		turn carriage to y-axis CARRIAGE_TOW_ANGLE now;
		//move carriage to z-axis (0-CARRIAGE_TOW_OFFSET) now;
		
	}
	gunTowHeading = 0;
	isTowed = TRUE;
}

TowEnd()
{
	signal SIG_TOW;
	if (isTowed)
	{
		//move carriage to z-axis [0] now;
		
		turn carriage to y-axis <0> now;
	}
	gunTowHeading = 0;
	isTowed = FALSE;
}


// This function updates gun towing animation

TowDirectionControl()
{
	var curHeading, oldHeading, oldTowHeading, deltaAngle, turnSpeed, newAngle, tmpMult, curXZ, prevXZ;
	set-signal-mask SIG_TOW;
	
	curXZ = get PIECE_XZ (carriage);
	prevXZ = curXZ;
	oldTowHeading = gunTowHeading;
	// Work is done in cycles so that dynamic heading changes can be processed
	
	while(TRUE)
	{
		curHeading = get HEADING;
		// how far should we turn the gun
		
		deltaAngle = curHeading - oldHeading;
		
		// This is needed to prevent strange things from happening on sharp turns
		
		if(deltaAngle > <180>)
		{
			deltaAngle = deltaAngle - <360>;
		}
		if(deltaAngle < (0 - <180>))
		{
			deltaAngle = deltaAngle + <360>;
		}
		
		oldHeading = curHeading;
		gunTowHeading = gunTowHeading - deltaAngle;
		turnSpeed = TOW_TURN_SPEED;
		// Determine sign(gunTowHeading)
		
		if(gunTowHeading>0)
		{
			tmpMult=1;
		} else {
			tmpMult= -1;
		}
		// limit the max. angle
		
		if(gunTowHeading*tmpMult > TOW_MAX_ANGLE)
		{
			gunTowHeading = TOW_MAX_ANGLE * tmpMult;
		}
		
		if(gunTowHeading*tmpMult < TOW_MIN_ANGLE)
		{
		// Angle is small, just turn the trailer to match the tractor
		
			deltaAngle = 0;
			newAngle = 0;
			gunTowHeading = 0;
		}
		if (gunTowHeading*tmpMult >= TOW_MIN_ANGLE)
		{
		// Angle isn't small, do the proper turning
		
			newAngle = gunTowHeading - tmpMult*TOW_MIN_ANGLE;
		}
		if (((gunTowHeading - oldTowHeading) > TOW_JUMP_ANGLE) || ((gunTowHeading - oldTowHeading) < (0 - TOW_JUMP_ANGLE)))
		{
			turn carriage to y-axis gunTowHeading now;
		} else {
			turn carriage to y-axis gunTowHeading speed turnSpeed;
		}
		oldTowHeading = gunTowHeading;
		gunTowHeading = newAngle;

		// wheel turning. Notice it's reversed compared to normal moving - the gun is towed backwards
		
		curXZ = get PIECE_XZ (carriage);
		if (curXZ != prevXZ)
		{
			spin wheel3 around x-axis speed (0 - WHEEL_SPIN) accelerate WHEEL_ACCEL;
			prevXZ = curXZ;
		} else {
			stop-spin wheel3 around x-axis;
		}

		sleep TOW_CHECK_PERIOD;
	}
}



StartMoving()
{
	set ACTIVATION to 1;
	/*emit-sfx 257 from exhaust;
	sleep 50;
	emit-sfx 257 from exhaust;
	sleep 50;
	emit-sfx 257 from exhaust;*/
	spin wheel1 around x-axis speed <350.082418>;
	spin wheel2 around x-axis speed <350.082418>;
	call-script TowStart();
}

StopMoving()
{
	set ACTIVATION to 0;
	stop-spin wheel1 around x-axis decelerate <100.000000>;
	stop-spin wheel2 around x-axis decelerate <100.000000>;
	call-script TowEnd();

}