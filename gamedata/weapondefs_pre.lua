-- Enter NOWEAPON here
local NOWEAPON = {
	name = "Missing Weapon! Please report as a bug!",
	explosionGenerator = "custom:nothing",
	damage = {
		default = 1e-5, -- 0 is rounded up to 1
	}
}
WeaponDefs["noweapon"] = NOWEAPON