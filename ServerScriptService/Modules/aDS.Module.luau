--[[
     █████  ██      ██     ██ ██  ██████  ███    ██ 
    ██   ██ ██      ██     ██ ██ ██    ██ ████   ██ 
    ███████ ██      ██  █  ██ ██ ██    ██ ██ ██  ██ 
    ██   ██ ██      ██ ███ ██ ██ ██    ██ ██  ██ ██ 
    ██   ██ ███████  ███ ███  ██  ██████  ██   ████ 

                    ALWION STUDIOS  
                  ALL RIGHTS RESERVED
                        ©️ 2024
]]

-- ROBLOX API
local ServerStorage = game:GetService("ServerStorage")
local PS = game:GetService("Players")

-- Imports
local aDS = require(ServerStorage:WaitForChild("aDS"):WaitForChild("Core"))

-- Other Variables
local dataValues = {
  ["number"] = "NumberValue",
  ["string"] = "StringValue"
}

-- Module
local module = {}

function module:OnJoin(player: Player)
  print(`[aDS] Creating a session for {player.Name}`)

  -- Get the Default Schema for Players
  local _, schema = aDS:GetSchema("User"):await()
  
  -- Create a Session for the User
  local status, session = aDS:CreateSession(player.UserId, schema):await()

  -- Kick the player if datastore initialisation is unsuccessful
  if not status or not session then
    player:Kick(`[aDS] Failed to initialise a datastore session.`)
  end

  -- Create a Folder in the Player's Instance
  local newFolder = Instance.new("Folder")
  newFolder.Name = "DataValues"
  newFolder.Parent = player

  for name, value in session["Structure"] do 
      if typeof(value) == "table" then continue end
      if not dataValues[typeof(value)] then continue end

      local newValue = Instance.new(dataValues[typeof(value)])
      newValue.Name = name
      newValue.Value = value
      newValue.Parent = newFolder
  end
end

function module:HandleKeyChange(player: Player, key, value)
  -- Get the Player's DataValue Folder
  local plrValues = player:WaitForChild("DataValues")
  if not plrValues or not plrValues:FindFirstChild(key) then return false end
  
  -- Get the Associated Key
  local dataKey = plrValues:WaitForChild(key)
  if not dataKey then return false end

  dataKey.Value = value
end

function module:Initialise()
  -- Handle Key Changes
  aDS.Events.KeyChanged:Connect(function(playerId, key, newValue)
    local player = PS:GetPlayerByUserId(playerId)
    if not player then return false end

    self:HandleKeyChange(player, key, newValue)
  end)
end

return module