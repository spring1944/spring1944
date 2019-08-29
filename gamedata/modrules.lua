local modRules = {
	flankingBonus = {
		defaultMode					=	0,
	},
	experience = {
		powerScale					=	1.5,
		healthScale					=	1.5,
		reloadScale					=	0,
		experienceMult			=	1.25,
	},
	sensors = {
		los = {
			losMipLevel				=	3,
			airMipLevel				=	5,
		},
	},
	movement = {
		allowPushingEnemyUnits = true,
		allowUnitCollisionDamage  = false,
		allowUnitCollisionOverlap  = false,
	},
	nanospray = {
		allow_team_colours	=	false,
	},
	system = {
		pathFinderSystem = (Spring.GetModOptions() and (Spring.GetModOptions().qtpfs == "1") and 1) or 0,
	},
	transportability = {
		targetableTransportedUnits = true,
	},
}

return modRules
