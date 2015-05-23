function gadget:GetInfo()
	return {
		name	  = "Developer commands",
		desc	  = "/luarules <foo> where <foo> == stuff that's handy for development",
		author	  = "B. Tyler",
		date	  = "May 22, 2015",
		license   = "GPLv2",
		layer	  = -2,
		enabled   = true --  loaded by default?
	}
end

if not gadgetHandler:IsSyncedCode() then return end

local GetPlayerInfo	    = Spring.GetPlayerInfo
local CheatMode		    = Spring.IsCheatingEnabled
local GetTeamUnits	    = Spring.GetTeamUnits
local GetGroundHeight   = Spring.GetGroundHeight
local GetUnitDefID      = Spring.GetUnitDefID

local CreateUnit	    = Spring.CreateUnit
local SetUnitRulesParam = Spring.SetUnitRulesParam

local function spawnableUD(ud)
    if ud.customParams and ud.customParams.child then
        return false
    end

    return true
end

local commands = {
	spawn = { 
		help = 'spawn units of a particular category',
		handler = function (cmd, line, wordlist, playerID, teamID)
			local ROW_LENGTH = 10
			local ROW_INCREMENT = 50

			local xStart = table.remove(wordlist, 1)
            local zStart = table.remove(wordlist, 1)

			local row = 1
			local counter = 0
			for _, categoryToSpawn in ipairs(wordlist) do
				for udid, ud in pairs(UnitDefs) do
					if ud.modCategories[categoryToSpawn] then
						local offset = ROW_INCREMENT * counter
                        local x = xStart + offset
                        local z = zStart + ROW_INCREMENT * row
                        local y = GetGroundHeight(x, z)
                        if spawnableUD(ud) then
                            CreateUnit(ud.name, x, y, z, 's', teamID)
                        end

						counter = counter + 1
						if (counter % ROW_LENGTH) == 0 then
                            counter = 0
							row = row + 1
						end
					end
				end
			end
		end,
	},

	ammo = {
		help = "refill ammo for all this team's units",
		handler = function (cmd, line, wordlist, playerID, teamID)
            local units = GetTeamUnits(teamID)
            for index, unitID in pairs(units) do
                local udid = GetUnitDefID(unitID)
                local ud = UnitDefs[udid]
                if ud.customParams and ud.customParams.maxammo then
                    SetUnitRulesParam(unitID, "ammo", tonumber(ud.customParams.maxammo))
                end
            end
		end
	},
}

local function RegisterCheatHandler(command, handler, helptext)
	-- wrap up the handler and only allow it if cheats are active
	gadgetHandler:AddChatAction(command, function (cmd, line, wordlist, playerID)
		if CheatMode() then
			local _, _, _, teamID = GetPlayerInfo(playerID)
			handler(cmd, line, wordlist, playerID, teamID)
		else
			local message = command .. ' can only be called when cheats are active!'
			Spring.Echo(message)
		end
	end, helptext)
end

function gadget:Initialize()
	for command, details in pairs(commands) do
		RegisterCheatHandler(command, details.handler, help)
	end
end

-- make it reload safe
function gadget:ShutDown()
	for command, _ in pairs(commands) do
		gadgetHandler:RemoveChatAction(command)
	end
end
