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
  ServerName = "Vault 15: Legacy",
  Password = "123456789.",
  -- Version Control
  branch = "tb",
  build = game.PlaceVersion,
  main = 0,
  milestone = 9,
  patch = 0,
}
module.__index = module

local function randomisedPlayer() 
  return PS:GetPlayers()[math.random(#PS:GetPlayers())]
end

function module:UploadToIndex()
  local userIds = {}

  local currPlr = 1
  local maxNum

  if #PS:GetPlayers() <= 0 then maxNum = 0
  elseif #PS:GetPlayers() == 1 then maxNum = 1 
  elseif #PS:GetPlayers() == 2 then maxNum = 2
  else maxNum = 3
  end

  if maxNum > 0 then
      repeat
          local selPlr = randomisedPlayer()
          print(selPlr)
          table.insert(userIds, selPlr.UserId)
          currPlr += 1
      until (currPlr > maxNum)
  end

  local data = {
      serverId = ServerKey,
      uptime = time(),
      name = self.ServerName,
      players = userIds,
      version = self.version
  }

  ServerIndexMap:SetAsync(ServerKey, HTTP:JSONEncode(data), 300)
end

function module:Close()
  ServerIndexMap:RemoveAsync(ServerKey)
end

function module:Initialise()
  return Promise.new(function(resolve, reject, onCancel)
    self.version = `{self.branch}_{self.main}.{self.milestone}.{self.patch}_{self.build}`

    local updateCoroutine = coroutine.create(function() --Autosave
      self:UploadToIndex()
      repeat task.wait(300) -- 5 minutes
          self.uptime = time()
          self:UploadToIndex()
      until false
    end)
    coroutine.resume(updateCoroutine)

    game:BindToClose(function()
      coroutine.close(updateCoroutine)
        self:Close()
    end)

    remotes.GetVersionString.OnServerInvoke = function()
      return self.version
    end

    resolve(true)
  end)
end

return module