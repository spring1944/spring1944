StartMoving()
{
	if (bAiming==0 && IsProne==1) 
	{
	sleep 500;
	if (bAiming==0)
		{
		bMoving=1;
   	 call-script FearRecovery();
	set CLOAKED to FALSE;
		}
	}
	if (bAiming==1)
	{
	return (0);
	}
	
	set ACTIVATION to 1;
	bMoving=1;
}


StopMoving()
{
	set ACTIVATION to 0;
    bMoving=0;
	sleep 10000;

	if (bMoving==0)
	{
	set CLOAKED to TRUE;
	start-script TakeCover();
	}

}