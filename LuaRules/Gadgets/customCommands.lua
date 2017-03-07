local moduleInfo = {
	name = "customCommandsGadget",
	desc = "Gadget connecting custom commands module allowing players to define their own commands",
	author = "PepeAmpere",
	date = "2017-01-24",
	license = "notAlicense",
	layer = 0,
	enabled = true -- loaded by default?
}

function gadget:GetInfo()
	return moduleInfo
end

-- get madatory module operators
VFS.Include("LuaRules/modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")
attach.Module(modules, "customCommands")

-- UNSYNCED
if (not gadgetHandler:IsSyncedCode()) then
	function gadget:Initialize()
		gadgetHandler:AddSyncAction('CustomCommandUpdate', receiveCustomMessage.CustomCommandUpdate)
		gadgetHandler:AddSyncAction('CustomCommandRegistered', receiveCustomMessage.CustomCommandRegistered)
	end
	
	return
end

-- SYNCED

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	customCommands.UnitIncomming(unitID, unitDefID, unitTeam, builderID)
end

function gadget:RecvLuaMsg(msg, playerID)
	message.Receive(msg, playerID) -- using messageReceiver data structure
end

