
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