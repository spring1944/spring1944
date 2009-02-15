/*
** EXPtype.h -- Explosion Type information for scripts
**
** Copyright 1997 Cavedog Entertainment
*/

#ifndef EXPTYPE_H
#define EXPTYPE_H

/*
Special Effect Particles referenced in the scripting language
with the command emit-sfx.  This file is included by any scripts
that use the command, as well as TAObjScr.cpp in the game, so
it can start the proper effect.
*/

/*
Exploding pieces are activated in the scripting language with
the command "explode".  This file is included by any scripts
that use the command, as well as TAObjScr.cpp in the game, so
it can create the proper effect.
*/

// IMPORTANT:	If you change these defines, copy the file to
//				v:\totala\cdimage\scripts so the scripts have
//				access to the proper data, and recompile them.

#define SHATTER			1		// The piece will shatter instead of remaining whole
#define EXPLODE_ON_HIT		2		// The piece will explode when it hits the ground
#define FALL			4		// The piece will fall due to gravity instead of just flying off
#define SMOKE			8		// A smoke trail will follow the piece through the air
#define FIRE			16		// A fire trail will follow the piece through the air
#define BITMAPONLY		32		// The piece will not fly off or shatter or anything.  Only a bitmap explosion will be rendered.


// Bitmap Explosion Types (these will be changed eventually)

#define BITMAP1			256
#define BITMAP2			512
#define BITMAP3			1024
#define BITMAP4			2048
#define BITMAP5			4096
#define BITMAPNUKE		8192

#define BITMAPMASK		16128	// Mask of the possible bitmap bits

// New in TA:K
#define EXPTYPE_SMALLEXPLOSION	256
#define EXPTYPE_MEDIUMEXPLOSION	512
#define EXPTYPE_LARGEEXPLOSION	1024
#define EXPTYPE_XLARGEEXPLOSION	2048
#define EXPTYPE_BLOODEXPLOSION	4096
#define EXPTYPE_SMALLSMOKE		8192
#define EXPTYPE_MEDIUMSMOKE		16384
#define EXPTYPE_XLARGESMOKE		65536


// Damage types in TA:K
#define DT_FIRE					2
#define DT_EXPLOSION			3
#define DT_PARALYZER			4


// Indices for set/get value
#define ACTIVATION			1	// set or get
#define STANDINGMOVEORDERS	2	// set or get
#define STANDINGFIREORDERS	3	// set or get
#define HEALTH				4	// get (0-100%)
#define INBUILDSTANCE		5	// set or get
#define BUSY				6	// set or get (used by misc. special case missions like transport ships)
#define PIECE_XZ			7	// get
#define PIECE_Y				8	// get
#define UNIT_XZ				9	// get
#define	UNIT_Y				10	// get
#define UNIT_HEIGHT			11	// get
#define XZ_ATAN				12	// get atan of packed x,z coords
#define XZ_HYPOT			13	// get hypot of packed x,z coords
#define ATAN				14	// get ordinary two-parameter atan
#define HYPOT				15	// get ordinary two-parameter hypot
#define GROUND_HEIGHT		16	// get
#define BUILD_PERCENT_LEFT	17	// get 0 = unit is built and ready, 1-100 = How much is left to build
#define YARD_OPEN			18	// set or get (change which plots we occupy when building opens and closes)
#define BUGGER_OFF			19	// set or get (ask other units to clear the area)
#define ARMORED				20	// set or get
// New in TA:K
#define WEAPON_AIM_ABORTED	21
#define WEAPON_READY		22
#define WEAPON_LAUNCH_NOW	23
#define FINISHED_DYING		26
#define ORIENTATION			27
#define IN_WATER			28
#define CURRENT_SPEED		29
#define MAGIC_DEATH			31
#define VETERAN_LEVEL		32
#define ON_ROAD				34
//New in Spring
#define MAX_ID			70	//returns maximum number of units - 1
#define MY_ID			71	//returns ID of current unit
#define UNIT_TEAM		72	//returns team of unit given with parameter
#define UNIT_BUILD_PERCENT_LEFT	73	//basically BUILD_PERCENT_LEFT, but comes with a unit parameter
#define UNIT_ALLIED		74	//is unit given with parameter allied to the unit of the current COB script. 1=allied, 0=not allied
#define MAX_SPEED		75	//Unit's current max speed multiplied by 64k
#define CLOAKED			76	//is the unit cloaked
#define WANT_CLOAK		77	//orders the unit to attempt to cloak
#define GROUND_WATER_HEIGHT	78	//same as GROUND_HEIGHT, only returns negative values for water depth
#define UPRIGHT			79	//can toggle uprightness of a unit

#define	POW                      80 // get
#define PRINT                    81 // get, so multiple args can be passed
#define HEADING                  82 // get
#define TARGET_ID                83 // get
#define LAST_ATTACKER_ID         84 // get
#define LOS_RADIUS               85 // set or get
#define AIR_LOS_RADIUS           86 // set or get
#define RADAR_RADIUS             87 // set or get
#define JAMMER_RADIUS            88 // set or get
#define SONAR_RADIUS             89 // set or get
#define SONAR_JAM_RADIUS         90 // set or get
#define SEISMIC_RADIUS           91 // set or get
#define DO_SEISMIC_PING          92 // get
#define CURRENT_FUEL             93 // set or get
#define TRANSPORT_ID             94 // get
#define SHIELD_POWER             95 // set or get
#define STEALTH			 96
#define CRASHING		 97
#define CHANGE_TARGET		98 // set, the value it's set to determines the affected weapon
#define CEG_DAMAGE		99 // set
#define COB_ID			100 // get - cobid fbi parameter
#define PLAY_SOUND		 101 // get, so multiple args can be passed
#define KILL_UNIT                102 // get KILL_UNIT(unitId, SelfDestruct=true, Reclaimed=false)
#define ALPHA_THRESHOLD         103 // set or get
#define SET_WEAPON_UNIT_TARGET   106 // get (fake set)
#define SET_WEAPON_GROUND_TARGET 107 // get (fake set)

// NOTE: [LUA0 - LUA9] are defined in CobThread.cpp as [110 - 119]

#define FLANK_B_MODE             120 // set or get
#define FLANK_B_DIR              121 // set or get, set is through get for multiple args
#define FLANK_B_MOBILITY_ADD     122 // set or get
#define FLANK_B_MAX_DAMAGE       123 // set or get
#define FLANK_B_MIN_DAMAGE       124 // set or get
#define WEAPON_RELOADSTATE       125 // get (with fake set)
#define WEAPON_RELOADTIME        126 // get (with fake set)
#define WEAPON_ACCURACY          127 // get (with fake set)
#define WEAPON_SPRAY             128 // get (with fake set)
#define WEAPON_RANGE             129 // get (with fake set)
#define WEAPON_PROJECTILE_SPEED  130 // get (with fake set)

#endif // EXPTYPE_H
