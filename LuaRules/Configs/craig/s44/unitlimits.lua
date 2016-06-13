-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

-- Do not limit units spawned through LUA! (infantry that is build in platoons,
-- deployed supply trucks, deployed guns, etc.)

-- On easy, limit both engineers and buildings until I've made an economy
-- manager that can tell the AI whether it has sufficient income to build
-- (and sustain) a particular building (factory).
-- (AI doesn't use resource cheat in easy)

-- On medium, limit engineers (much) more then on hard.

-- On hard, losen restrictions a bit more.

-- Format: unitname = { easy limit, medium limit, hard limit }
local unitLimits = UnitBag{
	-- engineers
	gbrhqengineer        = { 1, 1, 3 },
	gbrmatadorengvehicle = 1,
	gerhqengineer        = { 1, 1, 3 },
	gersdkfz9            = 1,
	ruscommissar         = { 1, 1, 2 }, --2 for flag capping + 2-3 for base building
	rusengineer          = { 1, 2, 2 },
	rusk31               = 1,
	ushqengineer         = { 1, 1, 3 },
	usgmcengvehicle      = 1,
	jpnhqengineer		= { 1, 1, 3 },
	jpnriki		      = 1,
	itahqengineer         = { 1, 1, 3 },
	itabreda41	      = 1,
	sweengineer			= {1, 1, 3},
	hunengineer			= {1, 1, 3},
	hunbergehetzer		= 1,
	-- buildings
	gbrbarracks    = { 3, 3, 4 },
	gerbarracks    = { 3, 3, 4 },
	rusbarracks    = { 3, 3, 4 },
	ruspshack		= {1, 2, 2},
	usbarracks     = { 3, 3, 4 },
	jpnbarracks     = { 3, 3, 4 },
	itabarracks     = { 3, 3, 3 },
	swebarracks		= { 3, 3, 3 },
	hunbarracks		= { 3, 3, 3 },
	gbrstorage     = 10,
	gerstorage     = 10,
	russtorage     = 10,
	usstorage      = 10,
	jpnstorage      = 10,
	itastorage      = 10,
	swestorage      = 10,
	hunstorage      = 10,
	gbrsupplydepot = { 1, 1, 2 },
	gersupplydepot = { 1, 1, 2 },
	russupplydepot = { 1, 1, 2 },
	ussupplydepot  = { 1, 1, 2 },
	jpnsupplydepot  = { 1, 1, 2 },
	itasupplydepot  = { 1, 1, 2 },
	swesupplydepot  = { 1, 1, 2 },
	hunsupplydepot  = { 1, 1, 2 },
	gbrtankyard    = { 1, 2, 4 },
	gbrtankyard1   = { 0, 1, 1 },
	gbrtankyard2   = { 0, 1, 1 },
	gbrspyard    = { 0, 1, 1 },
	gbrspyard1   = { 0, 1, 1 },
	gertankyard    = { 1, 2, 4 },
	gertankyard1   = { 0, 1, 1 },
	gertankyard2   = { 0, 1, 1 },
	gerspyard    = { 0, 1, 1 },
	gerspyard1   = { 0, 1, 1 },
	rustankyard    = { 1, 2, 4 },
	rustankyard1   = { 0, 1, 1 },
	rustankyard2   = { 0, 1, 1 },
	russpyard    = { 0, 1, 1 },
	russpyard1   = { 0, 1, 1 },
	ustankyard     = { 1, 2, 4 },
	ustankyard1     = { 0, 1, 1 },
	ustankyard2     = { 0, 1, 1 },
	usspyard     = { 0, 1, 2 },
	jpntankyard     = { 1, 2, 4 },
	jpntankyard1     = { 0, 1, 2 },
	jpntankyard2     = { 0, 1, 2 },
	jpnspyard = { 0, 1, 1 },
	jpnspyard1 = { 0, 1, 1 },
	itatankyard     = { 1, 2, 3 },
	swetankyard     = { 1, 2, 3 },
	swetankyard1     = { 1, 2, 3 },
	huntankyard     = { 1, 2, 3 },
	huntankyard1     = { 1, 2, 3 },
	huntankyard2     = { 1, 2, 3 },
	gbrvehicleyard = { 1, 1, 2 },
	gervehicleyard = { 1, 1, 2 },
	rusvehicleyard = { 1, 1, 2 },
	usvehicleyard  = { 1, 1, 2 },
	jpnvehicleyard  = { 1, 1, 2 },
	jpnvehicleyard1 = { 0, 1, 2 },
	jpnvehicleyard2 = { 0, 1, 2 },
	itavehicleyard  = { 1, 1, 2 },
	itatankyard1     = { 0, 1, 2 },
	itaspyard     = { 0, 1, 1 },
	itaelitebarracks     = { 0, 1, 2 },
	swevehicleyard     = { 1, 2, 3 },
        swevehicleyard1     = { 1, 2, 3 },
	hunvehicleyard     = { 1, 2, 3 },
	hunvehicleyard1     = { 1, 2, 3 },
	hunspyard     = { 1, 2, 3 },
	hunspyard1     = { 1, 2, 3 },
	swespyard     = { 1, 2, 3 },
	swespyard1     = { 1, 2, 3 },
}

-- Convert to format expected by C.R.A.I.G., based on the difficulty.
local difficultyTable = { easy = 1, medium = 2, hard = 3 }
local difficultyIndex = difficultyTable[gadget.difficulty] or 3
gadget.unitLimits = {}
for k,v in pairs(unitLimits) do
	if (type(v) == "table") then
		gadget.unitLimits[k] = v[difficultyIndex]
	else
		gadget.unitLimits[k] = v
	end
end
