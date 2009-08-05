
//Fear recovery defs
#define FearLimit	25 //max amount of fear they can possibly get. any additional is ignored
#define RecoverConstant 1  //how much fear they subtract from the total each RecoverRate
#define PinnedLevel	20 //fear level where they stop shooting and freeze on the ground
#define RecoverRate	1000 //how often RecoverConstant is subtracted from total fear level
#define initialDelay	5000 //the amount that they stay on the ground, regardless of fear level, upon first being hit

//various levels of fear added when these weapons hit
#define LittleFear	2 //small arms or very small calibre cannon: MGs, snipers, LMGs, 20mm
#define MedFear	4 //small/med explosions: mortars, 88mm guns and under
#define BigFear	8 //large explosions: small bombs, 155mm - 105mm guns
#define MortalFear	16 //omgwtfbbq explosions: medium/large bombs, 170+mm guns, rocket arty

#define CRAWL_SLOWDOWN_FACTOR	5 //UNIT_SPEED is divided by this while the unit is crawling
#define AIM_SLOWDOWN_FACTOR		1 //UNIT_SPEED is divided by this while the unit is moving and aiming
