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

-- Imports
local aDS = require(ServerStorage:WaitForChild("aDS"):WaitForChild("Core"))

-- Other Variables
local dataValues = {
  ["number"] = "NumberValue",
  ["string"] = "StringValue"
}

-- Module
local module = {}

function module.OnJoin(player: Player)
  print(`[aDS] Creating a session for {player.Name}`)

  -- Get the Default Schema for Players
  local _, schema = aDS:GetSchema("UserData"):await()
  
  -- Create a Session for the User
  local status, session = aDS:CreateSession(player.UserId, schema):await()

  -- Kick the player if datastore initialisation is unsuccessful
  if not status or not session then 
    player:Kick(`[aDS] Failed to initialise a datastore session.`)
  end
end


function module.Initialise()

end

return module