-- Doors Massless Speed Bypass

-- I use this for the GUI in this repository, but you may freely use it for your own

--[[ Simple usage, loadstring this and make it a variable, the variable will be a table containing the following:
    SpeedBypass:Start() - Starts the massless speed bypass.
    SpeedBypass:Stop() - Pauses the speed bypass.
    SpeedBypass:SetDelay(delay: number) - Sets the speed bypass's delay accordingly. Adjusts SpeedBypass.MasslessDelay so you can do this manually as well.
]]

--[[ Note:
    This bypass requires a clone of collision to be present in the player's character.
    If your GUI makes one already, make sure it's under the name CollisionClone or CollisionNew.
    If there is not a CollisionClone or CollisionNew detected in the character, one will be made.
]]

if not game.IsLoaded then
    game.Loaded:Wait()
end

local cloneref = (cloneref or clonereference) or function(a: any) return a end -- shitsploit support once again
local Players: Players = cloneref(game:GetService("Players"))
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Collision: UnionOperation = Character:WaitForChild("Collision", math.huge)
local CollisionClone: UnionOperation = (Character:FindFirstChild("CollisionClone") or Character:FindFirstChild("CollisionNew")) or Collision:Clone()
if CollisionClone.Name ~= "CollisionNew" then
    CollisionClone.Name = "CollisionClone"
end
local SpeedBypassUtil = {
    MasslessDelay = 0.23,
    IsBypassing = false,
}

function SpeedBypassUtil:Start()
    if self.IsBypassing or not Collision or not CollisionClone then
        return
    end

    self.IsBypassing = true

    task.spawn(function()
        while Collision and CollisionClone and Character and Character:FindFirstChild("HumanoidRootPart") and self.IsBypassing do
            if HumanoidRootPart.Anchored then
                CollisionClone.Massless = true -- lagback fix, sort of. instead of repeatedly freezing you, leaving you prone to entities, it just instantly teleports you back.
                
                repeat
                    task.wait()
                until not HumanoidRootPart.Anchored
            else
                CollisionClone.Massless = not CollisionClone.Massless
            end

            task.wait(self.MasslessDelay)
        end
    end)
end

function SpeedBypassUtil:Stop()
    self.IsBypassing = false

    if CollisionClone then
        CollisionClone.Massless = false
    end
end

function SpeedBypassUtil:SetDelay(delay: number)
    if delay ~= nil and typeof(delay) == "number" then
        self.MasslessDelay = delay
    else
        self.MasslessDelay = 0.23
    end
end


return SpeedBypassUtil
