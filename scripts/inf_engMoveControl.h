StartMoving()
{
	if (IsProne==1 && fear<=0) 
	{
    	call-script FearRecovery();
    	call-script RestoreAfterCover(); 
    	bMoving=1;
    	start-script Run();
		set CLOAKED to FALSE;
		set ACTIVATION to 1;
		return (0);
	}
	if (fear>0)
	{
	return (0);
	}
	

		bMoving=1;
	   	start-script Run();
		set CLOAKED to FALSE;
		set ACTIVATION to 1;
		return (0);
}


StopMoving()
{
	signal 16;
	set-signal-mask 16;
	bMoving=0;
	set ACTIVATION to 0;
}