

-- \ To check if the script was already loaded \ -
if getgenv().Loaded or getgenv().Loading then
    print("silly v2: Script was already ran once!")
    return;
end

getgenv().Loading = true

print("silly v2: Loading...")
-- \ Loading Wait \ --
repeat task.wait() until game:IsLoaded() and cloneref(game:GetService("Players")).LocalPlayer:FindFirstChild("LoadingUI", true).Enabled == false

-- \ Library \ --
local repo = "https://raw.githubusercontent.com/deividcomsono/LinoriaLib/refs/heads/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau"))()
local FlyUtility = loadstring(game:HttpGet("https://raw.githubusercontent.com/Divinedfl/gui/refs/heads/main/Fly.luau"))()


getgenv()._forceunload = function()
    task.spawn(Library.Unload)
end

FlyUtility.ShouldPlatformStand = true

-- \ Variables, tables... \ --
local Players: Players = cloneref(game:GetService("Players"))
local Player = Players.LocalPlayer
local Character: Model = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart: Part = Players.LocalPlayer.Character.PrimaryPart
local Humanoid: Humanoid = Players.LocalPlayer.Character.Humanoid
local Collision: UnionOperation = Players.LocalPlayer.Character:WaitForChild("Collision")
local CollisionClone: UnionOperation = Players.LocalPlayer.Character:FindFirstChild("CollisionNew") or Players.LocalPlayer.Character:FindFirstChild("Collision"):Clone()
local RootProperties: PhysicalProperties = Players.LocalPlayer.Character.PrimaryPart.CustomPhysicalProperties

CollisionClone.Parent = Collision.Parent
CollisionClone.Name = "CollisionNew"
CollisionClone.CanCollide = false



local ReplicatedStorage: ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local EntityModules = ReplicatedStorage.ClientModules.EntityModules
local Glitch = EntityModules.Glitch
local Void = EntityModules.Void
local Random: Random =  Random.new()
local charactertable = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
local Shade = EntityModules.Shade
local gameData = ReplicatedStorage.GameData
local Floor = gameData.Floor.Value
local Parts = {}
local Groupboxes = {}
local Supported = {}
local UNCPrintMessages = {}
local Bridges = {}
local ToExclude = {
    "Elevator1",
    "MinesFinale"
}
local IsFloor = {
    Fools = Floor == "Fools",
    Hotel = Floor == "Hotel",
    Mines = Floor == "Mines",
    Retro = Floor == "Retro",
    Backdoor = Floor == "Backdoor",
    Rooms = Floor == "Rooms"
}
local CurrentRoom = tostring(Player:GetAttribute("CurrentRoom"))

-- \ Self-explanatory \ --
if workspace.CurrentRooms[CurrentRoom] == nil then
    CurrentRoom = tostring(gameData.LatestRoom.Value)
end
local CurrentRooms: Folder = workspace.CurrentRooms
local CurrentRoomModel: Model = CurrentRooms[CurrentRoom]
local OldFogStart = game:GetService("Lighting").FogStart 
local OldFogEnd = game:GetService("Lighting").FogEnd 
local NextRoom = tostring(Player:GetAttribute("CurrentRoom") + 1)
local NextRoomModel: Model = CurrentRooms:FindFirstChild(NextRoom)
local Objectives = {
    ["LiveHintBook"] = {ESPName = "Book"},
    ["LiveBreakerPolePickup"] = {ESPName = "Breaker"},
    ["FuseObtain"] = {ESPName = "Fuse"},
    ["MinesAnchor"] = {ESPName = "Anchor"},
    ["WaterPump"] = {ESPName = "Valve"},
    ["MinesGateButton"] = {ESPName = "Gate Button"},
    ["MinesGenerator"] = {ESPName = "Generator"},
    ["KeyObtain"] = {ESPName = "Key"},
    ["TimerLever"] = {ESPName = "Time Lever"},
    ["LeverForGate"] = {ESPName = "Gate Lever"},
    ["ElectricalKeyObtain"] = {ESPName = "Electrical Key"},
    ["Candy"] = {ESPName = "Candy"}
}
local BodyProperties = {"HeadColor3", "LeftLegColor3", "LeftArmColor3", "RightLegColor3", "RightArmColor3", "TorsoColor3"}
local uis: UserInputService = cloneref(game:GetService("UserInputService"))
local RemotesFolder = ReplicatedStorage:FindFirstChild("RemotesFolder") or ReplicatedStorage:FindFirstChild("EntityInfo");
local PxPromptService: ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
local Entity = game.ReplicatedStorage.Entities
local Hooks = {}
local Connections = {}
local timothyModel = Entity:WaitForChild("Spider")
local modules = Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
local A90 = modules.A90
local Dread = modules.Dread
local MainGame = Player.PlayerGui.MainUI.Initiator.Main_Game
local screechModule = MainGame.RemoteListener.Modules.Screech
local RunService: RunService = cloneref(game:GetService("RunService"))
local IsBypass = false
local TheMinesBypassed = false
local NotifyTable = {
    ["Rush"] = {Notification = "Rush has spawned."},
    ["Ambush"] = {Notification = "Ambush has spawned."},
    ["Jeff The Killer"] = {Notification = "Jeff The Killer has spawned."},
    ["Eyes"] = {Notification = "Eyes has spawned."},
    ["A-60"] = {Notification = "A-60 has spawned."},
    ["A-120"] = { Notification = "A-120 has spawned."},
    ["Blitz"] = {Notification = "Blitz has spawned"},
    ["Lookman"] = {Notification = "Lookman has spawned."},
    ["Gloombat Swarm"] = {Notification = "Gloombats have spawned."}
}


local ESPTable = {
    Entity = {},
    SideEntity = {},
    Door = {},
    Item = {},
    DroppedItem = {},
    Player = {},
    Gold = {},
    Chest = {},
    HidingSpot = {},
    Objective = {},
    GuidingLight = {},
    Ladder = {}
}

local Functions = {}
local Camera = workspace.CurrentCamera


local IsEntity = {
    ["RushMoving"] = {Type = "Entity"},
    ["AmbushMoving"] = {Type = "Entity"},
    ["FigureRagdoll"] = {Type = "SideEntity"},
    ["FigureRig"] = {Type = "SideEntity"},
    ["Eyes"] = {Type = "Entity"},
    ["JeffTheKiller"] = {Type = "Entity"},
    ["GiggleCeiling"] = {Type = "SideEntity"},
    ["BackdoorLookman"] = {Type = "Entity"},
    ["BackdoorRush"] = {Type = "Entity"},
    ["GrumbleRig"] = {Type = "SideEntity"}
}
local ShortNameTable = {
    "Moving",
    "Obtain",
    "Rig",
    "Ragdoll",
    "Ceiling",
    "Setup",
    "Live",
    "Hint",
    "Pole",
    "New",
    "ForGate",
    "Backdoor",
    "Peel",
    "Clone",
    "Wall",
    "Pickup"
}
local ShortNameExclusions = {
    ["JeffTheKiller"] = {Shortened = "Jeff"},
    ["GloomPile"] = {Shortened = "Gloom Eggs"},
    ["PickupItem"] = {Shortened = "Library Paper"}
}
local FloorHidingSpot = {
    ["Hotel"] = "Wardrobe",
    ["Retro"] = "Wardrobe",
    ["Fools"] = "Wardrobe",
    ["Rooms"] = "Locker",
    ["Mines"] = "Locker"
}
local AutoInteractPrompts = {
    ["ModulePrompt"] = 7,
    ["ActivateEventPrompt"] = 6,
    ["FusesPrompt"] = 5,
    ["LeverPrompt"] = 4,
    ["LootPrompt"] = 3,
    ["HerbPrompt"] = 2,
    ["UnlockPrompt"] = 1
}
local GamePrompts = {}
local Minecarts = {}
local RaycastParam = RaycastParams.new()
RaycastParam.FilterType = Enum.RaycastFilterType.Exclude

local notificationSound = Instance.new("Sound")

notificationSound.SoundId = "rbxassetid://4590657391"
notificationSound.Parent = cloneref(game:GetService("SoundService"))
notificationSound.Looped = false
notificationSound.Volume = 2
notificationSound.Name = "Notify"

local Light = Instance.new("SpotLight", Character.Head) do
    Light.Range = 60
    Light.Angle = 180
    Light.Enabled = false
    Light.Name = "LightFeature"
    Light.Brightness = 0
end

-- \ Functions \ --
function Functions.PadlockCode(Paper: Tool, PlayerWithTool: Player)
    if Paper and Paper.Parent and Paper:IsA("Tool") and Paper.Name:find("Library") and PlayerWithTool and PlayerWithTool:IsA("Player") then
        local LibraryCode = {}
        for _, v: ImageLabel in pairs(Paper.UI:GetChildren()) do
            if tonumber(v.Name) then
                local InsertValue = {tonumber(v.Name), "_"}

                table.insert(LibraryCode, InsertValue)
            end
        end

        for i, v in ipairs(LibraryCode) do
            for _, x: ImageLabel in pairs(PlayerWithTool.PlayerGui.PermUI.Hints:GetChildren()) do
                if x:IsA("ImageLabel") and Paper.UI:FindFirstChild(tostring(v[1])) and Paper.UI[tostring(v[1])].ImageRectOffset == x.ImageRectOffset then
                    LibraryCode[i] = x.TextLabel.Text
                end
            end
        end

        for i, v in ipairs(LibraryCode) do
            if type(v) ~= "string" then
                LibraryCode[i] = "_"
            end
        end

        return table.concat(LibraryCode)
    end
end

function Functions.GetCrouch()
    return (if Supported["require"] then require(MainGame).crouching else Character:GetAttribute("Crouching"))
end
function Functions.DistanceFromCharacter(point: Instance)
    return (Character:GetPivot().Position - point:GetPivot().Position).Magnitude
end

-- \ Testing support \ --
function TestFeature(name: string, toTest: () -> (), succMessage: string)
    local succ, err = false, nil

    succ, err = pcall(toTest)

    Supported[name] = succ
    UNCPrintMessages[name] = string.format("%s [%s]%s", (if succ then "✅" else "⛔"), name, (if err then (": " .. tostring(err)) else ""))
    return succ
end

