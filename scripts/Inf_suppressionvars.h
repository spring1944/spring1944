//run cycle vars
#define RUNSTOP				64 //just leave this. the signal to kill the anim
#define STANDTIME			5000 //how long they wait to dive after standing still

//#define NadePenalty 4000 //50% of nade reload - disabled currently because I couldn't get it working, likewise for rifle
//#define ReloadPenalty 1500 //50% of normal reload time (k98k normal reload=3s) - gets added to every firing cycle while prone
#define FearLimit	20 //max amount of fear they can possibly get. any additional is ignored
#define RecoverConstant 1  //how much fear they subtract from the total each RecoverRate
#define PinnedLevel	15 //fear level where they stop shooting and freeze on the ground
#define RecoverRate	1000 //how often RecoverConstant is subtracted from total fear level
//#define InitialFreeze 2000 //how long they stay down before they start recovering
//various levels of fear added when these weapons hit
#define LittleFear	3 //small arms or very small calibre cannon: MGs, snipers, LMGs, 20mm
#define MedFear	6 //small/med explosions: mortars, 88mm guns and under
#define BigFear	11 //large explosions: small bombs, 155mm - 105mm guns
#define MortalFear	16 //omgwtfbbq explosions: medium/large bombs, 170+mm guns, rocket arty


