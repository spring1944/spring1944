-- Null Unit --
-- Used as base for sorties, squads, etc
local Null = Unit:New{
	category = "FLAG",
	explodeAs = "noweapon",
	footprintX = 1,
	footprintZ = 1,
	idleAutoHeal = 0,
	maxDamage = 1e+06,
	maxVelocity = 0.01,
	--movementClass = "KBOT_Infantry",
	objectName = "MortarShell.S3O",
	script = "null.cob",
	selfDestructAs = "noweapon",
	stealth = true,
}


return {
	Null = Null,
}