TestFeature("require", function()
    require(Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
end)

local CanFirePP = TestFeature("fireproximityprompt", function()
    local prox = Instance.new("ProximityPrompt", Instance.new("Part", workspace))
    local trig = false

    prox.Triggered:Once(function()
        trig = true
    end)
    fireproximityprompt(prox)
    task.wait(0.1)

    prox.Parent:Destroy()

    assert(trig, "Wasn't able to fire prompt")
end)

TestFeature("hookfunction", function()
    local function test()
        return true
    end

    local ref = hookfunction(test, function()
        return false
    end)

    assert(test() == false, "Hooked function should return false")
    assert(ref() == true, "Old function should return true")
    assert(test ~= ref, "Original function should not be the same as the reference to the old one")
end)


TestFeature("firesignal", function()
    local bindable = Instance.new("BindableEvent", workspace)
    local trig = false

    bindable.Event:Once(function(val)
        trig = val
    end)

    firesignal(bindable.Event, true)
    task.wait(0.1)
    bindable:Destroy()

    assert(trig, "Failed to fire signal")
end)

TestFeature("hookmetamethod", function()
    local object = setmetatable({}, { __index = newcclosure(function() return false end), __metatable = "Locked!" })
	local ref = hookmetamethod(object, "__index", function() return true end)
	assert(object.test == true, "Failed to hook a metamethod and change the return value")
	assert(ref() == false, "Did not return the original function")
end)

TestFeature("getnamecallmethod", function()
	local method
    local ref 

    ref = hookmetamethod(game, "__namecall", function(...)
		if not method then
			method = getnamecallmethod()
		end
        return ref(...)
	end)
    game:GetService("HttpService")
    task.wait(0.2)
    assert(method == "GetService", "getnamecallmethod was not capable of returning the correct method.")
end)

TestFeature("firetouchinterest", function()
        
    local part = Instance.new("Part", workspace)

    part.Touched:Connect(function()
        part:Destroy()
    end)

    firetouchinterest(part, HumanoidRootPart, 1)
    task.wait()
    firetouchinterest(part, HumanoidRootPart, 0)
    task.wait(1)

    assert(not part:IsDescendantOf(workspace), "Firetouchinterest didn't work (didn't activate the .Touched event properly).")
end)

for name, result in pairs(Supported) do
    if UNCPrintMessages[name] then
        print(UNCPrintMessages[name])
    end
end

print(string.format("Executor Name: %s", getexecutorname()))

getgenv().SupportTable = Supported
-- \ Fixing \ --
if not CanFirePP then
    print("🛠️ Making a fireproximityprompt()...")
    getgenv().fireproximityprompt = function(prompt: ProximityPrompt, skip: boolean)
        assert(typeof(prompt) == "Instance" and prompt:IsA("ProximityPrompt"), "Argument #1 of fireproximityprompt was not a prompt.")

        local HoldDur = prompt.HoldDuration
        local RequiresLineOfSight = prompt.RequiresLineOfSight

        if skip then
            prompt.HoldDuration = 0
        end

        prompt.RequiresLineOfSight = false

        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration + 0.05)
        prompt:InputHoldEnd()

        prompt.HoldDuration = HoldDur
        prompt.RequiresLineOfSight = RequiresLineOfSight
    end
end

if not Supported["firetouchinterest"] then
    print("🛠️ Making a working firetouchinterest...")
    getgenv().firetouchinterest = firetouchtransmitter or function(inst1: BasePart, inst2: BasePart, shouldtouch: boolean)
        if not inst1:GetAttribute("OGCFrame") then
            inst1:SetAttribute("OGCFrame", inst1.CFrame)
        end

        if shouldtouch then
            inst1.CFrame = inst2.CFrame
        else
            inst1.CFrame = inst1:GetAttribute("OGCFrame")
        end
    end
end

if not isnetworkowner then
    print("🛠️ Making a isnetworkowner() function...")
    getgenv().isnetworkowner = function(part)
        return part.ReceiveAge == 0
    end
end
type ESPArg = {
    Type: string,
    Object: Instance,
    Text: string,
    Color: Color3,
    IsEntity: boolean | nil,
    TextModel: Instance | nil,
    OnDestroyFunc: () -> ()
}

function Functions.ESP(Properties: ESPArg)

    local Args = {
        Object = Properties.Object,
        Text = Properties.Text,
        TextModel = Properties.TextModel or nil,
        Color = Properties.Color,
        Type = Properties.Type,
        OnDestroyFunc = Properties.OnDestroyFunc or function()
            if Properties.IsEntity then
                if Properties.Object and Properties.Object.PrimaryPart then
                    Properties.Object.PrimaryPart.Transparency = 1
                end
            end
        end,
        IsEntity = Properties.IsEntity or false
    }

    local ESP = ESPLibrary:Add({
        Name = Args.Text,
        Model = Args.Object,
        TextModel = Args.TextModel,
        Color = Args.Color,
        FillColor = Args.Color,
        OutlineColor = Args.Color,
        ESPType = "Highlight",
        TextSize = Options.TextSize.Value,

        OnDestroyFunc = Args.OnDestroyFunc,

        Tracer = {
            Enabled = true,
            Color = Args.Color,
            From = Options.TracerStart.Value
        }
    })

    if Args.IsEntity then
        if Args.Object and Args.Object.PrimaryPart then
            Args.Object.PrimaryPart.Transparency = 0
        end
    end

    table.insert(ESPTable[Args.Type], ESP)


    return ESP
end

function Functions.EntityESP(entity)
    if not entity:IsA("Model") or not Toggles.EntityESP.Value then
        return
    end

    if IsEntity[entity.Name] and IsEntity[entity.Name].Type == "Entity" then
        Functions.ESP({
            Object = entity,
            Text = Functions.ShortName(entity),
            Color = Options.EntityESPColor.Value,
            Type = "Entity",
            IsEntity = entity.Name ~= "JeffTheKiller"
        })
    end
end

function Functions.SideEntityESP(entity)
    if not entity:IsA("Model") or not Toggles.EntityESP.Value then
        return
    end

    if IsEntity[entity.Name] then
        if IsEntity[entity.Name].Type == "SideEntity" then
            Functions.ESP({
                Object = entity,
                Text = Functions.ShortName(entity),
                TextModel = if entity.Name == "GiggleCeiling" then entity.Root else nil,
                Color = Options.EntityESPColor.Value,
                Type = "SideEntity"
            })
        end
    end
end

function Functions.GetDoorText(door: Model)
    local shortnum = nil
    local longnum = nil
    local stinker = door:FindFirstChild("Sign"):FindFirstChild("SignText") or door:FindFirstChild("Sign"):FindFirstChild("Stinker")

    shortnum = if Options.DoorESPTextMethod.Value == "Normal (1)" then tonumber(door.Parent.Name) + 1 else nil
    longnum = if Options.DoorESPTextMethod.Value == "Four Digits (0001)" then stinker.Text else nil

    if IsFloor.Mines and shortnum then
        shortnum += 100
    end

    if shortnum then
        return shortnum
    else
        return longnum
    end
end

function Functions.DoorESP(room)
    if not room:IsA("Model") or not Toggles.DoorESP.Value then
        return
    end

    local Door = room:WaitForChild("Door", 5)

    if Door then
        local RealDoor: BasePart = Door:WaitForChild("Door", 5)

        if RealDoor then
            local Locked = room:GetAttribute("RequiresKey")
            local Opened = Door:GetAttribute("Opened")
            local State = if Locked and not Opened then "[Locked]" elseif Opened then "[Opened]" else ""
            local RoomNum = Functions.GetDoorText(room:FindFirstChild("Door"))
            local String = string.format("Door %s %s", RoomNum, State)

            local DoorESP = Functions.ESP({
                Object = RealDoor,
                Text = String,
                Color = Options.DoorESPColor.Value,
                Type = "Door",

                OnDestroy = function()
                    if Connections["Door " .. RoomNum] then
                        Connections["Door " .. RoomNum]:Disconnect()
                    end
                end
            })

            Connections["Door " .. RoomNum] = Door:GetAttributeChangedSignal("Opened"):Connect(function()
                if DoorESP and Door and RealDoor then
                    DoorESP.CurrentSettings.Name = string.format("Door %s %s", RoomNum, "[Opened]")
                end
            end)
        end
    end
end

function Functions.ObjectiveESP(objective)
    if not objective:IsA("Model") or not Toggles.ObjectiveESP.Value then
        return
    end

    if not Objectives[objective.Name] then
        return
    end

    if objective.Name == "TimerLever" then
        Functions.ESP({
            Object = objective,
            Text = string.format("Time Lever [+%s]", objective.TakeTimer.TextLabel.Text),
            Color = Options.ObjectiveESPColor.Value,
            Type = "Objective"
        })
    elseif objective.Name == "WaterPump" then
        local wheel = objective:WaitForChild("Wheel", 5)
        local OnFrame = objective:FindFirstChild("OnFrame", true)

        if wheel and (OnFrame and OnFrame.Visible) then
            local Random = Functions.RandomString()

            local ESPInstance = Functions.ESP({
                Object = wheel,
                Text = "Valve",
                Color = Options.ObjectiveESP.Value,
                Type = "Objective"
            })
        end
    elseif objective.Name == "MinesAnchor" then
        local sign = objective:WaitForChild("Sign", 5)

        if sign and sign:FindFirstChild("TextLabel") then
            Functions.ESP({
                Object = objective,
                Text = string.format("Anchor %s", sign.TextLabel.Text),
                Color = Options.ObjectiveESPColor.Value,
                Type = "Objective"
            })
        end
    end

    if Objectives[objective.Name] and (objective.Name ~= "TimerLever" and objective.Name ~= "WaterPump" and objective.Name ~= "MinesAnchor") then
        Functions.ESP({
            Object = objective,
            Text = Objectives[objective.Name].ESPName,
            Color = Options.ObjectiveESPColor.Value,
            Type = "Objective"
        })
    end
end

function Functions.ItemESP(item, dropped: boolean)
    if not Functions.IsItem(item) or not Toggles.ItemESP.Value or Objectives[item.Name] then
        return
    end

    Functions.ESP({
        Object = item,
        Text = Functions.ShortName(item),
        Color = Options.ItemESPColor.Value,
        Type = if dropped then "DroppedItem" else "Item"
    })
end

function Functions.GoldESP(gold)
    if not gold:IsA("Model") or not Toggles.GoldESP.Value then
        return
    end

    if gold.Name == "GoldPile" then
        Functions.ESP({
            Object = gold,
            Text = string.format("Gold [%s]", gold:GetAttribute("GoldValue")),
            Color = Options.GoldESPColor.Value,
            Type = "Gold"
        })
    end
end

function Functions.ChestESP(storage)
    if not storage:IsA("Model") or not Toggles.ChestESP.Value then
        return
    end

    if storage.Name:find("Chest") or storage.Name == "Toolshed_Small" or storage:GetAttribute("Storage") == "ChestBox" then
        local State = if storage:GetAttribute("Locked") then "[Locked]" else ""
        local CleanerName = storage.Name:gsub("_Small", ""):gsub("Box", ""):gsub("Locked", ""):gsub("_Vine", "") .. " %s"
        local String = string.format(CleanerName, State)

        Functions.ESP({
            Object = storage,
            Text = String,
            Color = Options.ChestESPColor.Value,
            Type = "Chest"
        })
    end
end

function Functions.HidingSpotESP(spot)
    if not spot:IsA("Model") or not Toggles.HidingSpotsESP.Value then
        return
    end

    if spot.Name == "Rooms_Locker" or spot.Name == "Retro_Wardrobe" or spot:GetAttribute("LoadModule") == "Bed" or spot:GetAttribute("LoadModule") == "Wardrobe" then
        local IsBed = spot.Name == "Bed"
        local String = if IsBed then "Bed" else FloorHidingSpot[Floor]

        Functions.ESP({
            Object = spot,
            Text = String,
            Color = Options.HidingSpotESPColor.Value,
            Type = "HidingSpot"
        })
    end
end

