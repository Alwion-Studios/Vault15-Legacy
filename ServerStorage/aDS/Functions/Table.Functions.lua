local RS = game:GetService("ReplicatedStorage")
local Promise = require(RS.Packages.Promise)

local TableFunctions = {}

--Promise Type
export type Promise = typeof(Promise.new(function() end))

--[[local function FindAndEdit(data, key, value) 
    local toSearch = table.clone(data)
    local tblToReturn

    local function scan(tbl)
        for name, scannedValue in tbl do
            if name == key then
                print(tbl[name])
            end
            if typeof(scannedValue) == 'table' then
                scan(scannedValue)
            end
        end
    end
    scan(toSearch)
    
    return tblToReturn
end]]

local function ModifyKey(data, path, key, value)
    local toReturn = table.clone(data)
    local currentLayer = 1

    local function scan(tbl)
        if not path or #path <= 0 then 
            if not tbl[key] then return false end
            tbl[key] = value
        else
            if #path == currentLayer then
                print(true)
                if not tbl[key] then return false end
                tbl[key] = value
            elseif tbl[path[currentLayer]] then
                currentLayer += 1
                return scan(tbl[path[currentLayer]])
            end
        end
    end

    scan(toReturn)

    return toReturn
end

--[[ CREDIT TO SLEITNICK AND HIS TableUtil Module 
    Review @ https://github.com/Sleitnick/RbxUtil/]]
local function DeepCopy(t)
    local copy = table.clone(t)
    for name, value in copy do 
        if type(value) == "table" then copy[name] = DeepCopy(value) end
    end
    return copy
end

--[[ CREDIT TO SLEITNICK AND HIS TableUtil Module 
    Review @ https://github.com/Sleitnick/RbxUtil/]]
local function Sync(data, template) 
    local toReturn = table.clone(data)

    for name, value in template do
		local source = data[name]
		if source == nil then
			if type(value) == "table" then
				toReturn[name] = DeepCopy(value)
			else
				toReturn[name] = value
			end
		elseif type(source) == "table" then
			if type(value) == "table" then
				toReturn[name] = Sync(source, value)
			else
				toReturn[name] = DeepCopy(source)
			end
		end
	end

    return toReturn
end

local function Find(data, key)
    local toSearch = table.clone(data)
    local toReturn

    local function scan(tbl)
        for name, value in tbl do
            if name == key then
                toReturn = value
                return true
            end
            if typeof(value) == 'table' then
                scan(value)
            end
        end
    end
    scan(toSearch)

    return toReturn
end

TableFunctions.DeepCopy = DeepCopy
TableFunctions.Sync = Sync
TableFunctions.ModifyKey = ModifyKey
TableFunctions.Find = Find

return TableFunctions