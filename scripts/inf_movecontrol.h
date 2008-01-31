StartMoving()
{
set MAX_SPEED to 1;
sleep 200;
set MAX_SPEED to [0.5];

	get PRINT (bAiming, IsProne, fear);
	if (fear>0 || transported==1) return 0;
	sleep 10;
	if (IsProne==1) sleep 500;
	sleep 10;
	if (IsProne==1 AND bAiming==1) return (0);
	sleep 10;

	if (IsProne==1 AND fear<=0 AND bAiming==0) 
	{
    	call-script FearRecovery();
    	call-script RestoreAfterCover(); 
    	bMoving=1;
	call-script WeaponReady();
    	start-script Run();
		set CLOAKED to FALSE;
		set ACTIVATION to 1;
		return (0);
	}
	sleep 10;
	
	if (isProne==0 AND fear<=0 AND bAiming==0)
	{
		bMoving=1;
		call-script WeaponReady();
	   	start-script Run();
		set CLOAKED to FALSE;
		set ACTIVATION to 1;
		return (0);
	}
}


StopMoving()
{
	signal 16;
	set-signal-mask 16;
	bMoving=0;
	set ACTIVATION to 0;
}