--!nonstrict

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

--Imports
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players")
local MS = game:GetService("MaterialService")

-- Remotes
local remotes = RS.Remotes
local lightingInitialisedRemote = remotes.LightingInitialised

-- Lighting
local Lighting = game:GetService("Lighting")

-- Module
local module = {
  Modes = {},
  CurrentMode = nil
}

function module:SetMode(mode: string)
  if not self.Modes[mode] then return false end

  for _, inst in pairs(Lighting:GetChildren()) do 
    if inst:IsA("Folder") then continue end
    inst.Parent = self.Modes[self.CurrentMode]
  end

  self.CurrentMode = mode

  for _, inst in pairs(self.Modes[mode]:GetChildren()) do
    inst.Parent = Lighting
  end
end

function module:Initialise()
  for _, inst in pairs(Lighting:GetChildren()) do 
    if not inst:IsA("Folder") then continue end
    self.Modes[inst.Name] = inst
  end
  self:SetMode("Future")
  lightingInitialisedRemote:Fire()
end

return module