function Functions.PlayerESP(player: Player)
    if not player:IsA("Player") or player == Player or not Toggles.PlayerESP.Value then
        return
    end

    local char = player.Character or player.CharacterAdded:Wait()

    Functions.ESP({
        Object = char,
        Text = player.DisplayName,
        Color = Options.PlayerESPColor.Value,
        Type = "Player"
    })
end

function Functions.LadderESP(ladder: Model)
    Functions.ESP({
        Object = ladder,
        Text = "Ladder",
        Color = Color3.new(0, 0, 255),
        Type = "Ladder"
    })
end

function Functions.AssetCheck(asset: Instance, UnloadState: boolean)

    if asset and asset.Parent then

        if asset.Name == "Collision" and asset.Parent.Name == "TriggerEventCollision" and Toggles.NoSeekFE.Value then
            task.spawn(Functions.SetupDeleteSeek, asset)
        end

        if asset.Name == "Snare" then
            asset:WaitForChild("Hitbox", 5).CanTouch = if UnloadState then true else not Toggles.RemoveSnareHitbox.Value
        end

        if IsFloor.Mines then
            if asset.Name == "GiggleCeiling" then
                asset:WaitForChild("Hitbox", 5).CanTouch = if UnloadState then true else not Toggles.GiggleHitboxRemoval.Value
            end
    
            if asset.Name == "GloomPile" then
                for _, v in pairs(asset:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanTouch = if UnloadState then true else not Toggles.AntiGloomEgg.Value
                    end
                end
            end
        end

        if IsFloor.Hotel then
            if (asset.Name == "Seek_Arm" or asset.Name == "ChandelierObstruction") then
                for _, v in pairs(asset:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanTouch = if UnloadState then true else not Toggles.noObstaclesToggle.Value
                    end
                end
            end
        end

        if IsFloor.Hotel or IsFloor.Fools or IsFloor.Mines or IsFloor.Backdoor then
            if asset:GetAttribute("LoadModule") == "DupeRoom" or asset:GetAttribute("LoadModule") == "SpaceSideroom" then
                task.spawn(Functions.DupeDisable, asset, (if UnloadState then false else not Toggles.NoDupeTouch.Value))
            end
        end

        if (asset:IsA("ProximityPrompt") and asset.KeyboardKeyCode == Enum.KeyCode.E) and not UnloadState then
            table.insert(GamePrompts, asset)

            if not asset:GetAttribute("OGDistance") then
                asset:SetAttribute("OGDistance", asset.MaxActivationDistance)
            end

            if not asset:GetAttribute("RequiresSight") then
                asset:SetAttribute("RequiresSight", asset.RequiresLineOfSight)
            end

            asset.RequiresLineOfSight = not Toggles.PromptClip.Value

            asset.MaxActivationDistance = asset:GetAttribute("OGDistance") * Options.PromptReach.Value
        end
    end
end

function Functions.SetupRoom(room: Model)

    if room:GetAttribute("RawName"):find("Halt") then
        Library:Notification("Halt will be in the next room.")
    end

    for _, v in pairs(room:GetDescendants()) do
        
        if IsFloor.Mines and v:GetAttribute("Chase") then
            if v.Name == "Parts" or v:FindFirstAncestor("Parts") then
                continue
            end
        end

        task.spawn(Functions.AssetCheck, v)
    end

    Connections[tonumber(room.Name)] = room.DescendantAdded:Connect(function(descendant)
        if room == CurrentRoomModel then
            if Toggles.ItemESP.Value then
                task.spawn(Functions.ItemESP, descendant)
            end
    
            if Toggles.ObjectiveESP.Value then
                task.spawn(Functions.ObjectiveESP, descendant)
            end
    
            if Toggles.GoldESP.Value then
                task.spawn(Functions.GoldESP, descendant)
            end
        end

        task.delay(0.1, Functions.AssetCheck, descendant)
    end)
end

function Functions.SetupCamera(camera: Camera)
    if camera and camera:IsA("Camera") then
         Connections["CameraConnection"] = camera.ChildAdded:Connect(function(child)
            if child.Name == "Guidance" then
                task.spawn(Functions.GuidingLightESP, child)
            end

            if child.Name == "MinecartRig" then
                table.insert(Minecarts, child)
            end
         end)
    end
end

function Functions.SetupCurrentRoomESP(room: Model)
    for _, v in pairs(room:GetDescendants()) do
        task.spawn(Functions.ItemESP, v)

        task.spawn(Functions.ChestESP, v)

        task.spawn(Functions.SideEntityESP, v)

        task.spawn(Functions.GoldESP, v)

        task.spawn(Functions.HidingSpotESP, v)

        task.spawn(Functions.ObjectiveESP, v)
    end
end

function Functions.ClearRoomESP()
    if Toggles.ObjectiveESP.Value then
        for _, v in pairs(ESPTable.Objective) do
            v:Destroy()
        end
    end

    if Toggles.ItemESP.Value then
        for _, v in pairs(ESPTable.Item) do
            v:Destroy()
        end
    end

    if Toggles.HidingSpotsESP.Value then
        for _, v in pairs(ESPTable.HidingSpot) do
            v:Destroy()
        end
    end

    if Toggles.GoldESP.Value then
        for _, v in pairs(ESPTable.Gold) do
            v:Destroy()
        end
    end

    if Toggles.EntityESP.Value then
        for _, v in pairs(ESPTable.SideEntity) do
            v:Destroy()
        end
    end

    if Toggles.ChestESP.Value then
        for _, v in pairs(ESPTable.Chest) do
            v:Destroy()
        end
    end
end


function Functions.BridgePlatform(bridge)
    if not bridge:IsA("Model") or not bridge or not bridge.Parent or not bridge.Name == "Bridge" or not Toggles.BridgeWalk.Value then
        return
    end

    local barrier = nil
    local clone = nil

    for _, v: BasePart in pairs(bridge:GetChildren()) do
        if v.Name == "PlayerBarrier" and v.Size.Y == 2.75 then
            barrier = v
            break
        end
    end
    
    if barrier then
        clone = barrier:Clone()
        clone.Name = "_BridgeBarrier"
        clone.Parent = barrier.Parent
        clone.CFrame = barrier.CFrame
        clone.Size = Vector3.new(barrier.Size.X, barrier.Size.Y, 40)
        clone.Color = Color3.new(1, 1, 1)
        clone.Transparency = 1

        table.insert(Bridges, clone)
    end
end

function Functions.IsMultiplayer()
    return #Players:GetPlayers() > 1
end


function Functions.MakeRandomString()
    return charactertable[Random:NextInteger(1, #charactertable)]
end

function Functions.RandomString()
    local ret = ""

    for i = 1, 8 do
        local randomletter = Functions.MakeRandomString()

        if Random:NextNumber() > 0.5 then
            randomletter = randomletter:upper(randomletter)
        end
        ret = ret .. randomletter
    end
    return ret
end

function Functions.IsItem(inst)
    if inst:IsA("Model") and (inst:GetAttribute("Pickup") or inst:GetAttribute("PropType")) then 
        return true
    else
        return false
    end
end

getgenv().isnetworkowner = isnetworkowner or function(Part)
   return Part.ReceiveAge == 0
end

function Functions.SetSpeedBypass(set: boolean)
    IsBypass = set

    if not CollisionClone then
        return
    end

    if IsBypass then
        Options.Walkspeed:SetMax(75)
        Options.FlySpeed:SetMax(75)
    end

    task.spawn(function()
        while IsBypass and Player:GetAttribute("Alive") and Collision and CollisionClone and getgenv().Loaded do
            if HumanoidRootPart.Anchored then
                CollisionClone.Massless = true -- doesn't waste your time freezing you every second and just teleports you back
                repeat
                    task.wait()
                until not HumanoidRootPart.Anchored
            else
                CollisionClone.Massless = not CollisionClone.Massless
            end

            task.wait(Options.SpeedBypassDelay.Value)
        end

        Options.Walkspeed:SetMax(22)
        Options.FlySpeed:SetMax(18)

        CollisionClone.Massless = false
    end)
end

function Library:Notification(string: string)
    Library:Notify(string)

    if Toggles.NotificationSound.Value then
        notificationSound:Play()
    end
end



function Functions.DupeDisable(dupe: Model, value: boolean)
    if dupe and dupe:IsA("Model") and (dupe.Name == "SideroomDupe" or dupe:GetAttribute("LoadModule") == "DupeRoom" or dupe:GetAttribute("LoadModule") == "SpaceSideroom") then
        if dupe:GetAttribute("LoadModule") == "SpaceSideroom" then
            local SideroomCollision = dupe:WaitForChild("Collision")

            SideroomCollision.CanTouch = not value
            SideroomCollision.CanCollide = value
        else
            local doorfake = dupe:WaitForChild("DoorFake")

            doorfake:WaitForChild("Hidden").CanTouch = not value
            
            if doorfake:FindFirstChild("Lock") then
                doorfake.Lock:WaitForChild("UnlockPrompt").Enabled = not value
            end
        end
    end
end
function Functions.SetupDeleteSeek(trigger: BasePart)
    if Toggles.NoSeekFE.Value then
        Library:Notification("Attempting to delete Seek...")

        task.delay(3, function()
            if trigger:IsDescendantOf(workspace) then
                Library:Notification("Script was unable to delete Seek on the server. Please check the console.")
            end
        end)

        task.delay(1.5, function()
            HumanoidRootPart.Anchored = false
        end)

        HumanoidRootPart.Anchored = true

        task.spawn(function()
            repeat
                if trigger:IsDescendantOf(workspace) then
                    firetouchinterest(trigger, HumanoidRootPart, 1)
                end
                task.wait()
                if trigger:IsDescendantOf(workspace) then
                    firetouchinterest(trigger, HumanoidRootPart, 0)
                end
            until not trigger:IsDescendantOf(workspace) or not Toggles.NoSeekFE.Value

            if not trigger:IsDescendantOf(workspace) then
                Library:Notification("Successfully deleted Seek.")
            end
        end)
    end
end

function Functions.MinecartTeleport(room: Model)
    if (tonumber(room.Name) >= 45 and tonumber(room.Name) <= 49) and Toggles.MinecartTeleport.Value then
        task.spawn(function()
            repeat
                task.wait()
                for _, v in pairs(Minecarts) do
                    if v and v:IsDescendantOf(workspace) and v.Parent and v.Parent == Camera then
                        v.PrimaryPart.CFrame = room:FindFirstChild("Door"):FindFirstChild("Door").CFrame
                    end
                end
            until room:FindFirstChild("Door"):GetAttribute("Opened") 
        end)
    end
end

function Functions.ShortName(v: Instance)
    local Ret = v.Name

    for _, element in pairs(ShortNameTable) do
       Ret = Ret:gsub(element, "")
    end

    if table.find(ShortNameExclusions, v.Name) then
        Ret = ShortNameExclusions[v.Name].Shortened
    end

    if v.Name == "PickupItem" and v.Parent.Name == "50" then
        Ret = "Library Paper"
    end

    if v.Name:find("(%l)(%u)") then
        Ret = Ret:gsub("(%l)(%u)", "%1 %2")
    end

    if v.Name == "RushMoving" and v.PrimaryPart.Name ~= "RushNew" and IsFloor.Fools then
        Ret = v.PrimaryPart.Name
    end

    if v.Name == "GloombatSwarm" then
        Ret = "Gloombat Swarm"
    end

    return Ret
end

function Functions.AvailablePrompt(prompt: ProximityPrompt)
    if not prompt or not prompt.Parent then
        return false
    end

    if not prompt:IsA("ProximityPrompt") then
        return false
    end

    if prompt.Parent:GetAttribute("JeffShop") then
        return false
    end

    if prompt.Parent:GetAttribute("PropType") then
        if prompt.Parent:GetAttribute("PropType") == "Heal" and Humanoid.Health == 100 then
            return false
        end
    end

    if prompt:FindFirstAncestor("CandyRed") then
        return false
    end

    if prompt.KeyboardKeyCode ~= Enum.KeyCode.E then
        return false
    end

    if not prompt.Enabled then
        return false
    end

    if prompt.Parent.Name == "Retro_Wardrobe" or prompt.Parent.Name == "MinesAnchor" then
        return false
    end

    if Functions.DistanceFromCharacter(prompt.Parent) > prompt.MaxActivationDistance then
        return false
    end

    if prompt:GetAttribute("Interactions" .. Character.Name) and prompt.Parent.Name ~= "Lock" and not prompt:FindFirstAncestor("MinesGenerator") and prompt.Parent.Parent.Name ~= "MinesGateButton" and not prompt.Parent:GetAttribute("Locked") then
        return false
    end

    if prompt:FindFirstAncestor("KeyObtainFake") or prompt:FindFirstAncestor("Padlock") then
        return false
    end

    return AutoInteractPrompts[prompt.Name] ~= nil
end

function Functions.GuidingLightESP(Guidance: BasePart)
    if Guidance.Name ~= "Guidance" then
        return
    end
    
    Functions.ESP({
        Object = Guidance,
        Text = Guidance.Name,
        Color = Options.GuidingLightESPColor.Value,
        Type = "GuidingLight"
    })
end

-- \ UI Code \ --
local Window = Library:CreateWindow({
    Title = string.format("%s | %s ", "silly v2 real", Player.DisplayName),
    Center = true,
    AutoShow = true,
    TabPadding = 2,
    MenuFadeTime = 0.09,
    ShowCustomCursor = true
})


-- \ custom functions rel (may need them and whoever is seeing this may feel free to use this) \ --

if Supported["hookmetamethod"] then
	Hooks.FindFirstChildWithCondition = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local met = getnamecallmethod()
        local child = nil

        if met == "FindFirstChildWithCondition" then
            if args[3] and args[3] == true then
                for _, v in ipairs(self:GetDescendants()) do
					if args[2](v) == true and args[1] == v.Name then
                        child = v
                        break
                    end
				end
            else
				for _, v in ipairs(self:GetChildren()) do
					if args[2](v) == true and args[1] == v.Name then
                        child = v
                        break
                    end
				end
			end

            return child
        end

        return Hooks.FindFirstChildWithCondition(self, ...)
    end)

    Hooks.WaitForChildWithCondition = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local met = getnamecallmethod()
        local child = nil

        if met == "WaitForChildWithCondition" then
            local t = tick()
            
            if args[3] == nil then
                args[3] = math.huge
            end

            repeat
				task.wait()
                for _, v in ipairs(self:GetChildren()) do
					if args[1] == v.Name and args[2](v) == true then
                        child = v
                    end
				end
			until tick() - t >= args[3] or child or not self

            if child and child.Parent and self then
                return child
            end
        end

        return Hooks.WaitForChildWithCondition(self, ...)
    end)

    Hooks.WaitForChildWhichIsA = hookmetamethod(game, "__namecall", function(self, ...)
        local met = getnamecallmethod()
        local args = {...}
        local class = args[1]
        local timeout = args[2] or math.huge

        if met == "WaitForChildWhichIsA" then
			local t = tick()
            repeat
				task.wait()
			until self:FindFirstChildWhichIsA(class) or tick() - t >= timeout

            if self and self:FindFirstChildWhichIsA(class) then
                return self:FindFirstChildWhichIsA(class)
            end
        end

        return Hooks.WaitForChildWhichIsA(self, ...)
    end)
else
    function Functions.FindFirstChildWithCondition(self: Instance, childName: string, condition: () -> (), recursive: boolean)
        local child = nil

        if recursive then
            for _, v in ipairs(self:GetDescendants()) do
                if condition(v) and childName == v.Name then
                    child = v
                    break
                end
            end
        else
            for _, v in ipairs(self:GetChildren()) do
                if condition(v) and childName == v.Name then
                    child = v
                    break
                end
            end
        end

        if child and child.Parent then
            
        end
    end

    function Functions.WaitForChildWithCondition(self: Instance, childName: string, condition: () -> (), timeout: number | nil)
        local child = nil
        local t = tick()

        if timeout == nil then
            timeout = math.huge
        end

        repeat
            task.wait()
            for _, v in ipairs(self:GetChildren()) do
                if condition(v) and childName == v.Name then
                    child = v
                end
            end
        until child or not self or tick() - t >= timeout

        if child and self and child.Parent then
            return child
        end
    end
end


local Tabs = {
   
    Main = Window:AddTab("Main"),
    Cheats = Window:AddTab("Exploits"),
    Fun = Window:AddTab("Fun (WIP!)"),
    Visuals = Window:AddTab("Visual"),
    Configs = Window:AddTab("Configs"),
}


Groupboxes.Automation = Tabs.Main:AddRightGroupbox("Automation")
Groupboxes.Player = Tabs.Main:AddLeftGroupbox("Player")

CurrentRooms.DescendantAdded:Connect(function(d)
    task.wait(.101)
    if d and (d:IsA("Model") or d:IsA("Folder")) and d.Name == "AnimSaves" then d:Destroy(); end
end)

Groupboxes.Automation:AddToggle("noewait", {
    Text = "Instant Interact",
    Default = false,
    Tooltip = "Skips wait-time for interacting.",
})
if IsFloor.Hotel or IsFloor.Fools then
    Groupboxes.Automation:AddDivider()
end
Groupboxes.Automation:AddToggle("autopl", {
    Text = "Auto Padlock Code",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.Fools
})
Groupboxes.Automation:AddToggle("AutoBreakerBox", {
    Text = "Auto Breaker Box",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.Fools
})
Groupboxes.Automation:AddToggle("AutoAnchor", {
    Text = "Auto Anchor",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.Automation:AddToggle("MinecartTeleport", {
    Text = "Minecart Teleport",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.Automation:AddToggle("AutoInteract", {
    Text = "Auto Interact",
    Default = false
}):AddKeyPicker("AutoInteractKey", {
    Default = "R",
    SyncToggleState = false,
    NoUI = false,
    Mode = "Toggle",
    Text = "Auto Interact"
})
Groupboxes.Player:AddSlider("Walkspeed", {
    Text = "Walkspeed",
    Default = 16,
    Min = 0,
    Max = 22,
    Rounding = 0, 
    Compact = true
})

Groupboxes.Player:AddSlider("Slope", {
    Text = "Max Slope Angle",
    Default = 45,
    Min = 0,
    Max = 90,
    Compact = true,
    Rounding = 1
})

Groupboxes.Player:AddToggle("noslide", {
    Text = "No Acceleration",
    Default = false,
})
Groupboxes.Player:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
}):AddKeyPicker("noclipKey", {
    Text = "Noclip",
    Default = "N",
    SyncToggleState = true,
    Mode = "Toggle",
    NoUI = false
})
Groupboxes.Player:AddDivider()
Groupboxes.Player:AddToggle("sbypass", {
    Text = "Speed Bypass",
    Default = false,
})
Groupboxes.Player:AddSlider("SpeedBypassDelay", {
    Text = "Speed Bypass Delay",
    Default = 0.23,
    Min = 0.21,
    Max = 0.25,
    Rounding = 3,
    Compact = true
})

Groupboxes.Player:AddDivider()

Groupboxes.Player:AddToggle("hidingExiting", {
    Text = "Hiding Exiting Fix",
    Default = false
})


Groupboxes.Player:AddToggle("Fly", {
    Text = "Fly",
    Default = false
}):AddKeyPicker("FlyKey", {
    Text = "Fly",
    Default = "F",
    SyncToggleState = true,
    Mode = "Toggle",
    NoUI = false
})

Groupboxes.Player:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 16,
    Max = 18,
    Min = 16,
    Rounding = 0,
    Compact = true
})

Groupboxes.Player:AddDivider()

Groupboxes.Player:AddToggle("jump", {
    Text = "Jump",
    Default = false,
})

Groupboxes.Player:AddSlider("JumpHeight", {
    Text = "Jump Boost",
    Default = 5,
    Min = 0,
    Max = 50,
    Rounding = 0,
    Compact = true
})

Groupboxes.Reach = Tabs.Main:AddLeftGroupbox("Reach")

Groupboxes.Reach:AddToggle("PromptClip", {
    Text = "Prompt Clip", 
    Default = false
})

Groupboxes.Reach:AddSlider("PromptReach", {
    Text = "Prompt Reach Multiplier",
    Default = 1,
    Min = 1,
    Max = 2,
    Rounding = 1,
    Compact = true
})

Groupboxes.Reach:AddDivider()

Groupboxes.Reach:AddToggle("DoorReach", {
    Text = "Door Reach",
    Default = false
})


Groupboxes.Notifying = Tabs.Main:AddRightGroupbox("Notifying")
Groupboxes.Notifying:AddDropdown("EntityNotifier", {
    AllowNull = true,
    Values = {"Rush", "Ambush", "Eyes", "Jeff The Killer", "A-60", "A-120", "Blitz", "Lookman", "Halt", "Gloombat Swarm"},
    Multi = true,
    Text = "Entity Notifier"
})
Groupboxes.Notifying:AddToggle("NotificationSound", {
    Text = "Notification Sound",
    Default = false
})
Groupboxes.Notifying:AddToggle("plcode", {
    Text = "Padlock Code",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.Fools
})
Groupboxes.Notifying:AddToggle("plrleave", {
    Text = "Player Leaving",
    Default = false,
})
Groupboxes.Miscellaneous = Tabs.Main:AddRightGroupbox("Miscellaneous")
local reviveButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Revive",
    Func = function()
        RemotesFolder:WaitForChild("Revive"):FireServer()
    end,  
    DoubleClick = false,
})
local restartButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Play Again",
    Func = function()
        RemotesFolder:WaitForChild("PlayAgain"):FireServer()
    end,
    DoubleClick = false,
})
local lobbyButton = Groupboxes.Miscellaneous:AddButton({
    Text = "Lobby",
    Func = function()
        RemotesFolder:WaitForChild("Lobby"):FireServer()
    end,
    DoubleClick = false,
})



