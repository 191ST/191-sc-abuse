-- ============================================
-- SOUTH BRONX: THE TRENCHES
-- AUTO MARSHMALLOW FARM
-- Created By: Rafif
-- Loadstring Version
-- ============================================

-- KONFIGURASI
local config = {
    autoFarm = true,
    autoSell = true,
    autoCollect = true,
    maxBags = 10,
    farmSpeed = 0.5,
    antiAfk = true,
    antiCheat = true,
    teleportSpeed = 50,
    safeMode = true
}

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- VARIABLES
local farming = false
local character, humanoid, rootPart

-- ANTI CHEAT BYPASS - By Rafif
local function antiCheatBypass()
    if not config.antiCheat then return end
    print("🔒 Anti-Cheat Bypass By Rafif")
    
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            print("🛡️ Kick blocked")
            return nil
        end
        if method == "FireServer" and self:IsA("RemoteEvent") then
            local name = self.Name:lower()
            if name:find("kick") or name:find("ban") or name:find("detect") then
                return nil
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    
    spawn(function()
        while config.antiCheat do
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum and math.random() > 0.95 then
                    hum.WalkSpeed = hum.WalkSpeed + (math.random() * 0.1 - 0.05)
                    wait(0.1)
                    hum.WalkSpeed = 16
                end
            end
            wait(math.random(1, 3))
        end
    end)
end

-- UTILITY
local function getCharacter()
    character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    return character, humanoid, rootPart
end

local function safeTeleport(position)
    local char, hum, root = getCharacter()
    if not root then return end
    if config.safeMode then
        position = position + Vector3.new(math.random(-2, 2) * 0.1, 0, math.random(-2, 2) * 0.1)
    end
    local distance = (position - root.Position).Magnitude
    local time = math.min(distance / config.teleportSpeed, 3)
    if config.safeMode then time = time * (0.9 + math.random() * 0.2) end
    TweenService:Create(root, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(position)}):Play()
    wait(time)
end

local function safeWait(min, max)
    wait(config.safeMode and (min + math.random() * (max - min)) or min)
end

local function fireProx(obj)
    if not obj then return false end
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
    if prompt then fireproximityprompt(prompt) return true end
    return false
end

-- FIND FUNCTIONS
local function findMarshmallows()
    local spots = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent then
            local name = obj.Name:lower()
            if name:find("mallow") or name:find("marsh") or name:find("campfire") or name:find("fire") then
                table.insert(spots, obj)
            end
        end
    end
    if config.safeMode then
        for i = #spots, 2, -1 do
            local j = math.random(i)
            spots[i], spots[j] = spots[j], spots[i]
        end
    end
    return spots
end

local function findSell()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("sell") or name:find("dealer") or name:find("buyer") then
            return obj
        end
    end
    return nil
end

-- ANTI AFK
if config.antiAfk then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        safeWait(0.5, 1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end

-- FARM LOOP
local function farmLoop()
    while farming do
        local success, err = pcall(function()
            local spots = findMarshmallows()
            for _, spot in ipairs(spots) do
                if not farming then break end
                if spot and spot.Parent then
                    safeTeleport(spot.Position + Vector3.new(0, 2, 0))
                    safeWait(0.2, 0.5)
                    fireProx(spot)
                    if spot:FindFirstChild("ClickDetector") then
                        fireclickdetector(spot.ClickDetector)
                    end
                    if spot.Name:lower():find("fire") then
                        safeWait(config.farmSpeed * 0.8, config.farmSpeed * 1.2)
                    end
                    safeWait(0.1, 0.3)
                end
            end
            
            if config.autoSell then
                local bags = 0
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item.Name:lower():find("bag") or item.Name:lower():find("mallow") then
                            bags = bags + 1
                        end
                    end
                end
                if bags >= config.maxBags + math.random(-2, 2) then
                    local sell = findSell()
                    if sell then
                        safeTeleport(sell:GetPivot().Position + Vector3.new(0, 3, 0))
                        safeWait(0.3, 0.8)
                        fireProx(sell)
                        safeWait(0.5, 1.5)
                    end
                end
            end
        end)
        if not success then safeWait(0.5, 1) end
        safeWait(0.05, 0.2)
    end
end

-- TOGGLE
local function toggleFarm()
    farming = not farming
    if farming then
        print("🟢 By Rafif: FARMING STARTED")
        spawn(farmLoop)
        return true
    else
        print("🔴 By Rafif: FARMING STOPPED")
        return false
    end
end

-- GUI
local function createGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ByRafif_Farm"
    gui.ResetOnSpawn = false
    gui.Parent = game.CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 100, 0, 100)
    frame.Position = UDim2.new(0.05, 0, 0.8, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = gui
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 80)
    button.Position = UDim2.new(0.5, -40, 0.5, -40)
    button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    button.BorderSizePixel = 0
    button.Text = "⏹"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 35
    button.Font = Enum.Font.GothamBold
    button.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Thickness = 3
    stroke.Parent = button
    
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1.5, 0, 1.5, 0)
    glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://1082264633"
    glow.ImageColor3 = Color3.fromRGB(255, 100, 100)
    glow.ImageTransparency = 0.8
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(10, 10, 118, 118)
    glow.ZIndex = -1
    glow.Parent = button
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, -0.3, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "By Rafif"
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = frame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 20)
    statusLabel.Position = UDim2.new(0, 0, 1.05, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "STOPPED"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextStrokeTransparency = 0.5
    statusLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Parent = frame
    
    local function clickEffect()
        button.Size = UDim2.new(0, 70, 0, 70)
        button.Position = UDim2.new(0.5, -35, 0.5, -35)
        wait(0.1)
        button.Size = UDim2.new(0, 80, 0, 80)
        button.Position = UDim2.new(0.5, -40, 0.5, -40)
    end
    
    button.MouseButton1Click:Connect(function()
        clickEffect()
        local isFarming = toggleFarm()
        if isFarming then
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            button.Text = "▶"
            glow.ImageColor3 = Color3.fromRGB(100, 255, 100)
            statusLabel.Text = "FARMING"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            spawn(function()
                while farming do
                    TweenService:Create(glow, TweenInfo.new(1), {ImageTransparency = 0.6}):Play()
                    wait(1)
                    TweenService:Create(glow, TweenInfo.new(1), {ImageTransparency = 0.8}):Play()
                    wait(1)
                end
            end)
        else
            button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            button.Text = "⏹"
            glow.ImageColor3 = Color3.fromRGB(255, 100, 100)
            statusLabel.Text = "STOPPED"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    local dragging = false
    local dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = farming and Color3.fromRGB(70, 220, 70) or Color3.fromRGB(220, 70, 70)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = farming and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)}):Play()
    end)
end

-- INIT
antiCheatBypass()
createGUI()
print([[
========================================
🍬 MARSHMALLOW AUTOFARM
👤 By Rafif
🔒 Anti-Cheat: Active
========================================
]])
