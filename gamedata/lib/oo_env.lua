--[[
This is for setting up any bits that should be in the OO def environment. 

]]--

local sideData
if VFS then
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