Groupboxes.AntiEntity = Tabs.Cheats:AddLeftGroupbox("Anti-Entity")
Groupboxes.AntiEntity:AddToggle("RemoveSnareHitbox", {
    Text = "Anti-Snare",
    Default = false,
    Visible = IsFloor.Mines or IsFloor.Hotel or IsFloor.Fools
})
Groupboxes.AntiEntity:AddToggle("NoDupeTouch", {
    Text = "Anti-Dupe",
    Default = false,
    Visible = IsFloor.Mines or IsFloor.Hotel or IsFloor.Fools
})
Groupboxes.AntiEntity:AddToggle("nobanana", {
    Text = "Anti-Bananas",
    Default = false,
    Visible = IsFloor.Fools
})
Groupboxes.AntiEntity:AddToggle("noeyes", {
    Text = if IsFloor.Backdoor then "Anti-Lookman" else "Anti-Eyes",
    Default = false,
})
Groupboxes.AntiEntity:AddToggle("GiggleHitboxRemoval", {
    Text = "Anti-Giggle",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.AntiEntity:AddToggle("AntiGloomEgg", {
    Text = "Anti-Gloom Egg",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.AntiEntity:AddToggle("AntiDread", {
    Text = "Anti-Dread",
    Default = false,
})
Groupboxes.AntiEntity:AddToggle("nohalt", {
    Text = "Anti-Halt",
    Default = false,
})
Groupboxes.AntiEntity:AddToggle("AntiJeffClient", {
    Text = "Anti-Jeff (Client-Side)",
    Default = false,
    Visible = IsFloor.Fools
})
Groupboxes.Removal = Tabs.Cheats:AddRightGroupbox("Removal")
Groupboxes.Removal:AddToggle("RemoveScreech", {
    Text = "No Screech",
    Default = false,
})

Groupboxes.Removal:AddToggle("A90Disabled", {
    Text = "No A90",
    Default = false,
})

Groupboxes.Removal:AddDivider()

Groupboxes.Removal:AddToggle("serverSideKillJeff", {
    Text = "No Jeff FE",
    Default = false,
    Visible = IsFloor.Fools
})

Groupboxes.Removal:AddToggle("NoSeekFE", {
    Text = "FE No Seek Trigger",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.Fools or IsFloor.Mines
})

Groupboxes.SelfCheats = Tabs.Cheats:AddRightGroupbox("Self")

Groupboxes.SelfCheats:AddToggle("Godmode", {
    Text = "Godmode",
    Default = false,
    Risky = true,
    Tooltip = "Lagback, crouch is buggy, body rotation is HIGHLY unrecommended to use"
}):AddKeyPicker("GodmodeKey", {
    Text = "Godmode",
    NoUI = false,
    Default = "G",
    SyncToggleState = true
})

Groupboxes.SelfCheats:AddToggle("AnticheatBypass", {
    Text = "Anticheat Bypass",
    Default = false,
    Visible = IsFloor.Mines
})

Groupboxes.SelfCheats:AddToggle("FigureHearing", {
    Text = "No Figure Hearing",
    Default = false,
    Visible = IsFloor.Mines or IsFloor.Fools or IsFloor.Hotel
})
Groupboxes.SelfCheats:AddToggle("noObstaclesToggle", {
    Text = "Anti-Obstacles",
    Default = false,
    Visible = IsFloor.Hotel or IsFloor.Fools
})
Groupboxes.SelfCheats:AddToggle("BridgeWalk", {
    Text = "Anti-Bridge Fall",
    Default = false,
    Visible = IsFloor.Mines
})
Groupboxes.SelfCheats:AddDivider()

Groupboxes.SelfCheats:AddToggle("InfUniversalKey", {
    Text = "Infinite Items",
    Default = false,
    Visible = not IsFloor.Fools
})


Groupboxes.FE = Tabs.Fun:AddLeftGroupbox("Trolling")

Groupboxes.FE:AddToggle("StunToggle", {
    Text = "Roll Over",
    Default = false
}):AddKeyPicker("StunKeybind", {
    Text = "Roll Over",
    Default = "P",
    NoUI = false,
    SyncToggleState = true
})

Groupboxes.FE:AddToggle("SpamOtherTools", {
    Text = "Spam Others' Tools",
    Default = false
}):AddKeyPicker("SpamOtherToolsKeybind", {
    Text = "Spam Others' Tools",
    Default = "V",
    NoUI = false,
    SyncToggleState = false
})

Groupboxes.FE:AddDropdown("BodyRotation", {
    Values = {
        "Normal",
        "Up",
        "Upside Down",
        "Left",
        "Right",
        "Random"
    },
    Default = "Normal",
    Multi = false,
    Text = "Body Rotation"
})



local breakDoors = Groupboxes.FE:AddButton({
    Text = "Teleport Unanchored",
    Func = function()
        for i, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Attachment") and not v:FindFirstAncestor("RushMoving") and not v:FindFirstAncestor("AmbushMoving") and not v:FindFirstAncestor("Dread") then
                v.WorldCFrame = HumanoidRootPart.CFrame
        end
    end

        CurrentRooms.DescendantAdded:Connect(function(v)
            if v:IsA("Attachment") and not v:FindFirstAncestor("RushMoving") and not v:FindFirstAncestor("AmbushMoving") and not v:FindFirstAncestor("Dread") then
                v.WorldCFrame = HumanoidRootPart.CFrame
            end
        end)
    end,
    DoubleClick = false,
})




local TabBox = Tabs.Visuals:AddLeftTabbox()

Groupboxes.ESP = TabBox:AddTab("ESP")

Groupboxes.ESP:AddToggle("EntityESP", {
    Text = "Entity",
    Default = false,
}):AddColorPicker("EntityESPColor", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Entity ESP Color"
})


Groupboxes.ESP:AddToggle("DoorESP", {
    Text = "Door ESP",
    Default = false,
}):AddColorPicker("DoorESPColor", {
    Default = Color3.fromRGB(0, 255, 255),
    Title = "Door ESP Color",
})

Groupboxes.ESP:AddToggle("ObjectiveESP", {
    Text = "Objective",
    Default = false
}):AddColorPicker("ObjectiveESPColor", {
    Default = Color3.fromRGB(0, 150, 0),
    Title = "Objective ESP Color"
})

Groupboxes.ESP:AddToggle("PlayerESP", {
    Text = "Player",
    Default = false
}):AddColorPicker("PlayerESPColor", {
    Default = Color3.fromRGB(255, 255, 255)
})

Groupboxes.ESP:AddToggle("ItemESP", {
    Text = "Item",
    Default = false,
}):AddColorPicker("ItemESPColor", {
    Default = Color3.fromRGB(1, 50, 32),
    Title = "Item ESP Color",
})

Groupboxes.ESP:AddToggle("GoldESP", {
    Text = "Gold",
    Default = false
}):AddColorPicker("GoldESPColor", {
    Default = Color3.fromRGB(229, 184, 11),
    Title = "Gold ESP Color",
})

Groupboxes.ESP:AddToggle("ChestESP", {
    Text = "Chest/Toolshed",
    Default = false
}):AddColorPicker("ChestESPColor", {
    Default = Color3.fromRGB(120, 42, 42),
    Title = "Chest ESP Color",
})

Groupboxes.ESP:AddToggle("HidingSpotsESP", {
    Text = "Hiding Spot",
    Default = false
}):AddColorPicker("HidingSpotESPColor", {
    Default = Color3.fromRGB(165, 42, 42),
    Title = "Hiding Spot ESP Color",
})

if IsFloor.Mines then
    Groupboxes.ESP:AddToggle("GuidingLightESP", {
        Text = "Guidance",
        Default = false
    }):AddColorPicker("GuidingLightESPColor", {
        Default = Color3.fromRGB(0, 0, 255)
    })
end

Groupboxes.Settings = TabBox:AddTab("ESP Settings")

Groupboxes.Settings:AddToggle("DistanceESP", {
    Text = "Show Distance",
    Default = false
})

Groupboxes.Settings:AddToggle("RainbowESP", {
    Text = "Rainbow",
    Default = false
})

Groupboxes.Settings:AddToggle("Tracers", {
    Text = "Enable Tracers",
    Default = false
})

Groupboxes.Settings:AddDropdown("TracerStart", {
    Values = {"Bottom", "Center", "Top", "Mouse"},
    Default = "Bottom",
    Multi = false,
    Text = "Tracer Start"
})

Groupboxes.Settings:AddDivider()

Groupboxes.Settings:AddSlider("TextSize", {
    Text = "Text Size",
    Min = 16,
    Default = 22,
    Max = 32,
    Compact = false,
    Rounding = 0
})
Groupboxes.Settings:AddDivider()

Groupboxes.Settings:AddDropdown("DoorESPTextMethod", {
    Text = "Door ESP Text",
    Multi = false,
    Values = {"Normal (1)", "Four Digits (0001)"},
    Default = "Normal (1)"
})

Groupboxes.Lighting = Tabs.Visuals:AddLeftGroupbox("Lighting")

Groupboxes.Lighting:AddToggle("ambienceToggle", {
    Text = "Fullbright",
    Default = false
})
Groupboxes.Lighting:AddToggle("NoFog", {
    Text = "No Fog",
    Default = false
})

Groupboxes.Lighting:AddDivider()

Groupboxes.Lighting:AddToggle("lightToggle", {
    Text = "Headlight",
    Default = false
})

Groupboxes.Lighting:AddSlider("lightSlider", {
    Text = "Brightness",
    Default = 0,
    Min = 0,
    Rounding = 1,
    Max = 3,
    Compact = true
})

Groupboxes.Lighting:AddDivider()

Groupboxes.Lighting:AddSlider("GameBrightness", {
    Text = "Game Brightness",
    Default = 1,
    Min = 0,
    Rounding = 1,
    Max = 3,
    Compact = true
})
local VisualTabBox = Tabs.Visuals:AddRightTabbox()

Groupboxes.View = VisualTabBox:AddTab("Self")

Groupboxes.View:AddToggle("NoCutscenes", {
    Text = "No Cutscenes",
    Default = false
})

Groupboxes.View:AddToggle("DisableCameraShake", {
    Text = "Disable Camera Shake",
    Default = false
})

Groupboxes.View:AddToggle("ThirdPerson", {
    Text = "Third Person",
    Default = false
}):AddKeyPicker("ThirdPersonKey", {
    Text = "Third Person",
    SyncToggleState = true,
    Default = "X",
    NoUI = false,
    Mode = "Toggle"
})

Groupboxes.View:AddSlider("fovSlider", {
    Text = "Field Of View",
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Compact = true
})

Groupboxes.View:AddDivider()

Groupboxes.View:AddToggle("TranslucentCloset", {
    Text = "Transparent " .. FloorHidingSpot[Floor],
    Default = false
})

Groupboxes.View:AddSlider("TransparencySlider", {
    Text = "Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true 
})

Groupboxes.View:AddDivider()

Groupboxes.View:AddToggle("ViewmodelOffset", {
    Text = "Viewmodel Offset",
    Default = false,
    Visible = Supported["require"]
})

Groupboxes.View:AddSlider("XOffset", {
    Text = "X",
    Default = 0,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true
})

Groupboxes.View:AddSlider("YOffset", {
    Text = "Y",
    Default = 0,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true
})

Groupboxes.View:AddSlider("ZOffset", {
    Text = "Z",
    Default = 0, 
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true
})

Groupboxes.Jumpscares = VisualTabBox:AddTab("Jumpscares")


Groupboxes.Jumpscares:AddToggle("NoVoidJumpscare", {
    Text = "No Void Effect",
    Default = false
})

Groupboxes.Jumpscares:AddToggle("NoGlitchFX", {
    Text = "No Glitch Jumpscare",
    Default = false
})

Groupboxes.Jumpscares:AddToggle("NoTimothyJumpscare", {
    Text = "No Timothy Jumpscare",
    Default = false
})

-- \ Logical Code \ --

workspace.FallenPartsDestroyHeight = (1 / 0) / (1 / 0)

Toggles.sbypass:OnChanged(function(value)
    Functions.SetSpeedBypass(value)
end)

Toggles.noslide:OnChanged(function(value)
    if value then
        HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 0, 0)
    else
        HumanoidRootPart.CustomPhysicalProperties = RootProperties
    end
end)


Toggles.Fly:OnChanged(function(value)
    FlyUtility:Set(value)
end)

Options.FlySpeed:OnChanged(function(val)
    FlyUtility.FlySpeed = val

end)

Toggles.autopl:OnChanged(function(value)
    if not IsFloor.Hotel or not IsFloor.Fools then
        return
    end

    if value then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Backpack:FindFirstChild("LibraryHintPaperHard") or v.Backpack:FindFirstChild("LibraryHintPaper") or v.Character:FindFirstChild("LibraryHintPaperHard") or v.Character:FindFirstChild("LibraryHintPaper") then
                local tool = v.Backpack:FindFirstChild("LibraryHintPaperHard") or v.Backpack:FindFirstChild("LibraryHintPaper") or v.Character:FindFirstChild("LibraryHintPaperHard") or v.Character:FindFirstChild("LibraryHintPaper")
                local code = Functions.PadlockCode(tool, v)
    
                RemotesFolder.PL:FireServer(code)
            end
        end
    end
end)

Toggles.plcode:OnChanged(function(value)
    if not IsFloor.Hotel or not IsFloor.Fools then
        return
    end
    if value then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Backpack:FindFirstChild("LibraryHintPaperHard") or v.Backpack:FindFirstChild("LibraryHintPaper") or v.Character:FindFirstChild("LibraryHintPaperHard") or v.Character:FindFirstChild("LibraryHintPaper") then
                local tool = v.Backpack:FindFirstChild("LibraryHintPaperHard") or v.Backpack:FindFirstChild("LibraryHintPaper") or v.Character:FindFirstChild("LibraryHintPaperHard") or v.Character:FindFirstChild("LibraryHintPaper")
                local code = Functions.PadlockCode(tool, v)

                Library:Notification("The code is " .. code .. ".")
                break
            end
        end
    end
end)

Toggles.lightToggle:OnChanged(function(value)
    Light.Enabled = value
    Light.Brightness = Options.lightSlider.Value
end)

Options.lightSlider:OnChanged(function(value)
    Light.Brightness = value
end)



Toggles.RemoveScreech:OnChanged(function(value)
    local Name = if value then "_Screech" else "Screech"

    screechModule.Name = Name
end)

Toggles.GiggleHitboxRemoval:OnChanged(function(value)
    if not IsFloor.Mines then
        return
    end
    for _, v in pairs(CurrentRoomModel:GetChildren()) do
        if v.Name:find("Giggle") then
            v:WaitForChild("Hitbox", 5).CanTouch = not value
        end
    end
end)

Toggles.AntiGloomEgg:OnChanged(function(value)
    if not IsFloor.Mines then
        return
    end
    for _, v in pairs(CurrentRoomModel:GetChildren()) do
        if v.Name == "GloomPile" then
            for _, x in pairs(v:GetDescendants()) do
                if x:IsA("BasePart") then
                    x.CanTouch = not value
                end
            end
        end
    end
end)

Toggles.AntiDread:OnChanged(function(value)
    Dread.Name = if value then "_Dread" else "Dread"
end)
Toggles.NoTimothyJumpscare:OnChanged(function(value)
    timothyModel.Parent = if value then nil else Entity
end)

Toggles.A90Disabled:OnChanged(function(value)
    local Name = if value then "_A90" else "A90"

    A90.Name = Name
end)

Toggles.NoCutscenes:OnChanged(function(value)
    if MainGame:FindFirstChild("Cutscenes", true) then
        local Cutscenes = MainGame:FindFirstChild("Cutscenes", true)

        for _, v in pairs(Cutscenes:GetChildren()) do
            if not table.find(ToExclude, v.Name) then
                local name = v.Name:gsub("Script", "")

                v.Name = if value then name .. "Script" else name
            end
        end
    end
end)

Toggles.NoSeekFE:OnChanged(function()
    if IsFloor.Rooms or IsFloor.Retro or IsFloor.Backdoor then
        return
    end
    if CurrentRooms:FindFirstChild(tostring(gameData.LatestRoom.Value + 1)) then
        local trigcollision = CurrentRooms[tostring(gameData.LatestRoom.Value + 1)]:FindFirstChild("TriggerEventCollision")
        local collision = if trigcollision then trigcollision:FindFirstChild("Collision") else nil

        if trigcollision and collision then
            Functions.SetupDeleteSeek(collision)
        end
    end
end)

Toggles.Godmode:OnChanged(function(value)
    if value then
        task.spawn(function()
            repeat
                task.wait()
            until not Toggles.Godmode.Value
            Collision.Position = CollisionClone.Position
        end)
    end
end)
Toggles.NoGlitchFX:OnChanged(function(value)
    local Name = if value then "_Glitch" else "Glitch"

    Glitch.Name = Name
end)

Toggles.NoVoidJumpscare:OnChanged(function(value)
    local Name = if value then "_Void" else "Void"

    Void.Name = Name
end)



Toggles.RemoveSnareHitbox:OnChanged(function(value)
    if IsFloor.Retro or IsFloor.Rooms or IsFloor.Backdoor then
        return
    end
    for _, v in pairs(CurrentRoomModel.Assets:GetChildren()) do
        if v.Name == "Snare" then
            v:WaitForChild("Hitbox", 5).CanTouch = not value
        end
    end
end)

Toggles.NoDupeTouch:OnChanged(function(value)
    if IsFloor.Rooms or IsFloor.Retro then
        return
    end
    for _, v in pairs(CurrentRoomModel:GetChildren()) do
        if v:GetAttribute("LoadModule") == "DupeRoom" or v:GetAttribute("LoadModule") == "SpaceSideroom" then
            task.spawn(Functions.DupeDisable, v, not value)
        end
    end
end)

Toggles.nobanana:OnChanged(function(value)
    if not IsFloor.Fools then
        return
    end
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "BananaPeel" then
            v.CanTouch = not value
        end
    end
end)

Toggles.nohalt:OnChanged(function(value)
    if IsFloor.Rooms or IsFloor.Retro or IsFloor.Backdoor then
        return
    end

    local Name = if value then "_Shade" else "Shade"

    Shade.Name = Name
end)

Toggles.AnticheatBypass:OnChanged(function(value)
    if value then
        Library:Notification("To bypass the anticheat, you need to get onto a ladder. Ladder ESP will be enabled.")
        if Character:GetAttribute("Climbing") then
            Character:SetAttribute("Climbing", false)
            TheMinesBypassed = true
            Library:Notification("Anticheat bypassed! This will last until the next cutscene. Halt will break this")
        else
            for _, v in pairs(CurrentRooms:GetDescendants()) do
                if v.Name == "Ladder" and v:IsA("Model") then
                    task.spawn(Functions.LadderESP, v)
                end
            end
        end
    else
        RemotesFolder.ClimbLadder:FireServer()
        TheMinesBypassed = false
        for _, v in pairs(ESPTable.Ladder) do
            v:Destroy()
        end
    end
end)

Toggles.noObstaclesToggle:OnChanged(function(value)
    if not IsFloor.Hotel or not IsFloor.Fools then
        return
    end
    for _, v in pairs(CurrentRoomModel.Assets:GetChildren()) do
        for i, obstr in pairs(v:GetDescendants()) do
            if obstr.Name == "Seek_Arm" or obstr.Name == "ChandelierObstruction" then
                for _, x in pairs(obstr:GetDescendants()) do
                    if x:IsA("BasePart") then
                        x.CanTouch = not value
                    end
                end
            end
        end
    end
end)

Toggles.BridgeWalk:OnChanged(function(value)
    if not IsFloor.Mines then
        return
    end
    if value then
        if CurrentRoomModel:FindFirstChild("Parts") then
            for _, v in pairs(CurrentRoomModel:FindFirstChild("Parts"):GetChildren()) do
                task.spawn(Functions.BridgePlatform, v)
            end
        end
    else
        for _, v in pairs(Bridges) do
            v:Destroy()
        end
    end
end)

Toggles.PromptClip:OnChanged(function(value)
    for _, v: ProximityPrompt in pairs(CurrentRooms:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if not v:GetAttribute("RequiresSight") then
                v:SetAttribute("RequiresSight", v.RequiresLineOfSight)
            end

            v.RequiresLineOfSight = not value
        end
    end
end)

Options.PromptReach:OnChanged(function(value)
    for _, v: ProximityPrompt in pairs(CurrentRooms:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if not v:GetAttribute("OGDistance") then
                v:SetAttribute("OGDistance", v.MaxActivationDistance)
            end

            v.MaxActivationDistance = v:GetAttribute("OGDistance") * value
        end
    end
end)

Options.BodyRotation:OnChanged(function(value)
    if value == "Normal" then
        Collision.Rotation = CollisionClone.Rotation
    elseif value == "Upside Down" then
        Collision.Rotation = Vector3.new(0, 0, -90)
    elseif value == "Up" then
        Collision.Rotation = Vector3.new(90, 0, CollisionClone.Rotation.Z)
    elseif value == "Left" then
        Collision.Rotation = Vector3.new(CollisionClone.Rotation.X, 90, CollisionClone.Rotation.Z)
    elseif value == "Right" then
        Collision.Rotation = Vector3.new(CollisionClone.Rotation.X, -90, CollisionClone.Rotation.Z)
    end
end)

Toggles.serverSideKillJeff:OnChanged(function(value)
    if not IsFloor.Fools then
        return
    end
    if value then
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "JeffTheKiller" then
                task.spawn(function()
                    repeat
                        task.wait()
                    until isnetworkowner(v.PrimaryPart) or not v or not v:IsDescendantOf(workspace) or not Toggles.serverSideKillJeff.Value

                    if v and Toggles.serverSideKillJeff.Value then
                        v.Torso.Name = math.random(1, 100)
                    end
                end)
            end
        end
    end
end)

Toggles.EntityESP:OnChanged(function(value)
    if value then
        for _, v in pairs(workspace:GetChildren()) do
            task.spawn(Functions.EntityESP, v)
        end

        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(Functions.SideEntityESP, v)
        end

    else
        for _, v in pairs(ESPTable.Entity) do
            v:Destroy()
        end

        for _, v in pairs(ESPTable.SideEntity) do
            v:Destroy()
        end
    end
end)

Toggles.DoorESP:OnChanged(function(value)
    if value then
        task.spawn(Functions.DoorESP, CurrentRoomModel)

        task.spawn(Functions.DoorESP, NextRoomModel)
    else
        for _, v in pairs(ESPTable.Door) do
            v:Destroy()
        end
    end
end)

Toggles.ObjectiveESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(Functions.ObjectiveESP, v)
        end
    else
        for _, esp in pairs(ESPTable.Objective) do
            esp:Destroy()
        end
    end
end)

Toggles.ItemESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(Functions.ItemESP, v)
        end

        for _, v in pairs(workspace.Drops:GetChildren()) do
            task.spawn(Functions.ItemESP, v, true)
        end
    else
        for _, v in pairs(ESPTable.Item) do
            v:Destroy()
        end

        for _, v in pairs(ESPTable.DroppedItem) do
            v:Destroy()
        end
    end
end)

Toggles.GoldESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel.Assets:GetDescendants()) do
            task.spawn(Functions.GoldESP, v)
        end
    else
        for _, v in pairs(ESPTable.Gold) do
            v:Destroy()
        end
    end
end)

