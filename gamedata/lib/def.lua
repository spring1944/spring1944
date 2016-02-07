local class = require 'middleclass'

local Def = class('Def')

function Def:initialize(registry, name)
	self.registry = function ()
		return registry
	end
	self.name = name
	self.changelog = {}
end

-- this could be performed during :add, but it seemed best to keep it off the
-- direct path (since :add gets called quite a lot, and on every game load)
function Def:getOverwrites(key)
	local log = self.changelog[key]
	local overwrites = {}
	for i, source in ipairs(log.source) do
		local originalSource = source:getKeySource(key)
		-- collapse diamond to single source, e.g. when A -> B, C -> D.
		-- D should show the value as coming from A just once, rather than
		-- from A followed by A.
		local prev = overwrites[#overwrites]
		if originalSource ~= prev then
			table.insert(overwrites, originalSource)
		end
	end
	return overwrites
end

function Def:getKeySource(key)
	local log = self.changelog[key]
	if log == nil then return nil end
	local last = log.source[#log.source]
	if last == self then
		return self
	else
		return last:getKeySource(key)
	end
end

function Def:getOwnKeys()
	local ownKeys = {}
	for key, log in pairs(self.changelog) do
		local value = log.value
		local source = log.source[#log.source]

		if type(value) == 'table' then
			local subtable = self:registry():get(self.name .. ' ' .. key)
			ownKeys[key] = subtable:getOwnKeys()
		else
			if source == self then
				ownKeys[key] = value
			end
		end
	end
	return ownKeys
end

function Def:get(key)
	local log = self.changelog[key]
	if log then
		return log.value
	else
		error(self.name .. ' does not have key ' .. key)
	end
end

function Def:Render()
	local result = {}
	for key, log in pairs(self.changelog) do
		local value = log.value
		if type(value) == 'table' then
			result[key] = value:Render()
		else
			result[key] = value
		end
	end
	return result
end

function Def:add(key, value, source)
	if type(value) == 'table' then
		local subname = self.name .. ' ' .. key

		local existing = (self.changelog[key] or {}).value
		local subtable = existing or self.registry():register(subname)

		if self == source then
			value = subtable:Attrs(value)
		else
			value = subtable:Extends(value.name)
		end
	end

	if self.changelog[key] == nil then
		self.changelog[key] = {
			value = value,
			source = { source },
		}
	else
		-- WARNING, overwriting!
		local existingSource = self.changelog[key].source[1]
		self.changelog[key].value = value
		table.insert(self.changelog[key].source, source)
	end
end

-- deliberately only single inheritance. fail if there's been any mixing.
function Def:Extends (parentName)
	local parent = self.registry():get(parentName)
	if not parent then
		error(parentName .. " cannot be used as a base class, because it has not yet been defined!")
		return
	end

	for key, log in pairs(parent.changelog) do
		self:add(key, log.value, parent)
	end

	return self
end

function Def:Attrs (attrs)
	for key, value in pairs(attrs) do
		self:add(key, value, self)
	end
	return self
end

return Def
