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

#endif // EXPTYPE_H