Toggles.ChestESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            task.spawn(Functions.ChestESP, v)
        end
    else
        for _, v in pairs(ESPTable.Chest) do
            v:Destroy()
        end
    end
end)

Toggles.HidingSpotsESP:OnChanged(function(value)
    if value then
        for _, v in pairs(CurrentRoomModel.Assets:GetChildren()) do
            task.spawn(Functions.HidingSpotESP, v)
        end
    else
        for _, v in pairs(ESPTable.HidingSpot) do
            v:Destroy()
        end
    end
end)

if IsFloor.Mines then
    Toggles.GuidingLightESP:OnChanged(function(value)
        if value then
            for _, v in pairs(Camera:GetChildren()) do
                if v.Name == "Guidance" then
                    task.spawn(Functions.GuidingLightESP, v)
                end
            end
        end
    end)

    Options.GuidingLightESPColor:OnChanged(function(value)
        for _, v in pairs(ESPTable.GuidingLight) do
            v.CurrentSettings.Color = value
            v.CurrentSettings.FillColor = value
            v.CurrentSettings.OutlineColor = value
        end
    end)
end
Toggles.PlayerESP:OnChanged(function(value)
    if value then
        for _, player in pairs(Players:GetPlayers()) do
            task.spawn(Functions.PlayerESP, player)
        end
    else
        for _, v in pairs(ESPTable.Player) do
            v:Destroy()
        end
    end
end)

