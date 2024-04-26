--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

]]

--Imports
local PS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local formattingFunctions = require(RS.Formatting.Number)

--Overhead UI
local overheadUI = RS:WaitForChild("GuiTemplates"):WaitForChild("Overhead")

local OverheadController = {}

function OverheadController:AssignToPlayer(plr)
    if not plr then return false end
    local char = plr.Character or plr.CharacterAdded:Wait()
    if not char then return false end

    local clonedOverhead: BillboardGui = overheadUI:Clone()
    char:WaitForChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    clonedOverhead:WaitForChild("Hold"):WaitForChild("Names").DisplayName.Text = plr.DisplayName
    clonedOverhead:WaitForChild("Hold"):WaitForChild("Names").Username.Text = plr.Name
    clonedOverhead:WaitForChild("Hold").BackgroundColor3 = plr.Team.TeamColor.Color
    plr:GetPropertyChangedSignal("Team"):Connect(function()
        clonedOverhead:WaitForChild("Hold").BackgroundColor3 = plr.Team.TeamColor.Color
    end)

    clonedOverhead.Parent = char:WaitForChild("Head")
    clonedOverhead.Adornee = char.Head
end

function OverheadController:Initialise()
    --Get all Players and add the Overhead UI
    for _, plr in pairs(PS:GetChildren()) do
        --if plr == PS.LocalPlayer then print(false) continue end
        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid").Died:Connect(function()
                self:AssignToPlayer(plr)
            end)
            self:AssignToPlayer(plr)
        end)
        
        self:AssignToPlayer(plr)
    end

    --After Player has Joined
    PS.PlayerAdded:Connect(function(newPlr)
        newPlr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid").Died:Connect(function()
                self:AssignToPlayer(newPlr)
            end)
            self:AssignToPlayer(newPlr)
        end)
        --if newPlr == PS.LocalPlayer then return false end 
        self:AssignToPlayer(newPlr)
    end)
end

return OverheadController