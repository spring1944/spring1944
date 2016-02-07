--[[
This is for setting up any bits that should be in the OO def environment. 

]]--

local registry = Registry:new()

function Def (name)
	return registry:register(name)
end

function Unit (name)
	return registry:register(name)
end

function Weapon (name)
	return registry:register(name)
end

function AbstractDef (name)
	return registry:registerAbstract(name)
end

function AbstractUnit (name)
	return registry:registerAbstract(name)
end

function AbstractWeapon (name)
	return registry:registerAbstract(name)
end

local sideData
if Spring then
	sideData = VFS.Include("gamedata/sidedata.lua", VFS.ZIP)
else
	package.path = './gamedata/?.lua;' .. package.path
	sideData = require 'sidedata'
end


Sides = {}
for sideNum, data in pairs(sideData) do
	if sideNum > 1 then -- ignore Random/GM
		Sides[sideNum] = data.name
	end
end

return { registry = registry }
