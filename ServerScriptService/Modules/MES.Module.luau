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
--ROBLOX Service Calls
local RNS = game:GetService("RunService")

--Imports
local packages = game:GetService("ReplicatedStorage").Packages

local MovementEngine = {}

function MovementEngine.StartSprint(player: Player)
    --if self.Connections[`{player.Name}-STAMINA`] and self.Connections[`{player.Name}-STAMINA`].Connected then return false end
    if player:GetAttribute("Stamina") <= 0 then return MovementEngine.StopSprint(player) end

    if player:GetAttribute("IsResting") == true then
        player:SetAttribute("IsResting", false)
    end

    player:SetAttribute("IsSprinting", true)

    -- Character
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char.Humanoid or char:WaitForChild("Humanoid")
    hum.WalkSpeed = 128

    local conn

    conn = RNS.Stepped:Connect(function(time, deltaTime)
        -- Handle Stamina
        if player:GetAttribute("IsResting") or player:GetAttribute("Stamina") <= 0 then
            conn:Disconnect()
            return MovementEngine.StopSprint(player)
        end

        print(player:GetAttribute("Stamina"))
        player:SetAttribute("Stamina", (player:GetAttribute("Stamina")-2))
        print(player:GetAttribute("Stamina"))
    end)

    return true
end

function MovementEngine.StopSprint(player: Player)
    -- Character
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char.Humanoid or char:WaitForChild("Humanoid")
    hum.WalkSpeed = 16

    player:SetAttribute("IsSprinting", false)
    player:SetAttribute("IsResting", true)

    local conn
    conn = RNS.Stepped:Connect(function(time, deltaTime)
        if player:GetAttribute("Stamina") >= 100 or player:GetAttribute("IsSprinting") then
            if not player:GetAttribute("IsSprinting") then
                player:SetAttribute("Stamina", 100)
            end
            
            return conn:Disconnect()
        end
        player:SetAttribute("Stamina", (player:GetAttribute("Stamina")+1))
        print(player:GetAttribute("Stamina"))
    end)
end

function MovementEngine:Initialise()

end

return MovementEngine