Options.EntityESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Entity) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.DoorESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Door) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.ObjectiveESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Objective) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.ItemESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Item) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.GoldESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Gold) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.ChestESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Chest) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.PlayerESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.Player) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Options.HidingSpotESPColor:OnChanged(function(value)
    for _, v in pairs(ESPTable.HidingSpot) do
        v.CurrentSettings.Color = value        
        v.CurrentSettings.FillColor = value
        v.CurrentSettings.OutlineColor = value
    end
end)

Toggles.RainbowESP:OnChanged(function(value)
    ESPLibrary.GlobalConfig.Rainbow = value
end)

Toggles.DistanceESP:OnChanged(function(value)
    ESPLibrary.GlobalConfig.Distance = value
end)

Toggles.Tracers:OnChanged(function(value)
    ESPLibrary.GlobalConfig.Tracers = value
end)

Options.TracerStart:OnChanged(function(value)
    for _, v in pairs(ESPTable) do
        for _, x in pairs(v) do
            x.CurrentSettings.Tracer = {
                Enabled = true,
                Color = x.CurrentSettings.Color,
                From = value
            }
        end
    end
end)

Options.TextSize:OnChanged(function(value)
    for _, v in pairs(ESPTable) do
        for _, x in pairs(v) do
            x.CurrentSettings.TextSize = value
        end   
    end
end)

