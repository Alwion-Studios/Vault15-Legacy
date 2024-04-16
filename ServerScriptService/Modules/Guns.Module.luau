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
local _SS = game:GetService("ServerScriptService")
local _CS = game:GetService("CollectionService")
local _RS = game:GetService("ReplicatedStorage")
local _SSS = game:GetService("ServerStorage")

--Imports
local packages = _RS.Packages
local Remotes = _RS.Remotes

-- Imports
local aDS = require(_SSS:WaitForChild("aDS"):WaitForChild("Core"))

--Door Object
local door = require(_SS:WaitForChild("Objects"):WaitForChild("Door.Object"))

local module = {
    Doors = {};
}
module.__index = module

function module.FireWeapon(player: Player, tool: tool, Pos)
    if not player.Character then
		return
	end
	if not tool then
		return
	end
	if not Pos then
		return
	end
	if tool.Parent ~= player.Character then
		return
	end
	if not tool:FindFirstChild("GunSettings") then
		return
	end
	local Settings = require(tool:FindFirstChild("GunSettings"))
	local Clip = tool.Clip
	if Clip.Value < 1 then
		return
	end

	local _, session = aDS:GetSession(player.UserId, "Profile"):await()

	if not session then return false end

	if session["Structure"][Settings.BulletItem] < 1 then
		print("no ammo", session["Structure"][Settings.BulletItem], Settings.BulletItem)
		return
	end
	
	Clip.Value = Clip.Value - 1
	session["Structure"][Settings.BulletItem] = session["Structure"][Settings.BulletItem] - 1
	player.SaveFile[Settings.BulletItem].Value = session["Structure"][Settings.BulletItem]

	local NewRay = Ray.new(
	    Settings.Barrel.Position,
	    (Pos - Settings.Barrel.Position).unit * 500
	)
	local Ignore = tool.Parent	 
	local Hit, Position, Normal = game.Workspace:FindPartOnRay(NewRay, Ignore)
	
	-- Create Trail
	for Index, NewPlayer in next, game.Players:GetPlayers() do
		if NewPlayer ~= player then
			Remotes.ShotFired:FireClient(NewPlayer, tool, Settings.Barrel.Position, Position)
		end
	end
	
	if Hit then
		local HitCharacter = Hit.Parent
		local HitPlayer = game.Players:GetPlayerFromCharacter(HitCharacter)
		
		if HitPlayer == nil then
			HitCharacter = Hit.Parent.Parent
			HitPlayer = game.Players:GetPlayerFromCharacter(HitCharacter)
		end
		
		if Hit.Parent.Name == "Riot Shield" then
			HitCharacter = nil
			HitPlayer = nil
		end
		
		if Hit.Name == "Armor" or Hit.Parent.Name == "Armor" then
			HitCharacter = nil
			HitPlayer = nil
		end
		
		if Hit.Name == "Head" and Hit.Parent:FindFirstChild("Helmet") then
			HitCharacter = nil
			HitPlayer = nil
		end
		
		if not (HitPlayer == nil or HitPlayer == player or HitPlayer:GetAttribute("PVP") ~= true) then
            local HitHumanoid = HitCharacter:FindFirstChild("Humanoid")
            if HitHumanoid and HitHumanoid.Health > 0 then
                Remotes.HitMarker:FireClient(player)
                
                local PreviousTag = HitHumanoid:FindFirstChild("Tag")
                if PreviousTag then
                    PreviousTag:Destroy()
                end
                
                local NewTag = Instance.new("StringValue")
                NewTag.Parent = HitHumanoid
                NewTag.Value = player.Name
                NewTag.Name = "Tag"
                
                if Hit.Name == "Head" then
                    HitHumanoid:TakeDamage(Settings.BulletDamage * Settings.HeadShotMultiplier)
                else
                    HitHumanoid:TakeDamage(Settings.BulletDamage)
                end
                Remotes.HitMarker:FireClient(player)
                if HitHumanoid.Health <= 0 then
                    game.ServerStorage.Kill:Fire(player, HitPlayer)
                end
            end
		end
	end
end

function module.ReloadWeapon(player: Player, tool: tool)
    if not player.Character then
		return
	end
	if not tool then
		return
	end
	if tool.Parent ~= player.Character then
		return
	end
	if not tool:FindFirstChild("GunSettings") then
		return
	end
	local Settings = require(tool:FindFirstChild("GunSettings"))
	local Clip = tool.Clip
	if Clip.Value >= Settings.MaxClip then
		return
	end

	local _, session = aDS:GetSession(player.UserId, "Profile"):await()
	if not session then return false end

	if not tool.Reloading.Value and tool.Clip.Value < session["Structure"][Settings.BulletItem] and tool.Clip.Value < Settings.MaxClip then
		tool.Reloading.Value = true
		tool.Handle.ReloadSound:Play()
		while tool.Clip.Value < session["Structure"][Settings.BulletItem] and tool.Clip.Value < Settings.MaxClip do
			wait(0.1)
			tool.Clip.Value = tool.Clip.Value + 1
		end
		wait(0.5)
		tool.Reloading.Value = false
	end
end

function module:Initialise()
    Remotes.FireWeapon.OnServerEvent:Connect(self.FireWeapon)
    Remotes.ReloadWeapon.OnServerEvent:Connect(self.ReloadWeapon)
end

return module