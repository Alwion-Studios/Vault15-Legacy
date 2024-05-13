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
local PS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local MSS = game:GetService("MemoryStoreService")
local HTTP = game:GetService("HttpService")

-- Packages
local Packages = RS.Packages
local Promise = require(Packages.Promise)

-- Remotes
local remotes = RS.Remotes

-- Variabbles
local ServerKey

if game:GetService("RunService"):IsStudio() then ServerKey = "TEST" else ServerKey = tostring(game.JobId) end

--Memory Stores
local ServerIndexMap = MSS:GetSortedMap("ServerIndex")

-- Module
local module = {
  -- Version Control
  branch = "tb",
  build = game.PlaceVersion,
  main = 1,
  milestone = 0,
  patch = 0,
  codename="whistler"
}
module.__index = module

function module:Initialise()
  self.version = `{self.branch}_{self.main}.{self.milestone}.{self.patch}_{self.build}_{self.codename}`
  remotes.GetVersionString.OnServerInvoke = function()
    return self.version
  end
end

return module