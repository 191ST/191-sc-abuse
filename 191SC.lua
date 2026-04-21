--[[
    PROXIMITY PROMPT EXPLOIT
    - Trigger prompt dari jarak jauh
    - Bypass jarak dan harga
    - GUI simpel dengan tombol
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Cari semua PromptPurchases
local promptPurchases = ReplicatedStorage:FindFirstChild("Workspace"):FindFirstChild("PromptPurchases")
if not promptPurchases then
    warn("PromptPurchases not found!")
end

-- === GUI SIMPEL ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PromptBuyExploit"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 120)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 200, 80)
stroke.Thickness = 1
stroke.Transparency = 0.5
stroke.Parent = mainFrame

mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔫 PROMPT BUY EXPLOIT"
title.TextColor3 = Color3.fromRGB(80, 200, 80)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Tombol SPAWN PROMPT
local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(0.8, 0, 0, 40)
spawnBtn.Position = UDim2.new(0.1, 0, 0, 40)
spawnBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
spawnBtn.Text = "🔥 GET G17 DUAL LASER 🔥"
spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnBtn.TextSize = 12
spawnBtn.Font = Enum.Font.GothamBold

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = spawnBtn

spawnBtn.Parent = mainFrame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 1, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Close button kecil
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Draggable
local dragStart, startPos, dragging = nil, nil, false
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- === FUNGSI UTAMA EXPLOIT ===
local function triggerProximityPrompt(targetItem)
    if not targetItem then
        statusLabel.Text = "ERROR: Item not found!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return false
    end
    
    -- Cari ProximityPrompt di dalam item
    local proxPrompt = targetItem:FindFirstChild("proxprompt")
    if proxPrompt then
        proxPrompt = proxPrompt:FindFirstChild("ProximityPrompt")
    end
    
    if not proxPrompt then
        -- Coba cari langsung
        proxPrompt = targetItem:FindFirstChildWhichIsA("ProximityPrompt")
    end
    
    if proxPrompt then
        -- METHOD 1: Trigger langsung (jika tidak ada jarak check)
        pcall(function()
            proxPrompt:Prompt(LP)
        end)
        
        statusLabel.Text = "SUCCESS! Prompt triggered"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        return true
    end
    
    return false
end

-- METHOD 2: Clone and Teleport (Advanced)
local function cloneAndTrigger()
    local targetPath = ReplicatedStorage:FindFirstChild("Workspace"):FindFirstChild("PromptPurchases"):FindFirstChild("G17 Dual Laser Drum")
    
    if not targetPath then
        statusLabel.Text = "ERROR: G17 Dual Laser Drum not found!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return false
    end
    
    -- Clone item ke workspace agar bisa di-trigger
    local clonedItem = targetPath:Clone()
    clonedItem.Parent = workspace
    
    -- Cari ProximityPrompt di clone
    local proxPrompt = nil
    for _, child in pairs(clonedItem:GetDescendants()) do
        if child:IsA("ProximityPrompt") then
            proxPrompt = child
            break
        end
    end
    
    if proxPrompt then
        -- Teleport prompt ke dekat player (bypass jarak)
        local fakePart = Instance.new("Part")
        fakePart.Size = Vector3.new(1,1,1)
        fakePart.CFrame = LP.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
        fakePart.Anchored = true
        fakePart.Transparency = 1
        fakePart.CanCollide = false
        fakePart.Parent = workspace
        
        -- Pindahkan prompt ke fake part
        proxPrompt.Parent = fakePart
        
        -- Trigger prompt
        pcall(function()
            proxPrompt:Prompt(LP)
        end)
        
        task.wait(0.5)
        fakePart:Destroy()
        clonedItem:Destroy()
        
        statusLabel.Text = "SUCCESS! Clone & trigger method"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        return true
    end
    
    clonedItem:Destroy()
    return false
end

-- METHOD 3: RemoteEvent Spoofing (jika ada)
local function findAndFireRemote()
    local target = ReplicatedStorage:FindFirstChild("Workspace"):FindFirstChild("PromptPurchases"):FindFirstChild("G17 Dual Laser Drum")
    
    -- Cari RemoteEvent di sekitar item
    for _, obj in pairs(target:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function()
                obj:FireServer("Purchase", "G17 Dual Laser Drum")
            end)
            statusLabel.Text = "RemoteEvent fired: " .. obj.Name
            return true
        end
    end
    
    return false
end

-- === TOMBOL ACTION ===
spawnBtn.MouseButton1Click:Connect(function()
    spawnBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    spawnBtn.Text = "🔥 PROCESSING 🔥"
    statusLabel.Text = "Scanning for vulnerability..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    
    task.wait(0.3)
    
    -- Cari target item
    local targetItem = ReplicatedStorage:FindFirstChild("Workspace"):FindFirstChild("PromptPurchases"):FindFirstChild("G17 Dual Laser Drum")
    
    if not targetItem then
        statusLabel.Text = "ERROR: Item not found in ReplicatedStorage!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        spawnBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
        spawnBtn.Text = "🔥 GET G17 DUAL LASER 🔥"
        return
    end
    
    -- Method 1: Direct Prompt
    local success1 = triggerProximityPrompt(targetItem)
    
    if success1 then
        spawnBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
        spawnBtn.Text = "🔥 GET G17 DUAL LASER 🔥"
        return
    end
    
    -- Method 2: Clone & Teleport
    task.wait(0.2)
    statusLabel.Text = "Method 1 failed, trying clone method..."
    local success2 = cloneAndTrigger()
    
    if success2 then
        spawnBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
        spawnBtn.Text = "🔥 GET G17 DUAL LASER 🔥"
        return
    end
    
    -- Method 3: RemoteEvent
    task.wait(0.2)
    statusLabel.Text = "Method 2 failed, trying RemoteEvent..."
    local success3 = findAndFireRemote()
    
    if success3 then
        spawnBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
        spawnBtn.Text = "🔥 GET G17 DUAL LASER 🔥"
        return
    end
    
    -- All methods failed
    statusLabel.Text = "FAILED! Game might be protected"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    spawnBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    spawnBtn.Text = "🔥 GET G17 DUAL LASER 🔥"
end)

print("Prompt Buy Exploit Loaded")
print("Target: G17 Dual Laser Drum")
