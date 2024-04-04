--Operator Variables
local isStudio = false
--Types
export type settings = {
    assumeDeadSessionLock: number,
    autoSaveInteral: number
}

export type Schema = {
    Name: String,
    Settings: settings,
    DataStore: DataStore,
    Structure: table,
    Options: table,
}

--Middleware Types
export type Middleware = {
    Inbound: {MiddleWareFn}?,
    Outbound: {MiddleWareFn}?
}

export type MFunction = (player: Player, args: {any}) -> (boolean, ...any)

-- Variable Types to DataValues
local dataTypes = {
    ["number"] = "NumberValue",
    ["string"] = "StringValue",
    ["boolean"] = "BoolValue"
}

local datastoreNamePrefix = {
    [true] = "DEV",
    [false] = "PROD"
}

-- Imports
local DS = game:GetService("DataStoreService")
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players")
local TableFunctions = require(script.Parent.Parent.Functions["Table.Functions"])
local Core = require(script.Parent.Parent.Core)
local RunService = game:GetService("RunService")
local Promise = require(RS.Packages.Promise)

if RunService:IsStudio() then isStudio = true end

--Schema Object with Defaults
local Schema = {}
Schema.__index = Schema

--[[
    Returns: SELF

Gets the default schema template and adds the user's customisations
    !!! Must be created before calling Core initialisation !!!

    -- Parameters:
    name: String -- Declares the name of the schema. !!! MUST BE UNIQUE !!!
    structure: Table 
    options: Table

    -- Example:
    local MySchema = Schema.Create(
        "My Schema", ! Name !
        {["SchemaName"]=schemaValue}, ! Structure !
        {["CustomSetting"]={true, "OtherInfo"} ! Options !
    })
]]

function Schema.Create(name: String, options: table): Schema
    local self = setmetatable({}, Schema)
    
    print(`{name}-{datastoreNamePrefix[isStudio]}`)

    self.Name = name
    self.Value = 0
    self.DataStore = DS:GetOrderedDataStore(`{name}-{datastoreNamePrefix[isStudio]}`)
    self.Options = {
        Settings = {
            assumeDeadSessionLock = 30 * 60,
            autoSaveInteral = 1 * 60,
        },

        --[[
        FOR FUTURE USE -MK
        Middleware = {
            Inbound = {},
            Outbound = {}
        }]]
    }

    if options then
        self.Options.Settings["Custom"] = options
    end

    return self
end

--[[
    Returns: PROMISE (table)

    Gets the user's data and loads into memory for future use

    !!! To prevent data loss, data can only be serialised on one server. 
    Attempts to serialise on multiple may lead to issues. !!!

    -- Parameters
    None. Handled Automatically by aDS.
]]

function Schema:Serialise()
    if not self.Id then return false end

    return Promise.new(function(resolve, reject, onCancel) 
        local result = self.DataStore:GetAsync(self.Id)
        local toReturn

        if not result then
            toReturn = 0
        else
            toReturn = result
        end

        resolve(toReturn)

        onCancel(function() 
            resolve(false)
        end)
    end)
end

--[[
    Returns: PROMISE (table)

    Gets the user's data and loads into memory for future use

    !!! To prevent data loss, data can only be serialised on one server. 
    Attempts to serialise on multiple may lead to issues. !!!

    -- Parameters
    None. Handled Automatically by aDS.
]]

function Schema:CheckIfDatastoreExists(id)
    if not id then return false end

    return Promise.new(function(resolve, reject, onCancel)
        local result = self.DataStore:GetAsync(id)

        if result then 
            resolve(true)
        end
        
        resolve(false)
    end)
end

--[[
    Returns: PROMISE (true)

    This function allows you to set or insert custom keys based on its path in the data structure

    -- Parameters
    path: table ! Defines the path to find or insert a key ! - !!! Does not work if you use keys that do not exist. Patch coming soon !!!
    key: string ! Name of key to set !
    value: any ! Value to set key to !

    -- Example:
    self:SetKey("Value")
]]

function Schema:Set(value)
    return Promise.new(function(resolve, reject, onCancel)
        self["Value"] = value
        Core.Events.KeyChanged:Fire(self.Id, value)
        return resolve(true)
    end)
end

--[[
    Returns: PROMISE (key, value)

    This function allows you to get a key and its value based on its path in the data structure

    -- Parameters
    path: table ! Defines the path to find the key ! - !!! Does not work if you use keys that do not exist. Patch coming soon !!!
    key: string ! Name of key to find !

    -- Example:
    self:GetKey({"Path", "to", "key"}, "Key")
]]

function Schema:Get()
    return Promise.new(function(resolve, reject, onCancel) 
        return resolve(self.Value)
    end)
end

--[[
    Returns: PROMISE

    This function allows you to completely delete a session datastore. 

    -- Calls
    CloseSession(id, self.Name)

    -- Parameters
    id: any ! ID of the key that the data is stored in !

    -- Example:
    self:Delete(1)
]]

function Schema:Delete(id)
    if not self.Id or not id then return false end

    warn(`[{self.Name} - {Core.Product}] Deleting Datastore with ID {id or self.Id}`)

    return Promise.new(function(resolve, reject, onCancel) 
        self.DataStore:RemoveAsync(id or self.Id)
        --self:RefreshCache()

        if self.Id then
            warn(`[{self.Name} - {Core.Product}] Closing Session`)
            Core:CloseSession(id or self.Id, self.Name)
        end
        
        onCancel(function() 
            resolve(false)
        end)
    end)
end

--[[
    Returns: PROMISE

    This function allows you to save the current session

    -- Example:
    self:Start(1)
]]

function Schema:Save()
    return Promise.new(function(resolve, reject, onCancel) 
        if not self.Id then reject(false) end
        if isStudio then warn(`Running in Studio! Ignoring save request!`) resolve(true) end

        local success, err = pcall(function()
            self.DataStore:UpdateAsync(self.Id, function(oldData)
                return self["Value"]
            end)
        end)

        if not success then
            reject(err)
        else
            resolve(true)
        end

        onCancel(function()
            resolve(false)
        end)
    end)
end

--[[
    Returns: PROMISE

    This function allows you to start a schema session

    -- Calls
    Serialise()
    Save()

    -- Parameters
    id: any ! ID of the data structure in the datastore !

    -- Example:
    self:Start(1)
]]

function Schema:Start(id, saveOnLoad)
    if self.Id then warn(`[{self.Name} - {Core.Product}] Session is currently active`) return false end

    return Promise.new(function(resolve, reject, onCancel)
        local toUse = table.clone(self)
        toUse.Id = id

        local _, data = toUse:Serialise():await()
        toUse["Value"] = data

        return resolve(toUse)
    end)
end

--[[
    Returns: PROMISE

    This function allows you to start a schema session

    -- Calls
    Save()

    -- Parameters
    refuseSave: boolean ! Unused at the moment !

    -- Example:
    self:Close(false)
]]

function Schema:Close(refuseSave)
    return Promise.new(function(resolve, reject, onCancel) 
        if refuseSave then reject(false) end
        Core.Events.SessionClosed:Fire(self.Id) --Fire the SessionClosed Signal
        return resolve(true)
    end)
end

return Schema