MoveCheck() //check if the unit is moving or not so that the animation is right when they stand up after prone.
//THIS WOULD BE MUCH EASIER WITH GET CURRENT_SPEED, but that seems to be broken.
{
      last_pos = get PIECE_XZ(ground); // current position
      sleep 20;

      if (last_pos - get PIECE_XZ(ground) != 0) // is it moving?
      {
	bMoving=1;
      }
      
   
      if (last_pos - get PIECE_XZ(ground) == 0) // or is it still?
      {
	bMoving=0;
      }
      sleep 10;
            if (last_pos - get PIECE_XZ(ground) != 0) // or is it really moving? - second check to catch any that missed it the first time.
      {
        bMoving=1;
      }
         
}