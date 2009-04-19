FearRecovery() 
{ 
signal SIG_FEARRECOVERY;
set-signal-mask SIG_FEARRECOVERY;
	
     while(iFear > 0) 
        { 
	        sleep RecoverRate; 
			iFear = iFear - RecoverConstant; 
        } 
	//start-script RestoreAfterCover();   
	return (1);  
}

HitByWeaponId(z,x,id,damage)
{	
	if (id != 701) return (100);
	if (id==701)
	{
	iFear = iFear + AAFear;
	if (iFear > FearLimit) iFear = FearLimit; // put this line AFTER increasing iFear var		
	start-script FearRecovery();
	//return (100);
	}
	return (100);
}

luaFunction(arg1)
{
 arg1 = iFear;
}