Options.DoorESPTextMethod:OnChanged(function(value)
    for _, v in pairs(ESPTable.Door) do
        v.CurrentSettings.Name = string.format("Door %s %s", Functions.GetDoorText(v.CurrentSettings.Model.Parent), (if v.CurrentSettings.Model.Parent:GetAttribute("Opened") then "[Opened]" elseif v.CurrentSettings.Model.Parent.Parent:GetAttribute("RequiresKey") then "[Locked]" else ""))
    end
end)


Toggles.TranslucentCloset:OnChanged(function(value)
    if value then
        if Character:GetAttribute("Hiding") then
            for _, v in pairs(CurrentRoomModel:GetDescendants()) do
                if v.Name == "HiddenPlayer" then
                    if v.Value == Player or v.Value == Character then
                        for _, x in pairs(v.Parent:GetDescendants()) do
                            if x:IsA("BasePart") then
                                if x.Transparency ~= 1 then
                                    table.insert(Parts, x)
                                end
                            end
                        end
                    end
                end
            end

            task.spawn(function()
                repeat
                    task.wait()
                    for _, v in pairs(Parts) do
                        v.Transparency = Options.TransparencySlider.Value
                    end
                until not Character:GetAttribute("Hiding") or not Toggles.TranslucentCloset.Value

                for _, v in pairs(Parts) do
                    v.Transparency = 0
                end

                Parts = {}
            end)
        end
    end
end)

Toggles.NoFog:OnChanged(function(value)
    if value then
        game:GetService("Lighting").FogStart = 9e9
        game:GetService("Lighting").FogEnd = 9e9 

    else
        game:GetService("Lighting").FogStart = OldFogStart
        game:GetService("Lighting").FogEnd = OldFogEnd
    end
end)

Toggles.ambienceToggle:OnChanged(function(value)
    if value then
        game:GetService("Lighting").Ambient = Color3.new(1, 1, 1)
    else
        game:GetService("Lighting").Ambient = CurrentRoomModel:GetAttribute("Ambient")
    end
end)

if CurrentRoomModel:GetAttribute("RawName"):find("Halt") and Options.EntityNotifier.Value["Halt"] then
    Library:Notification("Halt will be in the next room.")
end

for _, v in pairs(CurrentRooms:GetDescendants()) do
    task.spawn(Functions.AssetCheck, v)
end

-- \ Main connections \ --
Library:GiveSignal(RunService.RenderStepped:Connect(function()


    if CurrentRoomModel:FindFirstChild("Door") and CurrentRoomModel:FindFirstChild("Door"):FindFirstChild("ClientOpen") and Toggles.DoorReach.Value then
        CurrentRoomModel:FindFirstChild("Door"):FindFirstChild("ClientOpen"):FireServer()
    end

    if Supported["require"] and Toggles.ViewmodelOffset.Value then
        require(MainGame).tooloffset = Vector3.new(Options.XOffset.Value, Options.YOffset.Value, Options.ZOffset.Value)
    end

    if Toggles.noeyes.Value and (workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("BackdoorLookman")) then
        RemotesFolder.MotorReplication:FireServer(-649)
    end


    if Toggles.ThirdPerson.Value then
        Camera.CFrame *= CFrame.new(2, 0.5, 6)
        Character.Head.LocalTransparencyModifier = 0

        for _, v in pairs(Character:GetChildren()) do
            if v:IsA("Accessory") then
                v:FindFirstChild("Handle").LocalTransparencyModifier = 0
            end
        end
    end

    if Toggles.DisableCameraShake.Value then
        require(MainGame).csgo = CFrame.new()
    end

    Camera.FieldOfView = Options.fovSlider.Value

    if Supported["require"] then
        require(MainGame).fovtarget = Options.fovSlider.Value
    end

    if Toggles.jump.Value and Humanoid then
        Humanoid.JumpHeight = Options.JumpHeight.Value
    end

    if Options.BodyRotation.Value == "Random" then
        Collision.Rotation = Vector3.new(math.random(-180, 180), math.random(-180, 180), CollisionClone.Rotation.Z)
    end

    if Toggles.Godmode.Value then
        local ray = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -9e9, 0), RaycastParam)
        if ray then
            Collision.Position = HumanoidRootPart.Position - Vector3.new(0, ray.Distance - 0.45, 0)
            CollisionClone.Position = HumanoidRootPart.Position
        end
    end

    if Toggles.SpamOtherTools.Value and Options.SpamOtherToolsKeybind:GetState() then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                for index, item in pairs(player.Backpack:GetChildren()) do
                    item:FindFirstChildWhichIsA("RemoteEvent"):FireServer()
                end
    
                for index, item in pairs(player.Character:GetChildren()) do
                    if item:IsA("Tool") then
                        item:FindFirstChildWhichIsA("RemoteEvent"):FireServer()
                    end
                end
            end
        end
    end



    if Toggles.FigureHearing.Value then
        RemotesFolder.Crouch:FireServer(true)
        Character:SetAttribute("Crouching", true)
    end


    Character:SetAttribute("Stunned", Toggles.StunToggle.Value)
    Humanoid.WalkSpeed = Options.Walkspeed.Value
    Humanoid.MaxSlopeAngle = Options.Slope.Value
    Character:SetAttribute("CanJump", Toggles.jump.Value)

    if Toggles.AutoBreakerBox.Value then
        if RemotesFolder:FindFirstChild("EBF") then
            RemotesFolder.EBF:FireServer()
        end
    end

    if CurrentRoomModel == nil then
        CurrentRoom = tostring(gameData.LatestRoom.Value)
    end

    

    if CollisionClone and Collision then
        if Toggles.Noclip.Value then
            if Character:FindFirstChild("UpperTorso") then
                Character.UpperTorso.CanCollide = not Toggles.Noclip.Value
            end

            if Character:FindFirstChild("LowerTorso") then
                Character.LowerTorso.CanCollide = not Toggles.Noclip.Valu
            end

            if HumanoidRootPart then
                HumanoidRootPart.CanCollide = not Toggles.Noclip.Value
            end

            Collision.CanCollide = not Toggles.Noclip.Value
        end
        Collision.CanCollide = not Toggles.Noclip.Value and (not Toggles.Godmode.Value)
        Collision.CollisionCrouch.CanCollide = not Toggles.Noclip.Value and (not Toggles.Godmode.Value)
    end

    if Toggles.AutoInteract.Value and Options.AutoInteractKey:GetState() then
        for _, v in pairs(GamePrompts) do
            if Functions.AvailablePrompt(v) then
                fireproximityprompt(v, true)
            end
        end
    end
end))


Library:GiveSignal(workspace.ChildAdded:Connect(function(child)

    task.spawn(Functions.EntityESP, child)

    if NotifyTable[Functions.ShortName(child)] and child:GetPivot().Position.Y > -10000 and Options.EntityNotifier.Value[Functions.ShortName(child)] then
        Library:Notification(NotifyTable[Functions.ShortName(child)].Notification)
    end

    if child.Name == "BananaPeel" then
        child.CanTouch = not Toggles.nobanana.Value
    end

    if Toggles.serverSideKillJeff.Value then
        if child.Name == "JeffTheKiller" then
            task.spawn(function()
                repeat
                    task.wait()
                until isnetworkowner(child) or not child or not child:IsDescendantOf(workspace) or not Toggles.serverSideKillJeff.Value

                if Toggles.serverSideKillJeff.Value and child then
                    child.Torso.Name = math.random(1, 50)
                end
            end)
        end
    end
end))


