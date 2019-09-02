local tent = piece "tent"
local t1 = piece "t1"
local t2 = piece "t2"
local antenna = piece "antenna"
local sleeve_lights = piece "sleeve_lights"

local random = math.random

local turret_mode
local tent_mode
local lights_mode
local antenna_mode

local function CustomizePieces()

	local customizationCode = (Spring.GetUnitRulesParam(unitID, "customization_code") or 0)
	local customizationString = '' .. customizationCode

	if customizationCode > 0 then
		antenna_mode = customizationCode % 10
		customizationCode = (customizationCode - antenna_mode) / 10
		
		lights_mode = customizationCode % 10
		customizationCode = (customizationCode - lights_mode) / 10
		
		tent_mode = customizationCode % 10
		customizationCode = (customizationCode - tent_mode) / 10
		
		turret_mode = customizationCode % 10
		customizationCode = (customizationCode - turret_mode) / 10
		
	else
		turret_mode = random(2)
		tent_mode = random(2)
		lights_mode = random(2)
		antenna_mode = random(2)

		customizationCode = turret_mode * 1000 + tent_mode * 100 + lights_mode * 10 + antenna_mode
		Spring.GetUnitRulesParam(unitID, "customization_code", customizationCode)
	end

	if t1 and t2 then
		if turret_mode == 1 then
			Hide(t2)
			Hide(antenna)
		else
			Hide(t1)
			if antenna_mode == 1 then
				Hide(antenna)
			end
		end
		if tent_mode == 1 then
			Hide(tent)
		end
		if lights_mode == 1 then
			Hide(sleeve_lights)
		end
	end

end

local anims =
{
	postCreate = CustomizePieces,
}

return anims