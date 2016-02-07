local class = require 'middleclass'

local Registry = class('Registry')
local Def = require 'def'

function Registry:initialize()
	self.db = {
		all = {},
		abstract = {},
		impls = {}
	}
end

function Registry:_newEntry(name, abstract)
	local existingImpl = self.db.impls[name]
	local existingAbstract = self.db.abstract[name]

	if existingImpl then
		error(name .. " is already a registered implementation!")
		return nil
	elseif existingAbstract then
		error(name .. " is already a registered abstract class!")
		return nil
	end

	local newClass = Def:new(self, name)
	if abstract then
		self.db.abstract[name] = 1
	else
		self.db.impls[name] = 1
	end

	self.db.all[name] = newClass
	return newClass
end

function Registry:register(name)
	return self:_newEntry(name)
end

function Registry:registerAbstract(name)
	return self:_newEntry(name, true)
end

function Registry:get(name)
	return self.db.all[name]
end

function Registry:type(name)
	if self.db.abstract[name] then return 'abstract' end
	if self.db.impls[name] then return 'implementation' end
	return 'unregistered'
end

-- TODO: check for loops? findUnusedAbstract gets stuck on the S44 codebase
function Registry:findUsers(baseClassName, keyToCheck)
	local baseClass = self:get(baseClassName)
	if not baseClass then error("no such class: " .. baseClassName) end

	local keysToCheck
	if keyToCheck == nil then
		keysToCheck = baseClass:getOwnKeys()
	else
		keysToCheck = {}
		keysToCheck[keyToCheck] = baseClass:get(keyToCheck)
	end

	-- key = name of key, value = array of classes that source the value from this base class
	local users = {}
	for name, class in pairs(self.db.all) do
		if class ~= baseClass then
			for key, value in pairs(keysToCheck) do
				if class.changelog[key] then
					if type(value) == 'table' then
						local subUsers = self:findUsers(baseClassName .. ' ' .. key)
						local count = 0
						for _ in pairs(subUsers) do count = count + 1 end
						if count > 0 then
							users[key] = subUsers
						end
					else
						local source = class:getKeySource(key)
						if source == baseClass then
							if not users[key] then
								users[key] = {
									value = keysToCheck[key],
									consumers = { class.name }
								}
							else
								table.insert(users[key].consumers, class.name)
							end
						end
					end
				end
			end
		end
	end
	return users
end

function Registry:detectUnusedAbstractClasses()
	local unused = {}
	for className in pairs(self.db.abstract) do
		local users = self:findUsers(className)
		local tagsInUse = 0
		for _ in pairs(users) do tagsInUse = tagsInUse + 1 end
		if tagsInUse == 0 then
			table.insert(unused, className)
		end
	end
	return unused
end

return Registry