Library:GiveSignal(PxPromptService.PromptButtonHoldBegan:Connect(function(prompt, playerWhoTriggered)
    if Toggles.noewait.Value then
        if playerWhoTriggered == Player then
            fireproximityprompt(prompt, true)
        end
    end
end))

for _, plr in pairs(Players:GetPlayers()) do
    Connections[string.format("Items: %s", plr.DisplayName)] = plr.Character.ChildAdded:Connect(function(tool: Tool)
        if tool.Name:find("LibraryHintPaper") then

            if Toggles.plcode.Value then
                local code = Functions.PadlockCode(tool, plr)

                Library:Notification("The code is " .. code .. ".")
            end

            if Toggles.autopl.Value then
                local code = Functions.PadlockCode(tool, plr)
                RemotesFolder.PL:FireServer(code)
            end
        end
    end)
end

Library:GiveSignal(Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
    if Character:GetAttribute("Hiding") and Humanoid.MoveDirection.Magnitude > 0 then
        RemotesFolder.CamLock:FireServer()
    end
end))

Library:GiveSignal(CurrentRooms.ChildAdded:Connect(function(child)
    task.spawn(Functions.SetupRoom, child)
end))

Library:GiveSignal(workspace.Drops.ChildAdded:Connect(function(child: Instance)
    task.spawn(Functions.ItemESP, child, true)
end))

Library:GiveSignal(Player:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    if CurrentRoom == tostring(Player:GetAttribute("CurrentRoom")) then
        return
    end
    
        CurrentRoom = if CurrentRooms:FindFirstChild(tostring(Player:GetAttribute("CurrentRoom"))) then tostring(Player:GetAttribute("CurrentRoom")) else tostring(gameData.LatestRoom.Value)
        NextRoom = tostring(Player:GetAttribute("CurrentRoom") + 1)
        CurrentRoomModel = CurrentRooms:FindFirstChild(CurrentRoom)
        NextRoomModel = CurrentRooms:FindFirstChild(NextRoom)

        

        if Player:GetAttribute("CurrentRoom") ~= 100 then repeat task.wait() until CurrentRooms:FindFirstChild(NextRoom) end

        if Toggles.DoorESP.Value then
            for _, v in pairs(ESPTable.Door) do
                v:Destroy()
            end

            task.spawn(Functions.DoorESP, CurrentRoomModel)

            task.spawn(Functions.DoorESP, NextRoomModel)
        end

        task.spawn(Functions.ClearRoomESP)

        task.spawn(Functions.SetupCurrentRoomESP, CurrentRoomModel)

        if Toggles.BridgeWalk.Value and IsFloor.Mines and CurrentRoomModel:GetAttribute("Chase") then
            for _, v in pairs(CurrentRoomModel:FindFirstChild("Parts"):GetChildren()) do
                if v.Name == "Bridge" then
                    task.spawn(Functions.BridgePlatform, v)
                end
            end
        end
end))

Library:GiveSignal(Character:GetAttributeChangedSignal("Hiding"):Connect(function(value)
    if Toggles.TranslucentCloset.Value then
        for _, v in pairs(CurrentRoomModel:GetDescendants()) do
            if v.Name == "HiddenPlayer" then
                if v.Value == Player or v.Value == Character then
                    for _, x in pairs(v.Parent:GetDescendants()) do
                        if x:IsA("BasePart") then
                            if x.Transparency ~= 1 then
                                table.insert(Parts, x)
                            end
                        end
                    end
                end
            end
        end

        task.spawn(function()
            repeat
                task.wait()

                for _, v in pairs(Parts) do
                    v.Transparency = Options.TransparencySlider.Value
                end
            until not Character:GetAttribute("Hiding") or not Toggles.TranslucentCloset.Value

            for _, v in pairs(Parts) do
                v.Transparency = 0
            end

            Parts = {}
        end)
    end
end))

Library:GiveSignal(PxPromptService.PromptButtonHoldEnded:Connect(function(v, playerWhoTriggered)
    if not Toggles.InfUniversalKey.Value or not playerWhoTriggered == Player or IsFloor.Fools then
        return;
    end
    
    local DoorLock = v.Name == "UnlockPrompt" and v.Parent.Name == "Lock" and not v.Parent.Parent:GetAttribute("Opened")
    local Skull = v.Name == "SkullPrompt" and v.Parent.Name == "SkullLock"
    local ChestLock = v.Parent:GetAttribute("Category") and v.Parent:GetAttribute("Category") == "ChestLocked"
    local RoomsLock = v.Parent.Parent.Parent.Name == "RoomsDoor_Entrance" and v.Enabled

    if DoorLock or ChestLock or RoomsLock or Skull then
        if Character:FindFirstChildWhichIsA("Tool") then
            local tool = Character:FindFirstChildWhichIsA("Tool")

            if (tool and tool:GetAttribute("UniversalKey")) then
                if not ChestLock then
                    task.wait()
                end

                RemotesFolder.DropItem:FireServer(tool)

                workspace.Drops.ChildAdded:Once(function(v)
                    task.wait(.1)
                    fireproximityprompt(v:WaitForChild("ModulePrompt"), true)
                end)
            end
        end
    end
end))

Library:GiveSignal(Players.PlayerRemoving:Connect(function(plr)
    if Toggles.plrleave.Value then
        Library:Notification(plr.DisplayName .. " has left the game.")
    end
end))

Library:GiveSignal(Players.PlayerAdded:Connect(function(plr)
    Connections[string.format("Items: %s", plr.DisplayName)] = plr.Character.ChildAdded:Connect(function(tool: Tool)
        if tool.Name:find("LibraryHintPaper") then

            if Toggles.plcode.Value then
                local code = Functions.PadlockCode(tool, plr)
                
                Library:Notification("The code is " .. code .. ".")
            end

            if Toggles.autopl.Value then
                local code = Functions.PadlockCode(tool, plr)

                RemotesFolder.PL:FireServer(code)
            end
        end

    end)
end))

Library:GiveSignal(Humanoid.Died:Connect(function()
    if CollisionClone then
        CollisionClone:Destroy()
    end
end))


Library:GiveSignal(Humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
    if Humanoid.JumpHeight ~= Options.JumpHeight.Value and Toggles.jump.Value then
        Humanoid.JumpHeight = Options.JumpHeight.Value
    end
end))

Library:GiveSignal(game:GetService("Lighting"):GetPropertyChangedSignal("FogStart"):Connect(function()
    if Toggles.NoFog.Value then
        game:GetService("Lighting").FogStart = 9e9
        game:GetService("Lighting").FogEnd = 9e9
    end
end))

Library:GiveSignal(game:GetService("Lighting"):GetPropertyChangedSignal("FogEnd"):Connect(function()
    if Toggles.NoFog.Value then
        game:GetService("Lighting").FogStart = 9e9
        game:GetService("Lighting").FogEnd = 9e9
    end
end))

Library:GiveSignal(game:GetService("Lighting"):GetPropertyChangedSignal("Ambient"):Connect(function()
    if Toggles.ambienceToggle.Value then
        game:GetService("Lighting").Ambient = Color3.new(1, 1, 1)
    end
end))

Library:GiveSignal(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera

    Functions.SetupCamera(Camera)
end))

Library:GiveSignal(Character:GetAttributeChangedSignal("Climbing"):Connect(function()
    if Character:GetAttribute("Climbing") and Toggles.AnticheatBypass.Value and not TheMinesBypassed then
        Character:SetAttribute("Climbing", false)
        TheMinesBypassed = true
        Library:Notification("Anticheat bypassed! This will last until the next cutscene. Halt will break this.")
    end
end))



Functions.SetupCamera(Camera)
local MenuGroup = Tabs.Configs:AddLeftGroupbox("Menu")

MenuGroup:AddButton("Unload", function() task.spawn(Library.Unload) end)
MenuGroup:AddToggle("showKeybinds", {
    Text = "Show Keybinds",
    Default = false,
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end
})
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu Keybind" })
MenuGroup:AddToggle("KeepScript", {
    Text = "Execute On Teleport",
    Default = false
})
MenuGroup:AddToggle("CustomCursor", {
    Text = "Show Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end
})

Library:OnUnload(function()
    print("silly v2: Unloading...")
    ESPLibrary:Clear()
    Shade.Name = "Shade"
    screechModule.Name = "Screech"
    Glitch.Name = "Glitch"
    Void.Name = "Void"
    A90.Name = "A90"
    Dread.Name = "Dread"
    timothyModel.Name = "Spider"
    Humanoid.WalkSpeed = 16
    Collision.CanCollide = not Functions.GetCrouch()
    Collision.CollisionCrouch.CanCollide = Functions.GetCrouch()
    Collision.Rotation = CollisionClone.Rotation or Vector3.new(0, 0, 90)
    task.wait()
    if CollisionClone then
        CollisionClone:Destroy()
    end
    Character:SetAttribute("CanJump", false)
    Character:SetAttribute("Stunned", false)
    Humanoid.MaxSlopeAngle = 45
    FlyUtility:Stop()
    for _, v in pairs(CurrentRooms:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if v:GetAttribute("OGDistance") then
                v.MaxActivationDistance = v:GetAttribute("OGDistance")
            end
            if v:GetAttribute("RequiresSight") then
                v.RequiresLineOfSight = v:GetAttribute("RequiresSight")
            end
        end
        task.spawn(Functions.AssetCheck, v, true)
    end
    if Toggles.ViewmodelOffset.Value then
        require(MainGame).tooloffset = Vector3.new(0, 0.25, 0)
    end
    for _, v in pairs(Bridges) do
        if v and v.Parent then
            v:Destroy()
        end
    end
    table.clear(Bridges)
    for _, v in pairs(Connections) do
        if typeof(v) == "RBXScriptConnection" and v.Connected then
            task.wait()
            v:Disconnect()
        end
    end
    for _, v in pairs(Parts) do
        if v and v.Parent then
            v.Transparency = 0
        end
    end
    table.clear(Parts)
    table.clear(Connections)
    Light:Destroy()
    game:GetService("Lighting").Brightness = 1
    game:GetService("Lighting").Ambient = CurrentRoomModel:GetAttribute("Ambient")

    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "BananaPeel" then
            v.CanTouch = true
        end
    end
    getgenv().Loading = false
    getgenv().Loaded = false
    RemotesFolder.Crouch:FireServer(Collision.CollisionGroup == "PlayerCrouching")

    print("silly v2: Unloaded!")

end)

Library.ToggleKeybind = Options.MenuKeybind


ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)


SaveManager:IgnoreThemeSettings()


SaveManager:SetIgnoreIndexes({ "MenuKeybind" })


ThemeManager:SetFolder("silly v2")
SaveManager:SetFolder("silly v2/DOORS")

SaveManager:SetSubFolder(Floor)



SaveManager:BuildConfigSection(Tabs.Configs)


ThemeManager:ApplyToTab(Tabs.Configs)

SaveManager:LoadAutoloadConfig()

Player.OnTeleport:Connect(function()
    if Toggles.KeepScript.Value and not getgenv().queueing_on_teleport then
        getgenv().queueing_on_teleport = true
        queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Divinedfl/gui/refs/heads/main/thegui.luau'))()")
    end
end)

getgenv().Loading = false
getgenv().Loaded = true

print("silly v2: Loaded!")
