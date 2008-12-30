StartBuilding(buildheading, pitch)
{
signal SIG_BUILD;
set-signal-mask SIG_BUILD;
turn ground to y-axis buildheading now;
set INBUILDSTANCE to 1;
turn gun to y-axis pitch now;
}

StopBuilding()
{
SIGNAL SIG_BUILD;
turn ground to y-axis <0> now;
set INBUILDSTANCE to 0;
}

QueryNanoPiece(piecenum)
{
piecenum = gun;
}