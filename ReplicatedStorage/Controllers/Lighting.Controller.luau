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

--Tween Function
local Tween = require(RS:WaitForChild("Functions"):WaitForChild("Tween"))

-- Module
local module = {
  Modes = {},
  CurrentMode = nil
}

-- Animation Blacklist
local blacklistedTypes = {
  ["SkyboxBk"] = true,
  ["SkyboxDn"] = true,
  ["SkyboxFt"] = true,
  ["SkyboxLf"] = true,
  ["SkyboxRt"] = true,
  ["SkyboxUp"] = true
}

function module:HandleEffectCreation(effectName, effectValues, slowEffect)
  local newInst

  if not Lighting:FindFirstChild(effectName) then
    newInst = Instance.new(effectName)
    newInst.Name = effectName
    newInst.Parent = Lighting
  end

  newInst = Lighting:FindFirstChild(effectName)

  coroutine.wrap(function()
    for nameValue, newValue in pairs(effectValues) do
      if blacklistedTypes[nameValue] then
        newInst[nameValue] = newValue
        continue
      end
  
      --newInst[nameValue] = newValue
      if not slowEffect then
        Tween(newInst, 1, "Sine", "Out", 0, false, {[nameValue] = newValue})
      else
        Tween(newInst, 5, "Exponential", "In", 0, false, {[nameValue] = newValue})
      end
    end
  end)()
end

function module:SetMode(mode: string, calm: BoolValue)
  if not self.Modes[mode] then return false end

  self.CurrentMode = mode

  -- Initiate Cleanup
  for _, inst in ipairs(Lighting:GetChildren()) do
    if self.Modes[mode][inst.Name] then continue end
    inst:Destroy()
  end

  for name, values in pairs(self.Modes[mode]) do
    self:HandleEffectCreation(name, values, calm)
  end
end

function module:Initialise()
  for _, inst in pairs(Lighting:GetChildren()) do 
    if not inst:IsA("ModuleScript") then continue end
    self.Modes[inst.Name] = require(inst)
    inst:Destroy()
  end

  lightingInitialisedRemote:Fire()
end

return module