TakeCover()
{
set-signal-mask 0;
	if (IsProne == 0)
	{
	
				IsProne=1;
				CREW_SUPRESSED

	}
		SET MAX_SPEED to [0.00001];
		SET ARMORED to TRUE;

		sleep 100;
		return(0);
}

RestoreAfterCover() //get up out of the dirt. also controls going into pinned mode.
{
	

		if (fear <=0 && IsProne==1)
		{	
			fear=0;
			CREW_DEPLOY
				IsProne=0;
				SET ARMORED to FALSE;
				set MAX_SPEED to [0.5];
		
		}
		return (1);
		sleep 100;
	}