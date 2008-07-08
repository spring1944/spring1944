
FearRecovery() 
{ 

	if (fear>PinnedLevel && IsPinned==0) call-script Pinned();


     if (DecreasingFear==1) return (1);  // better to use signals here


     DecreasingFear = 1;
     while(fear > 0) 
          { 
			if (0<fear && fear < PinnedLevel && IsPinned==1)

		{
			call-script RestoreFromPinned();
			sleep 100;
		}

          fear = fear - RecoverConstant; 
          sleep RecoverRate; 
          } 
start-script RestoreAfterCover(); 
DecreasingFear=0; 
 
return (1); 
}


HitByWeaponId(z,x,id,damage)
{	
	if (Id<=300 || Id>700)
		return (100); // DON'T NEED BRACKETS FOR return STATEMENTS!
	
	if (Id==301) fear = fear + LittleFear; //small arms or very small calibre cannon: MGs, snipers, LMGs, 20mm
	if (Id==401) fear = fear + MedFear; //small/med explosions: mortars, 75mm guns and under
	if (Id==501) fear = fear + BigFear;  //large explosions: small bombs, 155mm - 88mm guns,
	if (Id==601) fear = fear + MortalFear; //omgwtfbbq explosions: medium/large bombs, 170+mm guns, rocket arty 

	if (fear > FearLimit) fear = FearLimit; // put this line AFTER increasing fear var
		
	start-script TakeCover();
	sleep 100; // what is this for??
	start-script FearRecovery();
	
	return (1); //if it gets to here, its a nondamaging suppression weapon anyways, so 1% doesn't matter. // You can return 0 now
}
//lets Lua suppression notification see what fear is at
luaFunction(arg1)
{
 arg1 = fear;
}
